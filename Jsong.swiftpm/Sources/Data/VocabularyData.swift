import Foundation

struct VocabularyData {

    static let all: [VocabularyWord] = greetings + numbers + food + animals + family + time + colors + bodyParts + dailyLife + nature

    static func words(for category: VocabularyCategory) -> [VocabularyWord] {
        all.filter { $0.category == category }
    }

    // MARK: - 打招呼

    private static let greetings: [VocabularyWord] = [
        VocabularyWord(id: "v_konnichiwa", japanese: "こんにちは", reading: "こんにちは", romaji: "konnichiwa", meaning: "你好",
                       category: .greetings, exampleSentence: "こんにちは、元気ですか。", sentenceMeaning: "你好,你好嗎?"),
        VocabularyWord(id: "v_ohayou", japanese: "おはようございます", reading: "おはようございます", romaji: "ohayou gozaimasu", meaning: "早安",
                       category: .greetings, exampleSentence: "先生、おはようございます。", sentenceMeaning: "老師早安。"),
        VocabularyWord(id: "v_konbanwa", japanese: "こんばんは", reading: "こんばんは", romaji: "konbanwa", meaning: "晚安(見面時)",
                       category: .greetings, exampleSentence: "こんばんは、お疲れ様です。", sentenceMeaning: "晚安,辛苦了。"),
        VocabularyWord(id: "v_sayounara", japanese: "さようなら", reading: "さようなら", romaji: "sayounara", meaning: "再見",
                       category: .greetings, exampleSentence: "また明日、さようなら。", sentenceMeaning: "明天見,再見。"),
        VocabularyWord(id: "v_arigatou", japanese: "ありがとう", reading: "ありがとう", romaji: "arigatou", meaning: "謝謝",
                       category: .greetings, exampleSentence: "手伝ってくれて、ありがとう。", sentenceMeaning: "謝謝你幫我。"),
        VocabularyWord(id: "v_sumimasen", japanese: "すみません", reading: "すみません", romaji: "sumimasen", meaning: "對不起/不好意思",
                       category: .greetings, exampleSentence: "すみません、道を教えてください。", sentenceMeaning: "不好意思,請告訴我怎麼走。"),
        VocabularyWord(id: "v_hai", japanese: "はい", reading: "はい", romaji: "hai", meaning: "是",
                       category: .greetings, exampleSentence: "はい、そうです。", sentenceMeaning: "是的,沒錯。"),
        VocabularyWord(id: "v_iie", japanese: "いいえ", reading: "いいえ", romaji: "iie", meaning: "不是",
                       category: .greetings, exampleSentence: "いいえ、違います。", sentenceMeaning: "不,不是的。"),
        VocabularyWord(id: "v_onegai", japanese: "お願いします", reading: "おねがいします", romaji: "onegai shimasu", meaning: "拜託了",
                       category: .greetings, exampleSentence: "よろしくお願いします。", sentenceMeaning: "請多多指教。"),
        VocabularyWord(id: "v_gomen", japanese: "ごめんなさい", reading: "ごめんなさい", romaji: "gomennasai", meaning: "對不起",
                       category: .greetings, exampleSentence: "遅れてごめんなさい。", sentenceMeaning: "對不起我遲到了。")
    ]

    // MARK: - 數字

    private static let numbers: [VocabularyWord] = [
        VocabularyWord(id: "v_ichi", japanese: "一", reading: "いち", romaji: "ichi", meaning: "一",
                       category: .numbers, exampleSentence: "一時に会いましょう。", sentenceMeaning: "一點鐘見面吧。"),
        VocabularyWord(id: "v_ni", japanese: "二", reading: "に", romaji: "ni", meaning: "二",
                       category: .numbers, exampleSentence: "二人で行きます。", sentenceMeaning: "兩個人一起去。"),
        VocabularyWord(id: "v_san", japanese: "三", reading: "さん", romaji: "san", meaning: "三",
                       category: .numbers, exampleSentence: "三つください。", sentenceMeaning: "請給我三個。"),
        VocabularyWord(id: "v_yon", japanese: "四", reading: "よん", romaji: "yon", meaning: "四",
                       category: .numbers, exampleSentence: "四月は春です。", sentenceMeaning: "四月是春天。"),
        VocabularyWord(id: "v_go", japanese: "五", reading: "ご", romaji: "go", meaning: "五",
                       category: .numbers, exampleSentence: "五分待ってください。", sentenceMeaning: "請等五分鐘。"),
        VocabularyWord(id: "v_roku", japanese: "六", reading: "ろく", romaji: "roku", meaning: "六",
                       category: .numbers, exampleSentence: "六時に起きます。", sentenceMeaning: "六點起床。"),
        VocabularyWord(id: "v_nana", japanese: "七", reading: "なな", romaji: "nana", meaning: "七",
                       category: .numbers, exampleSentence: "七日間休みます。", sentenceMeaning: "休息七天。"),
        VocabularyWord(id: "v_hachi", japanese: "八", reading: "はち", romaji: "hachi", meaning: "八",
                       category: .numbers, exampleSentence: "八月は暑いです。", sentenceMeaning: "八月很熱。"),
        VocabularyWord(id: "v_kyuu", japanese: "九", reading: "きゅう", romaji: "kyuu", meaning: "九",
                       category: .numbers, exampleSentence: "九時に始まります。", sentenceMeaning: "九點開始。"),
        VocabularyWord(id: "v_juu", japanese: "十", reading: "じゅう", romaji: "juu", meaning: "十",
                       category: .numbers, exampleSentence: "十人います。", sentenceMeaning: "有十個人。")
    ]

    // MARK: - 食物

    private static let food: [VocabularyWord] = [
        VocabularyWord(id: "v_gohan", japanese: "ご飯", reading: "ごはん", romaji: "gohan", meaning: "飯",
                       category: .food, exampleSentence: "ご飯を食べます。", sentenceMeaning: "吃飯。"),
        VocabularyWord(id: "v_mizu", japanese: "水", reading: "みず", romaji: "mizu", meaning: "水",
                       category: .food, exampleSentence: "水をください。", sentenceMeaning: "請給我水。"),
        VocabularyWord(id: "v_ocha", japanese: "お茶", reading: "おちゃ", romaji: "ocha", meaning: "茶",
                       category: .food, exampleSentence: "お茶を飲みます。", sentenceMeaning: "喝茶。"),
        VocabularyWord(id: "v_sakana", japanese: "魚", reading: "さかな", romaji: "sakana", meaning: "魚",
                       category: .food, exampleSentence: "魚が好きです。", sentenceMeaning: "我喜歡魚。"),
        VocabularyWord(id: "v_niku", japanese: "肉", reading: "にく", romaji: "niku", meaning: "肉",
                       category: .food, exampleSentence: "肉を買います。", sentenceMeaning: "買肉。"),
        VocabularyWord(id: "v_yasai", japanese: "野菜", reading: "やさい", romaji: "yasai", meaning: "蔬菜",
                       category: .food, exampleSentence: "野菜は健康にいいです。", sentenceMeaning: "蔬菜對健康好。"),
        VocabularyWord(id: "v_kudamono", japanese: "果物", reading: "くだもの", romaji: "kudamono", meaning: "水果",
                       category: .food, exampleSentence: "果物が大好きです。", sentenceMeaning: "我最愛水果。"),
        VocabularyWord(id: "v_pan", japanese: "パン", reading: "パン", romaji: "pan", meaning: "麵包",
                       category: .food, exampleSentence: "朝パンを食べます。", sentenceMeaning: "早上吃麵包。"),
        VocabularyWord(id: "v_tamago", japanese: "卵", reading: "たまご", romaji: "tamago", meaning: "蛋",
                       category: .food, exampleSentence: "卵を二つ買います。", sentenceMeaning: "買兩個蛋。"),
        VocabularyWord(id: "v_gyuunyuu", japanese: "牛乳", reading: "ぎゅうにゅう", romaji: "gyuunyuu", meaning: "牛奶",
                       category: .food, exampleSentence: "毎朝牛乳を飲みます。", sentenceMeaning: "每天早上喝牛奶。")
    ]

    // MARK: - 動物

    private static let animals: [VocabularyWord] = [
        VocabularyWord(id: "v_neko", japanese: "猫", reading: "ねこ", romaji: "neko", meaning: "貓",
                       category: .animals, exampleSentence: "猫がかわいいです。", sentenceMeaning: "貓很可愛。"),
        VocabularyWord(id: "v_inu", japanese: "犬", reading: "いぬ", romaji: "inu", meaning: "狗",
                       category: .animals, exampleSentence: "犬と散歩します。", sentenceMeaning: "和狗一起散步。"),
        VocabularyWord(id: "v_tori", japanese: "鳥", reading: "とり", romaji: "tori", meaning: "鳥",
                       category: .animals, exampleSentence: "鳥が飛んでいます。", sentenceMeaning: "鳥在飛。"),
        VocabularyWord(id: "v_uma", japanese: "馬", reading: "うま", romaji: "uma", meaning: "馬",
                       category: .animals, exampleSentence: "馬が速いです。", sentenceMeaning: "馬跑得快。"),
        VocabularyWord(id: "v_ushi", japanese: "牛", reading: "うし", romaji: "ushi", meaning: "牛",
                       category: .animals, exampleSentence: "牛乳は牛から来ます。", sentenceMeaning: "牛奶來自牛。"),
        VocabularyWord(id: "v_buta", japanese: "豚", reading: "ぶた", romaji: "buta", meaning: "豬",
                       category: .animals, exampleSentence: "豚肉が好きです。", sentenceMeaning: "喜歡豬肉。"),
        VocabularyWord(id: "v_usagi", japanese: "兎", reading: "うさぎ", romaji: "usagi", meaning: "兔子",
                       category: .animals, exampleSentence: "兎は耳が長いです。", sentenceMeaning: "兔子耳朵長。"),
        VocabularyWord(id: "v_kuma", japanese: "熊", reading: "くま", romaji: "kuma", meaning: "熊",
                       category: .animals, exampleSentence: "山に熊がいます。", sentenceMeaning: "山裡有熊。"),
        VocabularyWord(id: "v_zou", japanese: "象", reading: "ぞう", romaji: "zou", meaning: "大象",
                       category: .animals, exampleSentence: "象は大きいです。", sentenceMeaning: "大象很大。"),
        VocabularyWord(id: "v_sakana2", japanese: "魚", reading: "さかな", romaji: "sakana", meaning: "魚",
                       category: .animals, exampleSentence: "川で魚を見ました。", sentenceMeaning: "在河裡看到魚。")
    ]

    // MARK: - 家族

    private static let family: [VocabularyWord] = [
        VocabularyWord(id: "v_okaasan", japanese: "お母さん", reading: "おかあさん", romaji: "okaasan", meaning: "媽媽",
                       category: .family, exampleSentence: "お母さんは優しいです。", sentenceMeaning: "媽媽很溫柔。"),
        VocabularyWord(id: "v_otousan", japanese: "お父さん", reading: "おとうさん", romaji: "otousan", meaning: "爸爸",
                       category: .family, exampleSentence: "お父さんは会社員です。", sentenceMeaning: "爸爸是上班族。"),
        VocabularyWord(id: "v_ani", japanese: "兄", reading: "あに", romaji: "ani", meaning: "哥哥",
                       category: .family, exampleSentence: "兄は学生です。", sentenceMeaning: "哥哥是學生。"),
        VocabularyWord(id: "v_ane", japanese: "姉", reading: "あね", romaji: "ane", meaning: "姊姊",
                       category: .family, exampleSentence: "姉は料理が上手です。", sentenceMeaning: "姊姊很會做菜。"),
        VocabularyWord(id: "v_otouto", japanese: "弟", reading: "おとうと", romaji: "otouto", meaning: "弟弟",
                       category: .family, exampleSentence: "弟はまだ小さいです。", sentenceMeaning: "弟弟還小。"),
        VocabularyWord(id: "v_imouto", japanese: "妹", reading: "いもうと", romaji: "imouto", meaning: "妹妹",
                       category: .family, exampleSentence: "妹は歌が好きです。", sentenceMeaning: "妹妹喜歡唱歌。"),
        VocabularyWord(id: "v_sofu", japanese: "祖父", reading: "そふ", romaji: "sofu", meaning: "祖父",
                       category: .family, exampleSentence: "祖父は元気です。", sentenceMeaning: "祖父很健康。"),
        VocabularyWord(id: "v_sobo", japanese: "祖母", reading: "そぼ", romaji: "sobo", meaning: "祖母",
                       category: .family, exampleSentence: "祖母の料理は美味しいです。", sentenceMeaning: "祖母的菜很好吃。"),
        VocabularyWord(id: "v_kazoku", japanese: "家族", reading: "かぞく", romaji: "kazoku", meaning: "家人",
                       category: .family, exampleSentence: "家族と旅行します。", sentenceMeaning: "和家人一起旅行。"),
        VocabularyWord(id: "v_kodomo", japanese: "子供", reading: "こども", romaji: "kodomo", meaning: "小孩",
                       category: .family, exampleSentence: "子供が遊んでいます。", sentenceMeaning: "小孩在玩。")
    ]

    // MARK: - 時間

    private static let time: [VocabularyWord] = [
        VocabularyWord(id: "v_kyou", japanese: "今日", reading: "きょう", romaji: "kyou", meaning: "今天",
                       category: .time, exampleSentence: "今日はいい天気です。", sentenceMeaning: "今天天氣很好。"),
        VocabularyWord(id: "v_ashita", japanese: "明日", reading: "あした", romaji: "ashita", meaning: "明天",
                       category: .time, exampleSentence: "明日は休みです。", sentenceMeaning: "明天休息。"),
        VocabularyWord(id: "v_kinou", japanese: "昨日", reading: "きのう", romaji: "kinou", meaning: "昨天",
                       category: .time, exampleSentence: "昨日映画を見ました。", sentenceMeaning: "昨天看了電影。"),
        VocabularyWord(id: "v_asa", japanese: "朝", reading: "あさ", romaji: "asa", meaning: "早上",
                       category: .time, exampleSentence: "朝ご飯を食べます。", sentenceMeaning: "吃早飯。"),
        VocabularyWord(id: "v_hiru", japanese: "昼", reading: "ひる", romaji: "hiru", meaning: "中午",
                       category: .time, exampleSentence: "昼休みは一時間です。", sentenceMeaning: "午休一小時。"),
        VocabularyWord(id: "v_yoru", japanese: "夜", reading: "よる", romaji: "yoru", meaning: "晚上",
                       category: .time, exampleSentence: "夜は静かです。", sentenceMeaning: "晚上很安靜。"),
        VocabularyWord(id: "v_ima", japanese: "今", reading: "いま", romaji: "ima", meaning: "現在",
                       category: .time, exampleSentence: "今何時ですか。", sentenceMeaning: "現在幾點?"),
        VocabularyWord(id: "v_shuu", japanese: "週", reading: "しゅう", romaji: "shuu", meaning: "星期",
                       category: .time, exampleSentence: "今週は忙しいです。", sentenceMeaning: "這星期很忙。"),
        VocabularyWord(id: "v_tsuki", japanese: "月", reading: "つき", romaji: "tsuki", meaning: "月份",
                       category: .time, exampleSentence: "来月日本に行きます。", sentenceMeaning: "下個月去日本。"),
        VocabularyWord(id: "v_toshi", japanese: "年", reading: "とし", romaji: "toshi", meaning: "年",
                       category: .time, exampleSentence: "今年は2026年です。", sentenceMeaning: "今年是2026年。")
    ]

    // MARK: - 顏色

    private static let colors: [VocabularyWord] = [
        VocabularyWord(id: "v_aka", japanese: "赤", reading: "あか", romaji: "aka", meaning: "紅色",
                       category: .colors, exampleSentence: "赤いりんごです。", sentenceMeaning: "紅蘋果。"),
        VocabularyWord(id: "v_ao", japanese: "青", reading: "あお", romaji: "ao", meaning: "藍色",
                       category: .colors, exampleSentence: "空が青いです。", sentenceMeaning: "天空很藍。"),
        VocabularyWord(id: "v_kiiro", japanese: "黄色", reading: "きいろ", romaji: "kiiro", meaning: "黃色",
                       category: .colors, exampleSentence: "黄色いバナナ。", sentenceMeaning: "黃色的香蕉。"),
        VocabularyWord(id: "v_midori", japanese: "緑", reading: "みどり", romaji: "midori", meaning: "綠色",
                       category: .colors, exampleSentence: "緑の木があります。", sentenceMeaning: "有綠色的樹。"),
        VocabularyWord(id: "v_shiro", japanese: "白", reading: "しろ", romaji: "shiro", meaning: "白色",
                       category: .colors, exampleSentence: "白い雪です。", sentenceMeaning: "白雪。"),
        VocabularyWord(id: "v_kuro", japanese: "黒", reading: "くろ", romaji: "kuro", meaning: "黑色",
                       category: .colors, exampleSentence: "黒い猫を見ました。", sentenceMeaning: "看到黑貓。"),
        VocabularyWord(id: "v_murasaki", japanese: "紫", reading: "むらさき", romaji: "murasaki", meaning: "紫色",
                       category: .colors, exampleSentence: "紫の花が綺麗です。", sentenceMeaning: "紫花很美。"),
        VocabularyWord(id: "v_orenji", japanese: "オレンジ", reading: "オレンジ", romaji: "orenji", meaning: "橘色",
                       category: .colors, exampleSentence: "オレンジ色のシャツ。", sentenceMeaning: "橘色的襯衫。"),
        VocabularyWord(id: "v_pinku", japanese: "ピンク", reading: "ピンク", romaji: "pinku", meaning: "粉紅色",
                       category: .colors, exampleSentence: "ピンクの桜。", sentenceMeaning: "粉紅的櫻花。"),
        VocabularyWord(id: "v_chairo", japanese: "茶色", reading: "ちゃいろ", romaji: "chairo", meaning: "棕色",
                       category: .colors, exampleSentence: "茶色の犬。", sentenceMeaning: "棕色的狗。")
    ]

    // MARK: - 身體

    private static let bodyParts: [VocabularyWord] = [
        VocabularyWord(id: "v_atama", japanese: "頭", reading: "あたま", romaji: "atama", meaning: "頭",
                       category: .bodyParts, exampleSentence: "頭が痛いです。", sentenceMeaning: "頭痛。"),
        VocabularyWord(id: "v_me", japanese: "目", reading: "め", romaji: "me", meaning: "眼睛",
                       category: .bodyParts, exampleSentence: "目が大きいです。", sentenceMeaning: "眼睛很大。"),
        VocabularyWord(id: "v_mimi", japanese: "耳", reading: "みみ", romaji: "mimi", meaning: "耳朵",
                       category: .bodyParts, exampleSentence: "耳で聞きます。", sentenceMeaning: "用耳朵聽。"),
        VocabularyWord(id: "v_kuchi", japanese: "口", reading: "くち", romaji: "kuchi", meaning: "嘴巴",
                       category: .bodyParts, exampleSentence: "口を開けてください。", sentenceMeaning: "請張嘴。"),
        VocabularyWord(id: "v_te", japanese: "手", reading: "て", romaji: "te", meaning: "手",
                       category: .bodyParts, exampleSentence: "手を洗います。", sentenceMeaning: "洗手。"),
        VocabularyWord(id: "v_ashi", japanese: "足", reading: "あし", romaji: "ashi", meaning: "腳",
                       category: .bodyParts, exampleSentence: "足が疲れました。", sentenceMeaning: "腳累了。"),
        VocabularyWord(id: "v_hana", japanese: "鼻", reading: "はな", romaji: "hana", meaning: "鼻子",
                       category: .bodyParts, exampleSentence: "鼻が高いです。", sentenceMeaning: "鼻子很挺。"),
        VocabularyWord(id: "v_kami", japanese: "髪", reading: "かみ", romaji: "kami", meaning: "頭髮",
                       category: .bodyParts, exampleSentence: "髪が長いです。", sentenceMeaning: "頭髮很長。"),
        VocabularyWord(id: "v_yubi", japanese: "指", reading: "ゆび", romaji: "yubi", meaning: "手指",
                       category: .bodyParts, exampleSentence: "指が痛いです。", sentenceMeaning: "手指痛。"),
        VocabularyWord(id: "v_kokoro", japanese: "心", reading: "こころ", romaji: "kokoro", meaning: "心",
                       category: .bodyParts, exampleSentence: "心が温かいです。", sentenceMeaning: "心很溫暖。")
    ]

    // MARK: - 日常生活

    private static let dailyLife: [VocabularyWord] = [
        VocabularyWord(id: "v_gakkou", japanese: "学校", reading: "がっこう", romaji: "gakkou", meaning: "學校",
                       category: .dailyLife, exampleSentence: "学校に行きます。", sentenceMeaning: "去學校。"),
        VocabularyWord(id: "v_shigoto", japanese: "仕事", reading: "しごと", romaji: "shigoto", meaning: "工作",
                       category: .dailyLife, exampleSentence: "仕事が忙しいです。", sentenceMeaning: "工作很忙。"),
        VocabularyWord(id: "v_densha", japanese: "電車", reading: "でんしゃ", romaji: "densha", meaning: "電車",
                       category: .dailyLife, exampleSentence: "電車で行きます。", sentenceMeaning: "搭電車去。"),
        VocabularyWord(id: "v_hon", japanese: "本", reading: "ほん", romaji: "hon", meaning: "書",
                       category: .dailyLife, exampleSentence: "本を読みます。", sentenceMeaning: "看書。"),
        VocabularyWord(id: "v_terebi", japanese: "テレビ", reading: "テレビ", romaji: "terebi", meaning: "電視",
                       category: .dailyLife, exampleSentence: "テレビを見ます。", sentenceMeaning: "看電視。"),
        VocabularyWord(id: "v_denwa", japanese: "電話", reading: "でんわ", romaji: "denwa", meaning: "電話",
                       category: .dailyLife, exampleSentence: "電話をかけます。", sentenceMeaning: "打電話。"),
        VocabularyWord(id: "v_okane", japanese: "お金", reading: "おかね", romaji: "okane", meaning: "錢",
                       category: .dailyLife, exampleSentence: "お金がありません。", sentenceMeaning: "沒有錢。"),
        VocabularyWord(id: "v_tokei", japanese: "時計", reading: "とけい", romaji: "tokei", meaning: "時鐘",
                       category: .dailyLife, exampleSentence: "時計を見ます。", sentenceMeaning: "看時鐘。"),
        VocabularyWord(id: "v_kagi", japanese: "鍵", reading: "かぎ", romaji: "kagi", meaning: "鑰匙",
                       category: .dailyLife, exampleSentence: "鍵を忘れました。", sentenceMeaning: "忘了帶鑰匙。"),
        VocabularyWord(id: "v_kasa", japanese: "傘", reading: "かさ", romaji: "kasa", meaning: "雨傘",
                       category: .dailyLife, exampleSentence: "傘を持っていきます。", sentenceMeaning: "帶傘出門。")
    ]

    // MARK: - 自然

    private static let nature: [VocabularyWord] = [
        VocabularyWord(id: "v_yama", japanese: "山", reading: "やま", romaji: "yama", meaning: "山",
                       category: .nature, exampleSentence: "山に登ります。", sentenceMeaning: "爬山。"),
        VocabularyWord(id: "v_kawa", japanese: "川", reading: "かわ", romaji: "kawa", meaning: "河",
                       category: .nature, exampleSentence: "川で泳ぎます。", sentenceMeaning: "在河裡游泳。"),
        VocabularyWord(id: "v_umi", japanese: "海", reading: "うみ", romaji: "umi", meaning: "海",
                       category: .nature, exampleSentence: "海は広いです。", sentenceMeaning: "海很寬闊。"),
        VocabularyWord(id: "v_sora", japanese: "空", reading: "そら", romaji: "sora", meaning: "天空",
                       category: .nature, exampleSentence: "空が青いです。", sentenceMeaning: "天空很藍。"),
        VocabularyWord(id: "v_hana2", japanese: "花", reading: "はな", romaji: "hana", meaning: "花",
                       category: .nature, exampleSentence: "花が綺麗です。", sentenceMeaning: "花很漂亮。"),
        VocabularyWord(id: "v_ki", japanese: "木", reading: "き", romaji: "ki", meaning: "樹",
                       category: .nature, exampleSentence: "大きな木があります。", sentenceMeaning: "有一棵大樹。"),
        VocabularyWord(id: "v_hoshi", japanese: "星", reading: "ほし", romaji: "hoshi", meaning: "星星",
                       category: .nature, exampleSentence: "星が見えます。", sentenceMeaning: "看得見星星。"),
        VocabularyWord(id: "v_tsuki2", japanese: "月", reading: "つき", romaji: "tsuki", meaning: "月亮",
                       category: .nature, exampleSentence: "月が明るいです。", sentenceMeaning: "月亮很亮。"),
        VocabularyWord(id: "v_taiyou", japanese: "太陽", reading: "たいよう", romaji: "taiyou", meaning: "太陽",
                       category: .nature, exampleSentence: "太陽が昇ります。", sentenceMeaning: "太陽升起。"),
        VocabularyWord(id: "v_ame", japanese: "雨", reading: "あめ", romaji: "ame", meaning: "雨",
                       category: .nature, exampleSentence: "雨が降っています。", sentenceMeaning: "正在下雨。")
    ]
}
