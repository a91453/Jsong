# CLAUDE.md

Instructions for Claude Code sessions in this repository.

## Project

Jsong, a native iPhone / iPad app for learning Japanese (kana, vocabulary,
quizzes; later songs with lyrics, furigana and AI translation). It replaces the
JSONG-TRANS website (Next.js), whose hosting is shut down; that repository is
the feature reference for the phases in `docs/ROADMAP.md`. The workflow copies
`a91453/railway-game-ios`.

- `Sources/JsongCore/` — Swift package target with the learning content and
  rules: kana and vocabulary data, quiz generation and sessions, Echo Method
  and matching game sessions, progress and daily streaks. Tests:
  `Tests/JsongCoreTests/`.
- `Sources/JsongPresentation/` — platform-independent presentation logic:
  `ProgressStore` (the app's single progress owner, persistence) and
  `DisplayText` (text the learner sees). Tests: `Tests/JsongPresentationTests/`.
- `JsongApp/` — SwiftUI app. Its Xcode project (`Jsong.xcodeproj`, with the
  shared `Jsong` scheme) is generated from `JsongApp/project.yml` by XcodeGen
  and **committed**. `project.yml` is the source of truth: change it,
  regenerate (see below), and commit both. Never hand-edit the `.xcodeproj`.
- `.github/workflows/` — `ci.yml` (packages on Linux, Swift 6.0 / 6.2.4 /
  6.4), `ios-build.yml` (committed-project drift check and Simulator build on
  macOS), `visual-smoke.yml` (Simulator screenshots; manual, and on PRs that
  change it), `release-archive.yml` (unsigned Release device archive; manual,
  and on PRs that change project settings or app resources), `testflight.yml`
  (signed archive → IPA → App Store Connect; `workflow_dispatch` from `main`
  only, secrets in the `testflight` environment), `testflight-checks.yml`
  (release scripts with fake values and a macOS dry run; no secrets).
- Distribution: GitHub Actions → internal TestFlight
  (`docs/TESTFLIGHT_GITHUB_ACTIONS.md`).

## Architecture rules

Read and respect `docs/ARCHITECTURE.md`. In short:

- JsongCore and JsongPresentation must stay platform-independent: never
  import SwiftUI, UIKit, AppKit, AVFoundation or other Apple-only frameworks
  there. Foundation is allowed. Linux CI enforces this.
- `ProgressStore` is the only owner of `UserProgress`. Views keep transient UI
  state (selection, animation, the current quiz or game session) but change
  progress only through `ProgressStore` methods.
- Core types are `Sendable` value types. Randomness is injected
  (`RandomNumberGenerator`) and dates enter as `StudyDay`, so rules are
  deterministic and tested with seeded generators.
- IDs and enum raw values in JsongCore are saved data (`progress.v1`).
  Renaming one loses the learner's progress for it; do not, unless the PR adds
  a migration.
- Learner-facing text lives in `DisplayText` (JsongPresentation) or the views,
  not in JsongCore identifiers.
- Do not raise `swift-tools-version` (6.0) or drop Swift 6.0 compatibility
  without a concrete technical reason.

## Environments and validation

- Claude Code cloud sessions run on **Linux**: `swift build` and `swift test`
  work for the packages. If `swift` is missing, install the official Swift
  toolchain for Linux from swift.org (6.2.4 is what earlier sessions used).
  Xcode, `xcodebuild`, the iOS Simulator, SwiftUI and UIKit are **not**
  available there, so the app target only compiles in macOS CI.
- XCTest on Linux cannot run `@MainActor` test classes: test main-actor code
  from `async` test methods with `await MainActor.run { ... }`.
- Apple-only checks run only in GitHub Actions on macOS (`ios-build.yml`,
  `visual-smoke.yml`, `release-archive.yml`, `testflight-checks.yml`). The
  unsigned archive and the dry run do not prove signing, upload or
  TestFlight; only a real `testflight.yml` run with the Apple account can.
- Never run `testflight.yml` or add a trigger to it, and never let pull
  requests reach its secrets; the user starts releases.
- Whenever `JsongApp/project.yml` or the app's file layout changes (adding,
  removing or renaming an app source file or resource), regenerate the Xcode
  project with the XcodeGen release pinned in
  `.github/actions/setup-xcodegen/action.yml` (2.46.0) and commit the result.
  On Linux, build that release from source, from a checkout directory named
  `Jsong`:

  ```sh
  git clone --depth 1 --branch 2.46.0 https://github.com/yonaskolb/XcodeGen /tmp/xcodegen
  test "$(git -C /tmp/xcodegen rev-parse HEAD)" = 8445e778451c7e44237b90281bde622d764b0084
  swift build -c release --package-path /tmp/xcodegen --product xcodegen
  USER="${USER:-ci}" /tmp/xcodegen/.build/release/xcodegen generate --spec JsongApp/project.yml
  ```

  The drift check in `ios-build.yml` (the official macOS binary) is
  authoritative. When upgrading XcodeGen, update the action and these lines
  together.
- Whenever the packages change, run `swift build --build-tests -Xswiftc
  -warnings-as-errors` and `swift test`.
- SwiftUI code is compiled with warnings as errors in Swift 6 language mode;
  write it for strict concurrency (no `DispatchQueue` closures that touch view
  state; use `Task` with `Task.sleep`) and avoid deprecated APIs.
- Never claim a check passed unless it actually ran. Report results as
  **VERIFIED** (ran, with where) or **UNVERIFIED** (e.g. "UNVERIFIED LOCALLY —
  requires macOS/Xcode CI"). Static inspection is not runtime verification.

## Workflow

- Inspect the latest remote state (`git fetch`, `main`, the files involved)
  rather than trusting memory from earlier sessions.
- Work on a task branch and open a pull request. Never commit to `main`, never
  merge a PR, never enable auto-merge, never force-push `main`. The user
  decides what gets merged.
- Prefer small, minimal changes. Avoid speculative architecture, abstractions
  with no current use, new dependencies, and unrelated refactors or formatting.
- This repository is public: never commit secrets (API keys, `.p8`/`.p12`,
  certificates, provisioning profiles, tokens, `.env` files, personal data).
  Signing is automatic through the App Store Connect API key; the key, Team
  ID and app ID live only in the GitHub environment `testflight`, never in
  the repository, logs or artifacts. Apple account steps (agreements, App
  Store Connect, API key, testers) are the user's; never ask for passwords,
  2FA codes or private keys. Learners' own AI API keys (a later phase) belong
  in the iOS Keychain, never in the repository or in UserDefaults.
