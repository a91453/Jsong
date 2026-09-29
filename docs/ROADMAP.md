# Roadmap

Jsong 取代已停止託管的 JSONG-TRANS 網站（Next.js）。網站的功能是規格來源，逐步改寫成原生 SwiftUI；每個 Phase 拆成可 review 的小 PR。各階段只是方向，實際範圍依前一階段的成果調整。

開發流程與 railway-game-ios 相同，不需要自己的 Mac：

```
Claude Code Cloud (Linux) → GitHub → GitHub Actions macOS (Xcode / Simulator) → 截圖 artifact / TestFlight → iPhone / iPad
```

## Phase 1 — 原型移植與發佈管線 ✅（本 PR）

- iPad Swift Playgrounds 原型（`Jsong.swiftpm`）改成 Swift Package ＋ XcodeGen 專案：
  - `JsongCore`：五十音（平假名、片假名各 104 字）、100 個單字（含例句）、四種測驗、回音練習法、配對遊戲、進度與連續天數
  - `JsongPresentation`：`ProgressStore`（唯一的進度擁有者、存檔）、顯示文字
  - `JsongApp`：原型的全部畫面（學習、練習、測驗、進度四個分頁）
- 修正原型的問題：測驗選項每次畫面更新都重新洗牌、`ka` 題出現「カ」這類第二個正確答案、重複選項、連續天數過期仍顯示、五十音表在窄螢幕重疊、靜音模式聽不到發音
- Linux CI（Swift 6.0 / 6.2.4 / 6.4）、macOS 編譯與專案一致性檢查、Visual Smoke 截圖、未簽章 Release Archive
- GitHub Actions → 內部 TestFlight（腳本與 railway-game-ios 相同）

## 發佈 — 第一次內部 TestFlight

- 由你完成 [TESTFLIGHT_GITHUB_ACTIONS.md](TESTFLIGHT_GITHUB_ACTIONS.md) 的步驟 1–7（Bundle ID `io.github.a91453.Jsong`、App record、API key、GitHub environment），再從 `main` 手動執行 **TestFlight (internal)**。
- 第一次真實執行同時驗證雲端簽章在 GitHub runner 上的行為。

## Phase 2 — 歌曲與歌詞

網站的核心：用歌詞學日文。

- JsongCore：LRC 與 SRT 解析（網站的 `parseLRC`、`parseSRT`）、歌詞時間軸
- LrcLib 搜尋（`lrclib.net`，免金鑰）
- 從「檔案」App 匯入 LRC / SRT / TXT
- 歌曲庫存在手機上；歌詞閱讀畫面

## Phase 3 — AI 振假名與翻譯

- 學習者在設定頁貼上自己的 Gemini 或 Groq API key，存在 iOS 鑰匙圈（Keychain），不放 UserDefaults
- 逐行加上振假名與中文翻譯（網站的 `analyze-video` / `annotateNode`）、解釋句子、單字翻譯
- 模型清單從 API 讀取，不寫死型號與免費額度
- 結果存在手機上，同一首歌不重複呼叫

## Phase 4 — YouTube 播放與歌詞同步

- 以 WKWebView 載入 YouTube IFrame Player，依播放時間標示目前的歌詞行
- 嵌入播放器的 Error 153（缺少 Referer）：原生 App 可用 `https` 的 baseURL 載入播放器頁面；**UNVERIFIED**，要在這個階段的 Visual Smoke / TestFlight 確認
- 不下載 YouTube 音訊或字幕（YouTube 服務條款、App Store 審核規範 5.2.3）

## Phase 5 — 字典、收藏與複習

- 從歌詞把單字加入個人字典與收藏（網站的 `/dictionary`、`/favorites`）
- 複習排程，並讓測驗與回音練習使用個人字典

## 之後（網站有、暫時拿掉的功能）

- 跨裝置同步：評估 iCloud（CloudKit）
- 語音聽寫（Groq Whisper）：只考慮學習者自己提供的音訊檔
- 外部 TestFlight 與 App Store 上架：另行規劃（需要隱私權政策、截圖、審核資訊）
