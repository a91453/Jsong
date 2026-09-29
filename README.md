# Jsong

用歌曲學日文的 iPhone / iPad App。取代已停止託管的 [JSONG-TRANS](https://github.com/a91453/JSONG-TRANS) 網站，以原生 SwiftUI 逐步重寫它的功能。

## 目前狀態

**Phase 1 — 原型移植與發佈管線.**

App 目前有原型的四個分頁：

- **學習**：平假名、片假名五十音表（依基本／濁音／拗音篩選）、單字詳細資料（筆畫數、記憶提示、發音）、翻牌閃卡（右滑＝已學會）、10 類共 100 個單字（含例句與發音）
- **練習**：回音練習法（看字 → 讀音 → 意思 → 例句 → 自我檢測）、假名與羅馬字配對遊戲
- **測驗**：假名 → 羅馬字、羅馬字 → 假名、詞彙 → 意思、意思 → 詞彙，每次 10 題
- **進度**：連續學習天數、測驗次數、五十音與單字進度、最近 10 次測驗紀錄

進度只存在手機上。歌詞、AI 振假名與翻譯、YouTube 播放等網站功能依 [docs/ROADMAP.md](docs/ROADMAP.md) 分階段加入。

## 技術方向

- Swift 6（language mode 6，`swift-tools-version: 6.0`），CI 驗證 Swift 6.0、6.2.4、6.4
- Swift Package Manager：`JsongCore`、`JsongPresentation`
- SwiftUI（iOS 17+，iPhone / iPad）
- XcodeGen（由 `JsongApp/project.yml` 產生 Xcode 專案，產生結果提交進版控）

```
Sources/JsongCore/
  Kana/        KanaCharacter、KanaGroup、HiraganaData、KatakanaData
  Vocabulary/  VocabularyWord、VocabularyCategory、VocabularyData
  Quiz/        QuizType、QuizQuestion、QuizGenerator、QuizSession、QuizResult
  Practice/    EchoSession（回音練習法）、MatchingGame（配對遊戲）
  Progress/    UserProgress（已學會、測驗紀錄、連續天數）、StudyDay
Sources/JsongPresentation/
  ProgressStore（唯一的進度擁有者）、ProgressStorage（UserDefaults）、DisplayText（顯示文字）
Tests/JsongCoreTests/、Tests/JsongPresentationTests/
JsongApp/
  project.yml       XcodeGen spec（專案設定的唯一來源）
  Jsong.xcodeproj   由 project.yml 產生並提交，不要手改
  App/              JsongApp（@main，持有 ProgressStore）、DemoLaunch（僅 Debug，截圖用）
  Views/            Learn、Practice、Quiz、Progress、Components
  Support/          顏色與圖示、語音、亂數
  Resources/        Assets.xcassets（App Icon）、PrivacyInfo.xcprivacy
```

分層與設計決策見 [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。

## 開發流程（cloud-first）

不需要自己的 Mac，也不依賴 Swift Playgrounds：

```
Claude Code Cloud (Linux) → GitHub → GitHub Actions macOS (Xcode / Simulator) → 截圖 artifact / TestFlight → iPhone / iPad
```

| 層 | 在哪裡跑 | 驗證什麼 |
| --- | --- | --- |
| 1. Claude Code Cloud | Linux 容器 | 原始碼開發；`swift build` / `swift test`。**沒有** Xcode、Simulator、SwiftUI |
| 2. Linux CI（`ci.yml`） | 每次 push / PR | JsongCore 與 JsongPresentation 在 Swift 6.0、6.2.4、6.4 的 build（warnings as errors）與 test |
| 3. iOS App Build（`ios-build.yml`） | macOS runner，PR 與 `main` 自動執行（純文件變更略過） | 已提交的 Xcode 專案與 `project.yml` 一致；以真正的 Xcode 為 iOS Simulator 編譯 App；不需簽章 |
| 4. Visual Smoke（`visual-smoke.yml`） | macOS runner，**手動**觸發（修改它的 PR 自動執行） | iPhone 四個分頁與 iPad 兩個分頁的 Simulator 截圖，確認沒有閃退 |
| 5. Release Archive（`release-archive.yml`） | macOS runner，手動；修改專案設定或 App 資源的 PR 自動執行 | Release 裝置 Archive（**未簽章**）、App Icon、privacy manifest、Release 不含 Debug 參數 |
| 6. TestFlight Checks（`testflight-checks.yml`） | Linux + macOS；修改發佈腳本的 PR 自動執行 | 發佈腳本的 lint 與測試、macOS dry run；只用假值 |
| 7. TestFlight（`testflight.yml`） | macOS runner，**只能從 `main` 手動**觸發 | 簽章 Archive → 匯出 IPA → 檢查 → 上傳 App Store Connect → 內部 TestFlight |

TestFlight 的一次性設定（Bundle ID、App record、API key、GitHub environment）見 [docs/TESTFLIGHT_GITHUB_ACTIONS.md](docs/TESTFLIGHT_GITHUB_ACTIONS.md)。如果 railway-game-ios 已經有 Team API key，可以沿用同一把。

### 在 iPhone / iPad 上查看截圖

1. GitHub → **Actions** → 左側選 **Visual Smoke** → **Run workflow**（選擇分支）→ **Run workflow**
2. 等待執行完成
3. 打開該次執行的 Summary 頁面 → **Artifacts** → 下載 **visual-smoke**
4. zip 內含 `iphone-learn.png`、`iphone-practice.png`、`iphone-quiz.png`、`iphone-progress.png`（範例進度）、`ipad-learn.png`、`ipad-progress.png`，以及 `simulator.log`、`xcodebuild.log`

Artifact 只保留 7 天。只有 workflow 檔已經在 `main` 時，GitHub 才會顯示 **Run workflow** 按鈕。

## Building

套件（任何有 Swift 6 的環境，包括 Linux）：

```sh
swift build
```

iOS App 需要 macOS + Xcode 16 以上（上傳 App Store Connect 需要 Xcode 26 以上，由 `testflight.yml` 建置）：

```sh
open JsongApp/Jsong.xcodeproj
```

`Jsong.xcodeproj` 由 `project.yml` 以 [XcodeGen](https://github.com/yonaskolb/XcodeGen) 產生並**提交進版控**。專案設定一律改 `project.yml`；改了設定，或新增、刪除、改名 App 的原始檔或資源後，重新產生並一起提交：

```sh
xcodegen generate --spec JsongApp/project.yml
```

- 使用 `.github/actions/setup-xcodegen/action.yml` 固定的 XcodeGen 版本；Linux 上從同一版本的原始碼建置，步驟見 `CLAUDE.md`。
- 在名為 `Jsong` 的資料夾（`git clone` 的預設名稱）中執行。
- 不要手改 `.xcodeproj`，也不要在 Xcode 的專案編輯器修改設定。`ios-build.yml` 會重新產生並比對，不一致就失敗，並附上預期專案的 `regenerated-xcodeproj` artifact。

## Testing

```sh
swift test
```

測試涵蓋內建資料（字數、ID 唯一、每種文字內羅馬字不重複）、測驗（選項唯一、不會有第二個正確答案、同 seed 同題目）、測驗流程、回音練習、配對遊戲、連續天數（跨月、跨年、閏年、時鐘倒退、時區）、存檔格式與壞資料處理、顯示文字。隨機的部分以固定 seed 的 SplitMix64 產生，每次執行結果相同。
