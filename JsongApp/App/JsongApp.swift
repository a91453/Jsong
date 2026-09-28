import JsongPresentation
import SwiftUI

@main
struct JsongApp: App {
    /// The app's single progress store. Views read progress from it and
    /// change it only through its methods; nothing else keeps a copy.
    @State private var progressStore = JsongApp.makeProgressStore()

    var body: some Scene {
        WindowGroup {
            ContentView(initialTab: JsongApp.initialTab)
                .environment(progressStore)
        }
    }

    private static func makeProgressStore() -> ProgressStore {
        #if DEBUG
        if let demo = DemoLaunch.makeProgressStore() {
            return demo
        }
        #endif
        return ProgressStore(storage: UserDefaultsProgressStorage())
    }

    private static var initialTab: AppTab {
        #if DEBUG
        if let tab = DemoLaunch.initialTab {
            return tab
        }
        #endif
        return .learn
    }
}
