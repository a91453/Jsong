import Foundation

struct KatakanaData {

    // MARK: - All Katakana Characters

    static let all: [KanaCharacter] = basicCharacters + dakutenCharacters + comboCharacters

    // MARK: - Lookup by Group

    static func characters(for group: KanaGroup) -> [KanaCharacter] {
        all.filter { $0.group == group }
    }

    // MARK: - Basic Katakana (46)

    private static let basicCharacters: [KanaCharacter] = [
        // Vowels (母音)
        KanaCharacter(id: "kata_a", character: "ア", romaji: "a", type: .katakana, group: .vowels, strokeCount: 2, mnemonicHint: "像一把刀切開東西"),
        KanaCharacter(id: "kata_i", character: "イ", romaji: "i", type: .katakana, group: .vowels, strokeCount: 2, mnemonicHint: "像一個人站立的側面"),
        KanaCharacter(id: "kata_u", character: "ウ", romaji: "u", type: .katakana, group: .vowels, strokeCount: 3, mnemonicHint: "像一個有屋頂的房子"),
        KanaCharacter(id: "kata_e", character: "エ", romaji: "e", type: .katakana, group: .vowels, strokeCount: 3, mnemonicHint: "像工字形的鐵架"),
        KanaCharacter(id: "kata_o", character: "オ", romaji: "o", type: .katakana, group: .vowels, strokeCount: 3, mnemonicHint: "像一個人伸手打招呼"),

        // Ka row (か行)
        KanaCharacter(id: "kata_ka", character: "カ", romaji: "ka", type: .katakana, group: .ka, strokeCount: 2, mnemonicHint: "像一把鋒利的刀刃"),
        KanaCharacter(id: "kata_ki", character: "キ", romaji: "ki", type: .katakana, group: .ka, strokeCount: 3, mnemonicHint: "像一把鑰匙(key)"),
        KanaCharacter(id: "kata_ku", character: "ク", romaji: "ku", type: .katakana, group: .ka, strokeCount: 2, mnemonicHint: "像一隻張嘴的鳥"),
        KanaCharacter(id: "kata_ke", character: "ケ", romaji: "ke", type: .katakana, group: .ka, strokeCount: 3, mnemonicHint: "像一扇半開的門"),
        KanaCharacter(id: "kata_ko", character: "コ", romaji: "ko", type: .katakana, group: .ka, strokeCount: 2, mnemonicHint: "像一個打開的盒子"),

        // Sa row (さ行)
        KanaCharacter(id: "kata_sa", character: "サ", romaji: "sa", type: .katakana, group: .sa, strokeCount: 3, mnemonicHint: "像插在地上的三根棍子"),
        KanaCharacter(id: "kata_shi", character: "シ", romaji: "shi", type: .katakana, group: .sa, strokeCount: 3, mnemonicHint: "像一張微笑的臉"),
        KanaCharacter(id: "kata_su", character: "ス", romaji: "su", type: .katakana, group: .sa, strokeCount: 2, mnemonicHint: "像一條滑行的蛇"),
        KanaCharacter(id: "kata_se", character: "セ", romaji: "se", type: .katakana, group: .sa, strokeCount: 2, mnemonicHint: "像一把打開的剪刀"),
        KanaCharacter(id: "kata_so", character: "ソ", romaji: "so", type: .katakana, group: .sa, strokeCount: 2, mnemonicHint: "像兩滴往右飛的雨滴"),

        // Ta row (た行)
        KanaCharacter(id: "kata_ta", character: "タ", romaji: "ta", type: .katakana, group: .ta, strokeCount: 3, mnemonicHint: "像一把短刀加上刀柄"),
        KanaCharacter(id: "kata_chi", character: "チ", romaji: "chi", type: .katakana, group: .ta, strokeCount: 3, mnemonicHint: "像數字5的變形"),
        KanaCharacter(id: "kata_tsu", character: "ツ", romaji: "tsu", type: .katakana, group: .ta, strokeCount: 3, mnemonicHint: "像三滴往下落的水滴"),
        KanaCharacter(id: "kata_te", character: "テ", romaji: "te", type: .katakana, group: .ta, strokeCount: 3, mnemonicHint: "像一張桌子(table)"),
        KanaCharacter(id: "kata_to", character: "ト", romaji: "to", type: .katakana, group: .ta, strokeCount: 2, mnemonicHint: "像一根釘子插在牆上"),

        // Na row (な行)
        KanaCharacter(id: "kata_na", character: "ナ", romaji: "na", type: .katakana, group: .na, strokeCount: 2, mnemonicHint: "像一把鋒利的菜刀"),
        KanaCharacter(id: "kata_ni", character: "ニ", romaji: "ni", type: .katakana, group: .na, strokeCount: 2, mnemonicHint: "像兩條平行的橫線"),
        KanaCharacter(id: "kata_nu", character: "ヌ", romaji: "nu", type: .katakana, group: .na, strokeCount: 2, mnemonicHint: "像一碗熱騰騰的麵條"),
        KanaCharacter(id: "kata_ne", character: "ネ", romaji: "ne", type: .katakana, group: .na, strokeCount: 4, mnemonicHint: "像一棵小樹苗"),
        KanaCharacter(id: "kata_no", character: "ノ", romaji: "no", type: .katakana, group: .na, strokeCount: 1, mnemonicHint: "像一條斜斜的線"),

        // Ha row (は行)
        KanaCharacter(id: "kata_ha", character: "ハ", romaji: "ha", type: .katakana, group: .ha, strokeCount: 2, mnemonicHint: "像張開嘴大笑「哈」"),
        KanaCharacter(id: "kata_hi", character: "ヒ", romaji: "hi", type: .katakana, group: .ha, strokeCount: 2, mnemonicHint: "像一個人的側臉鼻子"),
        KanaCharacter(id: "kata_fu", character: "フ", romaji: "fu", type: .katakana, group: .ha, strokeCount: 1, mnemonicHint: "像一頂帽子的邊緣"),
        KanaCharacter(id: "kata_he", character: "ヘ", romaji: "he", type: .katakana, group: .ha, strokeCount: 1, mnemonicHint: "像一座小山丘"),
        KanaCharacter(id: "kata_ho", character: "ホ", romaji: "ho", type: .katakana, group: .ha, strokeCount: 4, mnemonicHint: "像一棵聖誕樹"),

        // Ma row (ま行)
        KanaCharacter(id: "kata_ma", character: "マ", romaji: "ma", type: .katakana, group: .ma, strokeCount: 2, mnemonicHint: "像一匹馬的嘴巴"),
        KanaCharacter(id: "kata_mi", character: "ミ", romaji: "mi", type: .katakana, group: .ma, strokeCount: 3, mnemonicHint: "像三條短橫線排列"),
        KanaCharacter(id: "kata_mu", character: "ム", romaji: "mu", type: .katakana, group: .ma, strokeCount: 2, mnemonicHint: "像牛的頭部正面"),
        KanaCharacter(id: "kata_me", character: "メ", romaji: "me", type: .katakana, group: .ma, strokeCount: 2, mnemonicHint: "像一個大叉叉"),
        KanaCharacter(id: "kata_mo", character: "モ", romaji: "mo", type: .katakana, group: .ma, strokeCount: 3, mnemonicHint: "像英文字母E的變形"),

        // Ya row (や行)
        KanaCharacter(id: "kata_ya", character: "ヤ", romaji: "ya", type: .katakana, group: .ya, strokeCount: 2, mnemonicHint: "像一支箭射出去"),
        KanaCharacter(id: "kata_yu", character: "ユ", romaji: "yu", type: .katakana, group: .ya, strokeCount: 2, mnemonicHint: "像一艘小船的側面"),
        KanaCharacter(id: "kata_yo", character: "ヨ", romaji: "yo", type: .katakana, group: .ya, strokeCount: 3, mnemonicHint: "像一扇有格子的窗"),

        // Ra row (ら行)
        KanaCharacter(id: "kata_ra", character: "ラ", romaji: "ra", type: .katakana, group: .ra, strokeCount: 2, mnemonicHint: "像一個人舉起手"),
        KanaCharacter(id: "kata_ri", character: "リ", romaji: "ri", type: .katakana, group: .ra, strokeCount: 2, mnemonicHint: "像兩根並排的筷子"),
        KanaCharacter(id: "kata_ru", character: "ル", romaji: "ru", type: .katakana, group: .ra, strokeCount: 2, mnemonicHint: "像兩條腿站立的樣子"),
        KanaCharacter(id: "kata_re", character: "レ", romaji: "re", type: .katakana, group: .ra, strokeCount: 1, mnemonicHint: "像一條往右彎的線"),
        KanaCharacter(id: "kata_ro", character: "ロ", romaji: "ro", type: .katakana, group: .ra, strokeCount: 3, mnemonicHint: "像一個正方形的嘴巴"),

        // Wa row (わ行)
        KanaCharacter(id: "kata_wa", character: "ワ", romaji: "wa", type: .katakana, group: .wa, strokeCount: 2, mnemonicHint: "像一個開口的杯子"),
        KanaCharacter(id: "kata_wo", character: "ヲ", romaji: "wo", type: .katakana, group: .wa, strokeCount: 3, mnemonicHint: "像フ加上一橫的變化"),

        // N (ん)
        KanaCharacter(id: "kata_n", character: "ン", romaji: "n", type: .katakana, group: .n, strokeCount: 2, mnemonicHint: "像微笑時嘴角上揚"),
    ]

    // MARK: - Dakuten & Handakuten Katakana (25)

    private static let dakutenCharacters: [KanaCharacter] = [
        // Ga row (が行)
        KanaCharacter(id: "kata_ga", character: "ガ", romaji: "ga", type: .katakana, group: .dakutenG, strokeCount: 4, mnemonicHint: "カ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_gi", character: "ギ", romaji: "gi", type: .katakana, group: .dakutenG, strokeCount: 5, mnemonicHint: "キ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_gu", character: "グ", romaji: "gu", type: .katakana, group: .dakutenG, strokeCount: 4, mnemonicHint: "ク加上濁點，發音變濁"),
        KanaCharacter(id: "kata_ge", character: "ゲ", romaji: "ge", type: .katakana, group: .dakutenG, strokeCount: 5, mnemonicHint: "ケ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_go", character: "ゴ", romaji: "go", type: .katakana, group: .dakutenG, strokeCount: 4, mnemonicHint: "コ加上濁點，發音變濁"),

        // Za row (ざ行)
        KanaCharacter(id: "kata_za", character: "ザ", romaji: "za", type: .katakana, group: .dakutenZ, strokeCount: 5, mnemonicHint: "サ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_ji", character: "ジ", romaji: "ji", type: .katakana, group: .dakutenZ, strokeCount: 5, mnemonicHint: "シ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_zu", character: "ズ", romaji: "zu", type: .katakana, group: .dakutenZ, strokeCount: 4, mnemonicHint: "ス加上濁點，發音變濁"),
        KanaCharacter(id: "kata_ze", character: "ゼ", romaji: "ze", type: .katakana, group: .dakutenZ, strokeCount: 4, mnemonicHint: "セ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_zo", character: "ゾ", romaji: "zo", type: .katakana, group: .dakutenZ, strokeCount: 4, mnemonicHint: "ソ加上濁點，發音變濁"),

        // Da row (だ行)
        KanaCharacter(id: "kata_da", character: "ダ", romaji: "da", type: .katakana, group: .dakutenD, strokeCount: 5, mnemonicHint: "タ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_di", character: "ヂ", romaji: "di", type: .katakana, group: .dakutenD, strokeCount: 5, mnemonicHint: "チ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_du", character: "ヅ", romaji: "du", type: .katakana, group: .dakutenD, strokeCount: 5, mnemonicHint: "ツ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_de", character: "デ", romaji: "de", type: .katakana, group: .dakutenD, strokeCount: 5, mnemonicHint: "テ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_do", character: "ド", romaji: "do", type: .katakana, group: .dakutenD, strokeCount: 4, mnemonicHint: "ト加上濁點，發音變濁"),

        // Ba row (ば行)
        KanaCharacter(id: "kata_ba", character: "バ", romaji: "ba", type: .katakana, group: .dakutenB, strokeCount: 4, mnemonicHint: "ハ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_bi", character: "ビ", romaji: "bi", type: .katakana, group: .dakutenB, strokeCount: 4, mnemonicHint: "ヒ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_bu", character: "ブ", romaji: "bu", type: .katakana, group: .dakutenB, strokeCount: 3, mnemonicHint: "フ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_be", character: "ベ", romaji: "be", type: .katakana, group: .dakutenB, strokeCount: 3, mnemonicHint: "ヘ加上濁點，發音變濁"),
        KanaCharacter(id: "kata_bo", character: "ボ", romaji: "bo", type: .katakana, group: .dakutenB, strokeCount: 6, mnemonicHint: "ホ加上濁點，發音變濁"),

        // Pa row (ぱ行)
        KanaCharacter(id: "kata_pa", character: "パ", romaji: "pa", type: .katakana, group: .handakutenP, strokeCount: 3, mnemonicHint: "ハ加上半濁點，輕聲爆破音"),
        KanaCharacter(id: "kata_pi", character: "ピ", romaji: "pi", type: .katakana, group: .handakutenP, strokeCount: 3, mnemonicHint: "ヒ加上半濁點，輕聲爆破音"),
        KanaCharacter(id: "kata_pu", character: "プ", romaji: "pu", type: .katakana, group: .handakutenP, strokeCount: 2, mnemonicHint: "フ加上半濁點，輕聲爆破音"),
        KanaCharacter(id: "kata_pe", character: "ペ", romaji: "pe", type: .katakana, group: .handakutenP, strokeCount: 2, mnemonicHint: "ヘ加上半濁點，輕聲爆破音"),
        KanaCharacter(id: "kata_po", character: "ポ", romaji: "po", type: .katakana, group: .handakutenP, strokeCount: 5, mnemonicHint: "ホ加上半濁點，輕聲爆破音"),
    ]

    // MARK: - Combo / Yōon Katakana (33)

    private static let comboCharacters: [KanaCharacter] = [
        // Kya group (きゃ行)
        KanaCharacter(id: "kata_kya", character: "キャ", romaji: "kya", type: .katakana, group: .comboK, strokeCount: 5, mnemonicHint: "キ加上小ャ，快速滑音"),
        KanaCharacter(id: "kata_kyu", character: "キュ", romaji: "kyu", type: .katakana, group: .comboK, strokeCount: 5, mnemonicHint: "キ加上小ュ，像急救(rescue)"),
        KanaCharacter(id: "kata_kyo", character: "キョ", romaji: "kyo", type: .katakana, group: .comboK, strokeCount: 6, mnemonicHint: "キ加上小ョ，像京都(Kyoto)"),

        // Sha group (しゃ行)
        KanaCharacter(id: "kata_sha", character: "シャ", romaji: "sha", type: .katakana, group: .comboS, strokeCount: 5, mnemonicHint: "シ加上小ャ，像洗髮精(shampoo)"),
        KanaCharacter(id: "kata_shu", character: "シュ", romaji: "shu", type: .katakana, group: .comboS, strokeCount: 5, mnemonicHint: "シ加上小ュ，像鞋子(shoe)"),
        KanaCharacter(id: "kata_sho", character: "ショ", romaji: "sho", type: .katakana, group: .comboS, strokeCount: 6, mnemonicHint: "シ加上小ョ，像商店(shop)"),

        // Cha group (ちゃ行)
        KanaCharacter(id: "kata_cha", character: "チャ", romaji: "cha", type: .katakana, group: .comboT, strokeCount: 5, mnemonicHint: "チ加上小ャ，像茶(tea)"),
        KanaCharacter(id: "kata_chu", character: "チュ", romaji: "chu", type: .katakana, group: .comboT, strokeCount: 5, mnemonicHint: "チ加上小ュ，像親吻的聲音"),
        KanaCharacter(id: "kata_cho", character: "チョ", romaji: "cho", type: .katakana, group: .comboT, strokeCount: 6, mnemonicHint: "チ加上小ョ，像巧克力(chocolate)"),

        // Nya group (にゃ行)
        KanaCharacter(id: "kata_nya", character: "ニャ", romaji: "nya", type: .katakana, group: .comboN, strokeCount: 4, mnemonicHint: "ニ加上小ャ，像貓叫聲「喵」"),
        KanaCharacter(id: "kata_nyu", character: "ニュ", romaji: "nyu", type: .katakana, group: .comboN, strokeCount: 4, mnemonicHint: "ニ加上小ュ，像新聞(news)"),
        KanaCharacter(id: "kata_nyo", character: "ニョ", romaji: "nyo", type: .katakana, group: .comboN, strokeCount: 5, mnemonicHint: "ニ加上小ョ，扭動的感覺"),

        // Hya group (ひゃ行)
        KanaCharacter(id: "kata_hya", character: "ヒャ", romaji: "hya", type: .katakana, group: .comboH, strokeCount: 4, mnemonicHint: "ヒ加上小ャ，像驚嚇的叫聲"),
        KanaCharacter(id: "kata_hyu", character: "ヒュ", romaji: "hyu", type: .katakana, group: .comboH, strokeCount: 4, mnemonicHint: "ヒ加上小ュ，像風吹的聲音"),
        KanaCharacter(id: "kata_hyo", character: "ヒョ", romaji: "hyo", type: .katakana, group: .comboH, strokeCount: 5, mnemonicHint: "ヒ加上小ョ，像表(chart)"),

        // Mya group (みゃ行)
        KanaCharacter(id: "kata_mya", character: "ミャ", romaji: "mya", type: .katakana, group: .comboM, strokeCount: 5, mnemonicHint: "ミ加上小ャ，像緬甸(Myanmar)"),
        KanaCharacter(id: "kata_myu", character: "ミュ", romaji: "myu", type: .katakana, group: .comboM, strokeCount: 5, mnemonicHint: "ミ加上小ュ，像音樂(music)"),
        KanaCharacter(id: "kata_myo", character: "ミョ", romaji: "myo", type: .katakana, group: .comboM, strokeCount: 6, mnemonicHint: "ミ加上小ョ，像奇妙的「妙」"),

        // Rya group (りゃ行)
        KanaCharacter(id: "kata_rya", character: "リャ", romaji: "rya", type: .katakana, group: .comboR, strokeCount: 4, mnemonicHint: "リ加上小ャ，快速彈舌音"),
        KanaCharacter(id: "kata_ryu", character: "リュ", romaji: "ryu", type: .katakana, group: .comboR, strokeCount: 4, mnemonicHint: "リ加上小ュ，像龍(dragon)"),
        KanaCharacter(id: "kata_ryo", character: "リョ", romaji: "ryo", type: .katakana, group: .comboR, strokeCount: 5, mnemonicHint: "リ加上小ョ，像旅行的「旅」"),

        // Gya group (ぎゃ行)
        KanaCharacter(id: "kata_gya", character: "ギャ", romaji: "gya", type: .katakana, group: .comboG, strokeCount: 7, mnemonicHint: "ギ加上小ャ，像驚叫聲"),
        KanaCharacter(id: "kata_gyu", character: "ギュ", romaji: "gyu", type: .katakana, group: .comboG, strokeCount: 7, mnemonicHint: "ギ加上小ュ，像牛肉(beef)"),
        KanaCharacter(id: "kata_gyo", character: "ギョ", romaji: "gyo", type: .katakana, group: .comboG, strokeCount: 8, mnemonicHint: "ギ加上小ョ，像餃子(gyoza)"),

        // Ja group (じゃ行)
        KanaCharacter(id: "kata_ja", character: "ジャ", romaji: "ja", type: .katakana, group: .comboZ, strokeCount: 7, mnemonicHint: "ジ加上小ャ，像爵士(jazz)"),
        KanaCharacter(id: "kata_ju", character: "ジュ", romaji: "ju", type: .katakana, group: .comboZ, strokeCount: 7, mnemonicHint: "ジ加上小ュ，像果汁(juice)"),
        KanaCharacter(id: "kata_jo", character: "ジョ", romaji: "jo", type: .katakana, group: .comboZ, strokeCount: 8, mnemonicHint: "ジ加上小ョ，像喬(Joe)"),

        // Bya group (びゃ行)
        KanaCharacter(id: "kata_bya", character: "ビャ", romaji: "bya", type: .katakana, group: .comboB, strokeCount: 6, mnemonicHint: "ビ加上小ャ，重濁滑音"),
        KanaCharacter(id: "kata_byu", character: "ビュ", romaji: "byu", type: .katakana, group: .comboB, strokeCount: 6, mnemonicHint: "ビ加上小ュ，像景色(view)"),
        KanaCharacter(id: "kata_byo", character: "ビョ", romaji: "byo", type: .katakana, group: .comboB, strokeCount: 7, mnemonicHint: "ビ加上小ョ，像病院的「病」"),

        // Pya group (ぴゃ行)
        KanaCharacter(id: "kata_pya", character: "ピャ", romaji: "pya", type: .katakana, group: .comboP, strokeCount: 5, mnemonicHint: "ピ加上小ャ，輕快爆破音"),
        KanaCharacter(id: "kata_pyu", character: "ピュ", romaji: "pyu", type: .katakana, group: .comboP, strokeCount: 5, mnemonicHint: "ピ加上小ュ，像噴射的聲音"),
        KanaCharacter(id: "kata_pyo", character: "ピョ", romaji: "pyo", type: .katakana, group: .comboP, strokeCount: 6, mnemonicHint: "ピ加上小ョ，像跳躍的聲音"),
    ]
}
