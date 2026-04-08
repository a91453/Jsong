import Foundation

struct HiraganaData {

    // MARK: - Public API

    static let all: [KanaCharacter] = basic + dakuten + combo

    static func characters(for group: KanaGroup) -> [KanaCharacter] {
        all.filter { $0.group == group }
    }

    // MARK: - Basic (46)

    private static let basic: [KanaCharacter] = [
        // ── 母音 (Vowels) ──
        KanaCharacter(id: "hira_a",  character: "あ", romaji: "a",  type: .hiragana, group: .vowels, strokeCount: 3, mnemonicHint: "像一個人張大嘴巴說「啊」"),
        KanaCharacter(id: "hira_i",  character: "い", romaji: "i",  type: .hiragana, group: .vowels, strokeCount: 2, mnemonicHint: "像兩個人並肩站立"),
        KanaCharacter(id: "hira_u",  character: "う", romaji: "u",  type: .hiragana, group: .vowels, strokeCount: 2, mnemonicHint: "像一隻兔子的耳朵"),
        KanaCharacter(id: "hira_e",  character: "え", romaji: "e",  type: .hiragana, group: .vowels, strokeCount: 2, mnemonicHint: "像一把打開的扇子"),
        KanaCharacter(id: "hira_o",  character: "お", romaji: "o",  type: .hiragana, group: .vowels, strokeCount: 3, mnemonicHint: "像一個人在鞠躬說「喔」"),

        // ── か行 (Ka) ──
        KanaCharacter(id: "hira_ka", character: "か", romaji: "ka", type: .hiragana, group: .ka, strokeCount: 3, mnemonicHint: "像一把刀在切東西"),
        KanaCharacter(id: "hira_ki", character: "き", romaji: "ki", type: .hiragana, group: .ka, strokeCount: 4, mnemonicHint: "像一把鑰匙（key）"),
        KanaCharacter(id: "hira_ku", character: "く", romaji: "ku", type: .hiragana, group: .ka, strokeCount: 1, mnemonicHint: "像一個小於符號，嘴巴張開"),
        KanaCharacter(id: "hira_ke", character: "け", romaji: "ke", type: .hiragana, group: .ka, strokeCount: 3, mnemonicHint: "像一扇門（gate）打開了"),
        KanaCharacter(id: "hira_ko", character: "こ", romaji: "ko", type: .hiragana, group: .ka, strokeCount: 2, mnemonicHint: "像兩條平行的河流"),

        // ── さ行 (Sa) ──
        KanaCharacter(id: "hira_sa", character: "さ", romaji: "sa", type: .hiragana, group: .sa, strokeCount: 3, mnemonicHint: "像一個人在衝浪（surf）"),
        KanaCharacter(id: "hira_shi", character: "し", romaji: "shi", type: .hiragana, group: .sa, strokeCount: 1, mnemonicHint: "像一個魚鉤"),
        KanaCharacter(id: "hira_su", character: "す", romaji: "su", type: .hiragana, group: .sa, strokeCount: 2, mnemonicHint: "像一根繩子打了個結"),
        KanaCharacter(id: "hira_se", character: "せ", romaji: "se", type: .hiragana, group: .sa, strokeCount: 3, mnemonicHint: "像一個人伸手去拿東西"),
        KanaCharacter(id: "hira_so", character: "そ", romaji: "so", type: .hiragana, group: .sa, strokeCount: 1, mnemonicHint: "像一條蛇在縫紉（sew）"),

        // ── た行 (Ta) ──
        KanaCharacter(id: "hira_ta", character: "た", romaji: "ta", type: .hiragana, group: .ta, strokeCount: 4, mnemonicHint: "像「太」字的草書"),
        KanaCharacter(id: "hira_chi", character: "ち", romaji: "chi", type: .hiragana, group: .ta, strokeCount: 2, mnemonicHint: "像數字5，吃（chi）五個"),
        KanaCharacter(id: "hira_tsu", character: "つ", romaji: "tsu", type: .hiragana, group: .ta, strokeCount: 1, mnemonicHint: "像一個微笑的嘴巴"),
        KanaCharacter(id: "hira_te", character: "て", romaji: "te", type: .hiragana, group: .ta, strokeCount: 1, mnemonicHint: "像一隻手（hand）張開"),
        KanaCharacter(id: "hira_to", character: "と", romaji: "to", type: .hiragana, group: .ta, strokeCount: 2, mnemonicHint: "像一隻腳趾（toe）"),

        // ── な行 (Na) ──
        KanaCharacter(id: "hira_na", character: "な", romaji: "na", type: .hiragana, group: .na, strokeCount: 4, mnemonicHint: "像一個人在打結"),
        KanaCharacter(id: "hira_ni", character: "に", romaji: "ni", type: .hiragana, group: .na, strokeCount: 3, mnemonicHint: "像膝蓋（knee）彎曲"),
        KanaCharacter(id: "hira_nu", character: "ぬ", romaji: "nu", type: .hiragana, group: .na, strokeCount: 2, mnemonicHint: "像麵條（noodle）纏繞"),
        KanaCharacter(id: "hira_ne", character: "ね", romaji: "ne", type: .hiragana, group: .na, strokeCount: 2, mnemonicHint: "像一隻貓在睡覺（寝る）"),
        KanaCharacter(id: "hira_no", character: "の", romaji: "no", type: .hiragana, group: .na, strokeCount: 1, mnemonicHint: "像英文的 No 畫一個圈"),

        // ── は行 (Ha) ──
        KanaCharacter(id: "hira_ha", character: "は", romaji: "ha", type: .hiragana, group: .ha, strokeCount: 3, mnemonicHint: "像一個人開心大笑「哈」"),
        KanaCharacter(id: "hira_hi", character: "ひ", romaji: "hi", type: .hiragana, group: .ha, strokeCount: 1, mnemonicHint: "像一個人在微笑嘻嘻笑"),
        KanaCharacter(id: "hira_fu", character: "ふ", romaji: "fu", type: .hiragana, group: .ha, strokeCount: 4, mnemonicHint: "像富士山的輪廓"),
        KanaCharacter(id: "hira_he", character: "へ", romaji: "he", type: .hiragana, group: .ha, strokeCount: 1, mnemonicHint: "像一座小山丘"),
        KanaCharacter(id: "hira_ho", character: "ほ", romaji: "ho", type: .hiragana, group: .ha, strokeCount: 4, mnemonicHint: "像聖誕老人說 Ho Ho Ho"),

        // ── ま行 (Ma) ──
        KanaCharacter(id: "hira_ma", character: "ま", romaji: "ma", type: .hiragana, group: .ma, strokeCount: 3, mnemonicHint: "像媽媽（mama）張開雙臂"),
        KanaCharacter(id: "hira_mi", character: "み", romaji: "mi", type: .hiragana, group: .ma, strokeCount: 2, mnemonicHint: "像數字21，好美（mi）"),
        KanaCharacter(id: "hira_mu", character: "む", romaji: "mu", type: .hiragana, group: .ma, strokeCount: 3, mnemonicHint: "像一頭牛在「哞」叫"),
        KanaCharacter(id: "hira_me", character: "め", romaji: "me", type: .hiragana, group: .ma, strokeCount: 2, mnemonicHint: "像一隻眼睛（目）"),
        KanaCharacter(id: "hira_mo", character: "も", romaji: "mo", type: .hiragana, group: .ma, strokeCount: 3, mnemonicHint: "像魚鉤釣到更多（more）魚"),

        // ── や行 (Ya) ──
        KanaCharacter(id: "hira_ya", character: "や", romaji: "ya", type: .hiragana, group: .ya, strokeCount: 3, mnemonicHint: "像一支箭射出去"),
        KanaCharacter(id: "hira_yu", character: "ゆ", romaji: "yu", type: .hiragana, group: .ya, strokeCount: 2, mnemonicHint: "像一條魚在游（you）泳"),
        KanaCharacter(id: "hira_yo", character: "よ", romaji: "yo", type: .hiragana, group: .ya, strokeCount: 2, mnemonicHint: "像一個人舉手說「唷」"),

        // ── ら行 (Ra) ──
        KanaCharacter(id: "hira_ra", character: "ら", romaji: "ra", type: .hiragana, group: .ra, strokeCount: 2, mnemonicHint: "像一個人在跑步（run）"),
        KanaCharacter(id: "hira_ri", character: "り", romaji: "ri", type: .hiragana, group: .ra, strokeCount: 2, mnemonicHint: "像兩條河流（river）"),
        KanaCharacter(id: "hira_ru", character: "る", romaji: "ru", type: .hiragana, group: .ra, strokeCount: 1, mnemonicHint: "像一條盤繞的路（road）"),
        KanaCharacter(id: "hira_re", character: "れ", romaji: "re", type: .hiragana, group: .ra, strokeCount: 2, mnemonicHint: "像一個人伸手去接東西"),
        KanaCharacter(id: "hira_ro", character: "ろ", romaji: "ro", type: .hiragana, group: .ra, strokeCount: 1, mnemonicHint: "像數字3，三條路（road）"),

        // ── わ行 (Wa) ──
        KanaCharacter(id: "hira_wa", character: "わ", romaji: "wa", type: .hiragana, group: .wa, strokeCount: 2, mnemonicHint: "像水波（wave）蕩漾"),
        KanaCharacter(id: "hira_wo", character: "を", romaji: "wo", type: .hiragana, group: .wa, strokeCount: 3, mnemonicHint: "像一個人在跳舞旋轉"),

        // ── ん (N) ──
        KanaCharacter(id: "hira_n", character: "ん", romaji: "n", type: .hiragana, group: .n, strokeCount: 1, mnemonicHint: "像英文字母 n 的草書"),
    ]

    // MARK: - Dakuten & Handakuten (25)

    private static let dakuten: [KanaCharacter] = [
        // ── が行 (Ga) ──
        KanaCharacter(id: "hira_ga", character: "が", romaji: "ga", type: .hiragana, group: .dakutenG, strokeCount: 5, mnemonicHint: "「か」加上濁點變成「が」"),
        KanaCharacter(id: "hira_gi", character: "ぎ", romaji: "gi", type: .hiragana, group: .dakutenG, strokeCount: 6, mnemonicHint: "「き」加上濁點變成「ぎ」"),
        KanaCharacter(id: "hira_gu", character: "ぐ", romaji: "gu", type: .hiragana, group: .dakutenG, strokeCount: 3, mnemonicHint: "「く」加上濁點變成「ぐ」"),
        KanaCharacter(id: "hira_ge", character: "げ", romaji: "ge", type: .hiragana, group: .dakutenG, strokeCount: 5, mnemonicHint: "「け」加上濁點變成「げ」"),
        KanaCharacter(id: "hira_go", character: "ご", romaji: "go", type: .hiragana, group: .dakutenG, strokeCount: 4, mnemonicHint: "「こ」加上濁點變成「ご」"),

        // ── ざ行 (Za) ──
        KanaCharacter(id: "hira_za", character: "ざ", romaji: "za", type: .hiragana, group: .dakutenZ, strokeCount: 5, mnemonicHint: "「さ」加上濁點變成「ざ」"),
        KanaCharacter(id: "hira_ji", character: "じ", romaji: "ji", type: .hiragana, group: .dakutenZ, strokeCount: 3, mnemonicHint: "「し」加上濁點變成「じ」"),
        KanaCharacter(id: "hira_zu", character: "ず", romaji: "zu", type: .hiragana, group: .dakutenZ, strokeCount: 4, mnemonicHint: "「す」加上濁點變成「ず」"),
        KanaCharacter(id: "hira_ze", character: "ぜ", romaji: "ze", type: .hiragana, group: .dakutenZ, strokeCount: 5, mnemonicHint: "「せ」加上濁點變成「ぜ」"),
        KanaCharacter(id: "hira_zo", character: "ぞ", romaji: "zo", type: .hiragana, group: .dakutenZ, strokeCount: 3, mnemonicHint: "「そ」加上濁點變成「ぞ」"),

        // ── だ行 (Da) ──
        KanaCharacter(id: "hira_da", character: "だ", romaji: "da", type: .hiragana, group: .dakutenD, strokeCount: 6, mnemonicHint: "「た」加上濁點變成「だ」"),
        KanaCharacter(id: "hira_di", character: "ぢ", romaji: "di", type: .hiragana, group: .dakutenD, strokeCount: 4, mnemonicHint: "「ち」加上濁點變成「ぢ」"),
        KanaCharacter(id: "hira_du", character: "づ", romaji: "du", type: .hiragana, group: .dakutenD, strokeCount: 3, mnemonicHint: "「つ」加上濁點變成「づ」"),
        KanaCharacter(id: "hira_de", character: "で", romaji: "de", type: .hiragana, group: .dakutenD, strokeCount: 3, mnemonicHint: "「て」加上濁點變成「で」"),
        KanaCharacter(id: "hira_do", character: "ど", romaji: "do", type: .hiragana, group: .dakutenD, strokeCount: 4, mnemonicHint: "「と」加上濁點變成「ど」"),

        // ── ば行 (Ba) ──
        KanaCharacter(id: "hira_ba", character: "ば", romaji: "ba", type: .hiragana, group: .dakutenB, strokeCount: 5, mnemonicHint: "「は」加上濁點變成「ば」"),
        KanaCharacter(id: "hira_bi", character: "び", romaji: "bi", type: .hiragana, group: .dakutenB, strokeCount: 3, mnemonicHint: "「ひ」加上濁點變成「び」"),
        KanaCharacter(id: "hira_bu", character: "ぶ", romaji: "bu", type: .hiragana, group: .dakutenB, strokeCount: 6, mnemonicHint: "「ふ」加上濁點變成「ぶ」"),
        KanaCharacter(id: "hira_be", character: "べ", romaji: "be", type: .hiragana, group: .dakutenB, strokeCount: 3, mnemonicHint: "「へ」加上濁點變成「べ」"),
        KanaCharacter(id: "hira_bo", character: "ぼ", romaji: "bo", type: .hiragana, group: .dakutenB, strokeCount: 6, mnemonicHint: "「ほ」加上濁點變成「ぼ」"),

        // ── ぱ行 (Pa) ──
        KanaCharacter(id: "hira_pa", character: "ぱ", romaji: "pa", type: .hiragana, group: .handakutenP, strokeCount: 4, mnemonicHint: "「は」加上半濁點變成「ぱ」"),
        KanaCharacter(id: "hira_pi", character: "ぴ", romaji: "pi", type: .hiragana, group: .handakutenP, strokeCount: 2, mnemonicHint: "「ひ」加上半濁點變成「ぴ」"),
        KanaCharacter(id: "hira_pu", character: "ぷ", romaji: "pu", type: .hiragana, group: .handakutenP, strokeCount: 5, mnemonicHint: "「ふ」加上半濁點變成「ぷ」"),
        KanaCharacter(id: "hira_pe", character: "ぺ", romaji: "pe", type: .hiragana, group: .handakutenP, strokeCount: 2, mnemonicHint: "「へ」加上半濁點變成「ぺ」"),
        KanaCharacter(id: "hira_po", character: "ぽ", romaji: "po", type: .hiragana, group: .handakutenP, strokeCount: 5, mnemonicHint: "「ほ」加上半濁點變成「ぽ」"),
    ]

    // MARK: - Combo / Yōon (33)

    private static let combo: [KanaCharacter] = [
        // ── きゃ行 (Kya) ──
        KanaCharacter(id: "hira_kya", character: "きゃ", romaji: "kya", type: .hiragana, group: .comboK, strokeCount: 6, mnemonicHint: "「き」加小「ゃ」組合發音"),
        KanaCharacter(id: "hira_kyu", character: "きゅ", romaji: "kyu", type: .hiragana, group: .comboK, strokeCount: 5, mnemonicHint: "「き」加小「ゅ」像可愛（cute）"),
        KanaCharacter(id: "hira_kyo", character: "きょ", romaji: "kyo", type: .hiragana, group: .comboK, strokeCount: 5, mnemonicHint: "「き」加小「ょ」像京都（Kyoto）"),

        // ── しゃ行 (Sha) ──
        KanaCharacter(id: "hira_sha", character: "しゃ", romaji: "sha", type: .hiragana, group: .comboS, strokeCount: 3, mnemonicHint: "「し」加小「ゃ」像噓聲"),
        KanaCharacter(id: "hira_shu", character: "しゅ", romaji: "shu", type: .hiragana, group: .comboS, strokeCount: 2, mnemonicHint: "「し」加小「ゅ」像鞋子（shoe）"),
        KanaCharacter(id: "hira_sho", character: "しょ", romaji: "sho", type: .hiragana, group: .comboS, strokeCount: 2, mnemonicHint: "「し」加小「ょ」像表演（show）"),

        // ── ちゃ行 (Cha) ──
        KanaCharacter(id: "hira_cha", character: "ちゃ", romaji: "cha", type: .hiragana, group: .comboT, strokeCount: 4, mnemonicHint: "「ち」加小「ゃ」像泡茶（cha）"),
        KanaCharacter(id: "hira_chu", character: "ちゅ", romaji: "chu", type: .hiragana, group: .comboT, strokeCount: 3, mnemonicHint: "「ち」加小「ゅ」像親吻聲"),
        KanaCharacter(id: "hira_cho", character: "ちょ", romaji: "cho", type: .hiragana, group: .comboT, strokeCount: 3, mnemonicHint: "「ち」加小「ょ」像巧克力"),

        // ── にゃ行 (Nya) ──
        KanaCharacter(id: "hira_nya", character: "にゃ", romaji: "nya", type: .hiragana, group: .comboN, strokeCount: 6, mnemonicHint: "「に」加小「ゃ」像貓叫喵"),
        KanaCharacter(id: "hira_nyu", character: "にゅ", romaji: "nyu", type: .hiragana, group: .comboN, strokeCount: 5, mnemonicHint: "「に」加小「ゅ」像新聞（news）"),
        KanaCharacter(id: "hira_nyo", character: "にょ", romaji: "nyo", type: .hiragana, group: .comboN, strokeCount: 5, mnemonicHint: "「に」加小「ょ」扭動的感覺"),

        // ── ひゃ行 (Hya) ──
        KanaCharacter(id: "hira_hya", character: "ひゃ", romaji: "hya", type: .hiragana, group: .comboH, strokeCount: 3, mnemonicHint: "「ひ」加小「ゃ」像驚叫聲"),
        KanaCharacter(id: "hira_hyu", character: "ひゅ", romaji: "hyu", type: .hiragana, group: .comboH, strokeCount: 2, mnemonicHint: "「ひ」加小「ゅ」像風吹聲"),
        KanaCharacter(id: "hira_hyo", character: "ひょ", romaji: "hyo", type: .hiragana, group: .comboH, strokeCount: 2, mnemonicHint: "「ひ」加小「ょ」像飄動"),

        // ── みゃ行 (Mya) ──
        KanaCharacter(id: "hira_mya", character: "みゃ", romaji: "mya", type: .hiragana, group: .comboM, strokeCount: 4, mnemonicHint: "「み」加小「ゃ」像貓的叫聲"),
        KanaCharacter(id: "hira_myu", character: "みゅ", romaji: "myu", type: .hiragana, group: .comboM, strokeCount: 3, mnemonicHint: "「み」加小「ゅ」像音樂（music）"),
        KanaCharacter(id: "hira_myo", character: "みょ", romaji: "myo", type: .hiragana, group: .comboM, strokeCount: 3, mnemonicHint: "「み」加小「ょ」像奇妙（妙）"),

        // ── りゃ行 (Rya) ──
        KanaCharacter(id: "hira_rya", character: "りゃ", romaji: "rya", type: .hiragana, group: .comboR, strokeCount: 4, mnemonicHint: "「り」加小「ゃ」流利地說"),
        KanaCharacter(id: "hira_ryu", character: "りゅ", romaji: "ryu", type: .hiragana, group: .comboR, strokeCount: 3, mnemonicHint: "「り」加小「ゅ」像龍（竜）"),
        KanaCharacter(id: "hira_ryo", character: "りょ", romaji: "ryo", type: .hiragana, group: .comboR, strokeCount: 3, mnemonicHint: "「り」加小「ょ」像旅行（旅）"),

        // ── ぎゃ行 (Gya) ──
        KanaCharacter(id: "hira_gya", character: "ぎゃ", romaji: "gya", type: .hiragana, group: .comboG, strokeCount: 8, mnemonicHint: "「ぎ」加小「ゃ」像驚嚇聲"),
        KanaCharacter(id: "hira_gyu", character: "ぎゅ", romaji: "gyu", type: .hiragana, group: .comboG, strokeCount: 7, mnemonicHint: "「ぎ」加小「ゅ」像牛肉（牛）"),
        KanaCharacter(id: "hira_gyo", character: "ぎょ", romaji: "gyo", type: .hiragana, group: .comboG, strokeCount: 7, mnemonicHint: "「ぎ」加小「ょ」像魚（魚）"),

        // ── じゃ行 (Ja) ──
        KanaCharacter(id: "hira_ja", character: "じゃ", romaji: "ja", type: .hiragana, group: .comboZ, strokeCount: 5, mnemonicHint: "「じ」加小「ゃ」像再見"),
        KanaCharacter(id: "hira_ju", character: "じゅ", romaji: "ju", type: .hiragana, group: .comboZ, strokeCount: 4, mnemonicHint: "「じ」加小「ゅ」像果汁（juice）"),
        KanaCharacter(id: "hira_jo", character: "じょ", romaji: "jo", type: .hiragana, group: .comboZ, strokeCount: 4, mnemonicHint: "「じ」加小「ょ」像女性（女）"),

        // ── びゃ行 (Bya) ──
        KanaCharacter(id: "hira_bya", character: "びゃ", romaji: "bya", type: .hiragana, group: .comboB, strokeCount: 5, mnemonicHint: "「び」加小「ゃ」快速彈跳"),
        KanaCharacter(id: "hira_byu", character: "びゅ", romaji: "byu", type: .hiragana, group: .comboB, strokeCount: 4, mnemonicHint: "「び」加小「ゅ」像美景（view）"),
        KanaCharacter(id: "hira_byo", character: "びょ", romaji: "byo", type: .hiragana, group: .comboB, strokeCount: 4, mnemonicHint: "「び」加小「ょ」像生病（病）"),

        // ── ぴゃ行 (Pya) ──
        KanaCharacter(id: "hira_pya", character: "ぴゃ", romaji: "pya", type: .hiragana, group: .comboP, strokeCount: 4, mnemonicHint: "「ぴ」加小「ゃ」像彈跳聲"),
        KanaCharacter(id: "hira_pyu", character: "ぴゅ", romaji: "pyu", type: .hiragana, group: .comboP, strokeCount: 3, mnemonicHint: "「ぴ」加小「ゅ」像噴水聲"),
        KanaCharacter(id: "hira_pyo", character: "ぴょ", romaji: "pyo", type: .hiragana, group: .comboP, strokeCount: 3, mnemonicHint: "「ぴ」加小「ょ」像跳躍聲"),
    ]
}
