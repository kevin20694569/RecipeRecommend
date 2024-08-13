
import UIKit



enum Complexity : String  {
    case easy = "簡單"  , normal = "普通" , hard = "困難", error = "錯誤"
    
    var description : String {
        switch self {
        case .easy :
            return "簡單"
        case .normal :
            return "普通"
        case .hard :
            return "困難"
            
        default :
            return ""
        }
    }
}

enum DishGenerateStatus {
    case already, isGenerating, error,  none
}

class Recipe : GetImageModel {

    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    var id : String!
    var name : String!
    var description : String
    var costTime : Int!
    
    var costTimeDescription : String {
        return String(costTime) + "分鐘"
    }
    
    var original_URL : URL?
    var image_URL : URL?
    var image : UIImage?
    
    var liked : Bool = false
    var collected : Bool = false
    
    
    var quantity : Int = 1
    
    var steps : [Step]?

    var ingredients : [Ingredient]?
    
    var tags : [Tag]?
    
    
    
    init(id: String!, name: String!, cuisine: String!, preference_id: String!, user_id: String, created_Time: String!, summary: String!, costTime: Int!, complexity: Complexity!, image_ID: String!, image_url : String? = nil, isGenerateddetail: Bool, image : UIImage?, steps : [Step]?, ingredients : [Ingredient]?, status : DishGenerateStatus) {
        self.id = id
        self.name = name
        self.description = summary
        self.costTime = costTime
        self.image = image
        self.steps = steps
        self.ingredients = ingredients
        if let urlString = image_url,
           let url = URL(string: urlString) {
            self.image_URL = url
        }
    }
    
    init(id: String!, title: String!, description: String!, costTime: Int!, original_url : String? = nil, image_url : String? = nil, image : UIImage?, quantity : Int, steps : [Step]?, ingredients : [Ingredient]?, tags : [Tag]?, liked : Bool = false) {
        self.id = id
        self.name = title
        self.description = description
        self.costTime = costTime
        self.image = image
        self.steps = steps
        self.ingredients = ingredients
        self.quantity = quantity
        self.liked = liked
        self.tags = tags
        if let urlString = image_url,
           let url = URL(string: urlString) {
            self.image_URL = url
        }
    }

    
    static var realExamples : [Recipe] = {
        var idArray : [String] = ["104543"]
        var titles : [String] = ["【夏日必備】涼拌酸高麗菜雞肉"]
        var image_urls : [String] = ["https://tokyo-kitchen.icook.network/uploads/recipe/cover/104543/bc3d73f4d29bbbf2.jpg"]
        var urls : [String] = ["https://icook.tw/recipes/104543"]
        var costtimes : [Int] = [40]
         
        var descriptions : [String] = ["酸高麗菜自然發酵，天然的酸甜，將炎炎夏日的悶熱情緒給帶走~"]
        var quantities : [Int] = [4]
        var times = [0]
        return times.compactMap() { index in
            let id = idArray[index]
            let title = titles[index]
            let description = descriptions[index]
            let time  = times[index]
            let url = urls[index]
            let quantity = quantities[index]
            let image_url = image_urls[index]
            var ingredients = Ingredient.realIngredientsArray[index]
            var steps = Step.realExamplesArray[index]
            var tags = Tag.realExamples[index]
            return Recipe(id: id, title: title, description: description, costTime: time, original_url: url, image_url: image_url, image: nil, quantity: quantity, steps: steps, ingredients: ingredients, tags: tags)
        }
    }()
    
    static var examples : [Recipe] = {
        
        
        var titles : [String] = ["焗烤玉米濃湯", "蕃茄炒蛋", "拔絲地瓜" ]
        var times : [Int] = [40, 20, 30]
        var descriptions : [String] = ["焗烤玉米濃湯焗烤玉米濃湯焗烤玉米濃湯焗烤玉米濃湯焗烤玉米濃湯焗烤玉米濃湯焗烤玉米濃湯", "蕃茄炒蛋蕃茄炒蛋蕃茄炒蛋蕃茄炒蛋蕃茄炒蛋蕃茄炒蛋蕃茄炒蛋蕃茄炒蛋", "拔絲地瓜拔絲地瓜拔絲地瓜拔絲地瓜拔絲地瓜拔絲地瓜拔絲地瓜拔絲地瓜拔絲地瓜" ]
        var complexities : [String] = ["普通", "簡單", "困難"]
        var cuisines : [String] = ["歐式", "中式" , "中式"]
        return (0...2).compactMap { index in
            let title = titles[index]
            let time  = times[index]
            let description = descriptions[index]
            let image = UIImage.dishImages[index]
            let cuisine = cuisines[index]
            let complexity = Complexity.init(rawValue: complexities[index]) ?? .error 
            let indexString = String("番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵")
            let dish = Recipe(id: indexString, name: title, cuisine: cuisine, preference_id: indexString, user_id: Environment.user_id, created_Time: indexString, summary: description, costTime: time, complexity: complexity, image_ID: indexString, isGenerateddetail: false, image: image!, steps: Step.examples, ingredients: Ingredient.examples, status: DishGenerateStatus.already)
            return dish
        }
    }()
    
    convenience init(json : RecipeJson) {
        self.init(id: json.id, title: json.title, description: json.description, costTime: json.costtime, original_url: json.url, image_url: json.image_url, image: nil, quantity: json.quantity ?? 1, steps: nil, ingredients: nil, tags: nil, liked: json .liked)
        self.steps = json.steps?.compactMap({ json in
            return Step(json: json)
        })
        self.ingredients = json.ingredients?.compactMap({ json in
            return Ingredient(json: json)
        })
        self.tags = json.tags?.compactMap({ json in
            return Tag(json: json)
        })
       
    }
    
    
    
}

struct RecipesJsonResponse : Decodable {
    var created : Int?
    var usage : OpenAIAPIUsageJson?
    var dishes : [RecipeJson]
    
    enum CodingKeys: CodingKey {
        case created
        case usage
        case dishes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created = try? container.decode(Int.self, forKey: .created)
        self.usage = try? container.decode(OpenAIAPIUsageJson.self, forKey: .usage)
        self.dishes = try container.decode([RecipeJson].self, forKey: .dishes)
    }
}

struct RecipeJson : Decodable {
    var id : String?
    var title : String?
    var description : String?
    var url : String?
    var like_count : Int?

    var costtime : Int?
    var quantity : Int?
    var image_url : String?
    
    var ingredients : [IngredientJson]?
    
    var steps : [StepJson]?
    
    var tags : [TagJson]?
    
    var liked : Bool = false
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case cuisine = "cuisine"
        case preference_id = "preference_id"
        case user_id = "user_id"
        case created_time = "created_time"
        case summary = "description"
        case costtime = "costtime"
        case complexity = "complexity"
        case image_id = "image_id"
        case isgenerateddetail = "isgenerateddetail"
        case imageprompt = "imageprompt"
        case image_url = "image_url"
        case ingredients = "ingredients"
        case steps = "steps"
        case tags = "tags"
        case liked = "liked"
    }
    
    init(from decoder: any Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.title = try container.decodeIfPresent(String.self, forKey: .title)
            self.description = try container.decodeIfPresent(String.self, forKey: .summary)
            self.costtime = try container.decodeIfPresent(Int.self, forKey: .costtime)
            self.image_url = try? container.decodeIfPresent(String.self, forKey: .image_url)
            self.ingredients = try? container.decodeIfPresent([IngredientJson].self, forKey: .ingredients)
            self.steps = try? container.decodeIfPresent([StepJson].self, forKey: .steps)
            self.tags = try? container.decodeIfPresent([TagJson].self, forKey: .tags)
            if let liked = try? container.decodeIfPresent(Bool.self, forKey: .liked) {
                self.liked = liked
            }
        } catch {
            print(error)
            throw error
        }
    }

    
}

struct OpenAIAPIUsageJson : Decodable {
    var prompt_tokens : Int
    var completion_tokens : Int
    var total_tokens : Int
    
    enum CodingKeys: CodingKey {
        case prompt_tokens
        case completion_tokens
        case total_tokens
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.prompt_tokens = try container.decode(Int.self, forKey: .prompt_tokens)
        self.completion_tokens = try container.decode(Int.self, forKey: .completion_tokens)
        self.total_tokens = try container.decode(Int.self, forKey: .total_tokens)
    }
}
