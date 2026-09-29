# Architecture

## 分層

```
┌───────────────────────────┐
│ App（JsongApp/）            │  SwiftUI 畫面、手勢、動畫、語音（AVSpeechSynthesizer）
├───────────────────────────┤
│ JsongPresentation          │  ProgressStore（唯一的進度擁有者、存檔）、DisplayText（顯示文字）
└────────────┬──────────────┘
             │ 讀取狀態、呼叫方法
┌────────────▼──────────────┐
│ JsongCore                  │  五十音與單字資料、測驗、回音練習、配對遊戲、
│  Kana / Vocabulary / Quiz / │  進度與連續天數規則
│  Practice / Progress        │
└───────────────────────────┘
```

- **JsongCore**：學習內容與規則。只依賴 Swift 標準函式庫與 Foundation，不 import SwiftUI、UIKit、AVFoundation；CI 在 Linux 上建置與測試，因此誤用 Apple 專屬框架會直接編譯失敗。
- **JsongPresentation**：與平台無關的呈現邏輯。`ProgressStore`（`@MainActor`、`@Observable`）持有 App 唯一一份 `UserProgress` 並在每次變更後存檔；`DisplayText` 是學習者看到的文字（繁體中文）。同樣在 Linux 上測試。
- **App**：只有 SwiftUI。`@main` App 以 `@State` 持有唯一一個 `ProgressStore`，透過 `environment` 交給畫面。畫面可以保存暫時狀態（目前的測驗、配對遊戲、動畫），但進度只能透過 `ProgressStore` 的方法改變。

## 架構決策

### 1. 值型別與注入的隨機數

`QuizSession`、`EchoSession`、`MatchingGame`、`UserProgress` 都是 `Sendable` 的 struct，只能透過 mutating 方法改變，並保證「無效操作不改變任何東西」（例如同一題回答兩次、在錯誤的階段結束單字）。需要隨機的地方都接受 `RandomNumberGenerator`：App 用系統亂數，測試用固定 seed 的 SplitMix64，因此同一個 seed 一定得到同一份題目。測試只比較「同 seed 兩次結果相同」，不寫死洗牌後的順序（標準函式庫不保證不同 Swift 版本的洗牌演算法相同）。

### 2. 測驗題目的正確性

一個提示可能有多個正確答案：羅馬字 `ka` 同時是「か」和「カ」，「月」同時是「月份」和「月亮」。`QuizGenerator` 先找出提示的所有正確答案，干擾選項只從其他答案中挑，所以一題不會出現兩個正確選項；選項在出題時就決定順序並保證不重複。每題的干擾選項各自重新洗牌。

原型的三個問題因此修正：選項在每次畫面更新時重新洗牌（按下後按鈕會換位置）、`ka` 題可能出現「カ」、不足三個干擾選項時以重複選項補齊（SwiftUI `ForEach` 的 id 重複）。

### 3. 連續天數與 `StudyDay`

連續天數比較的是「學習者所在時區的日曆日」，不是時間點。`StudyDay` 是 Gregorian 的年月日值，`dayNumber` 是自 1970-01-01 起的天數，相鄰兩天恰好差 1（跨月、跨年、閏年都一樣）。`Date` 轉成 `StudyDay` 只在 JsongPresentation 做，而且固定使用 Gregorian 曆，不受裝置設定的和曆或佛曆影響。

- 同一天重複學習只算一次；隔天學習 +1；中間漏掉一天以上重新從 1 開始。
- 比上次學習更早的日期（裝置時鐘被調回）不改變任何東西。
- 顯示用的 `currentStreak(on:)`：今天或昨天有學習才算數，否則為 0（原型會一直顯示過期的天數）。
- 標記「已學會」與完成測驗算學習；取消「已學會」不算。

### 4. 存檔

`UserProgress` 以 JSON 存在 `UserDefaults` 的 `progress.v1`：key 排序、集合寫成排序後的陣列、日期為 1970 起的秒數，因此同樣的進度永遠編碼成同樣的位元組。解碼時驗證不變量（連續天數與最後學習日一致、測驗答對數在 0…題數之間），壞資料會丟出錯誤而不是產生不一致的狀態。

讀不出來的資料（損壞，或來自不相容的版本）會先另存到 `progress.v1.unreadable`，App 從空白進度開始；在下一次變更之前原資料也不會被覆寫。目前沒有版本遷移；格式需要改變時，新增 `progress.v2` 與遷移。

**JsongCore 的 ID 與 enum raw value 都是存檔資料**：五十音 `hira_ka`、單字 `v_arigatou`、`QuizType.kanaToRomaji` 等。改名會讓學習者失去那一項的進度，除非同一個 PR 加上遷移。顯示文字因此放在 `DisplayText`，改文字不影響存檔。

使用 `UserDefaults` 是因為資料很小（幾百個 ID 與測驗紀錄），它是 Apple 規定需要在 privacy manifest 聲明原因的 API，`JsongApp/Resources/PrivacyInfo.xcprivacy` 以 `CA92.1`（只供 App 自己讀寫）聲明。等歌曲與歌詞這類較大的資料出現時再評估 SwiftData 或檔案。

### 5. 語音

`SpeechSynthesizer.shared` 是全 App 唯一的 `AVSpeechSynthesizer`，新的發音會先停止上一個。音訊 session 用 `.playback`／`.spokenAudio`，因為發音只在學習者按下按鈕時播放，靜音開關打開時也應該聽得到；`.mixWithOthers` 讓背景音樂繼續播放。

### 6. 只在 Debug 的啟動參數

`JsongApp/App/DemoLaunch.swift` 整個包在 `#if DEBUG` 裡：`-demo-tab <learn|practice|quiz|progress>` 開啟指定分頁，`-demo-progress` 以只存在記憶體的範例進度啟動。Visual Smoke 用它們截圖；`release-archive.yml` 檢查 Release 執行檔不含這些字串。

### 7. 為什麼不再使用 Swift Playgrounds 的 `.swiftpm`

原型是 iPad Swift Playgrounds 專案。改成 Swift Package ＋ XcodeGen 專案，與 railway-game-ios 相同，好處是：核心邏輯能在 Linux（Claude Code 雲端環境與 CI）上測試；App 能在 GitHub Actions 的 macOS 上編譯、截圖、簽章並上傳 TestFlight，不需要自己的 Mac。
