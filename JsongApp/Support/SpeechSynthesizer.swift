import AVFoundation

/// Reads Japanese text aloud with the system's ja-JP voice.
@MainActor
final class SpeechSynthesizer {
    /// One synthesizer for the whole app, so starting a new utterance
    /// always stops the previous one.
    static let shared = SpeechSynthesizer()

    private let synthesizer = AVSpeechSynthesizer()
    private var isAudioSessionConfigured = false

    private init() {}

    func speak(_ text: String) {
        configureAudioSessionIfNeeded()
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
        synthesizer.speak(utterance)
    }

    /// Pronunciation is played only when the learner asks for it, so it
    /// should be heard with the Ring/Silent switch on silent too (the
    /// default session category is muted by it). Mixing keeps other audio,
    /// such as music, playing underneath.
    private func configureAudioSessionIfNeeded() {
        guard !isAudioSessionConfigured else { return }
        isAudioSessionConfigured = true
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
        try? session.setActive(true)
    }
}
