
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

class Dish : NSObject, GetImageModel {

    
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        lhs.id == rhs.id
    }
    
    var id : String!
    var name : String!
    var cuisine : String!
    var preference_id : String!
    var user_id : String
    var created_Time : String!
    var summary : String!
    var costTime : String!
    var complexity : Complexity!
    var image_ID : String!
    var isGeneratedDetail : Bool! = false
    var image_URL : URL?
    var image : UIImage?
    
    var liked : Bool = false
    var collected : Bool = false
    
    var status : DishGenerateStatus = .none
    
    
    
    var steps : [Step]?

    var ingredients : [Ingredient]?
    
    
    init(id: String!, name: String!, cuisine: String!, preference_id: String!, user_id: String, created_Time: String!, summary: String!, costTime: String!, complexity: Complexity!, image_ID: String!, image_url : String? = nil, isGenerateddetail: Bool, image : UIImage?, steps : [Step]?, ingredients : [Ingredient]?, status : DishGenerateStatus) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.preference_id = preference_id
        self.user_id = user_id
        self.created_Time = created_Time
        self.summary = summary
        self.costTime = costTime
        self.complexity = complexity
        self.image_ID = image_ID
        self.isGeneratedDetail = isGenerateddetail
        self.image = image
        self.steps = steps
        self.ingredients = ingredients
        self.status = status
        
        if let urlString = image_url,
           let url = URL(string: urlString) {
            self.image_URL = url
        }
    }
    
    
    
    static var examples : [Dish] = {
        var titles : [String] = ["焗烤玉米濃湯", "蕃茄炒蛋", "拔絲地瓜" ]
        var times : [String] = ["40分鐘", "20分鐘", "30分鐘"]
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
            let dish = Dish(id: indexString, name: title, cuisine: cuisine, preference_id: indexString, user_id: indexString, created_Time: indexString, summary: description, costTime: time, complexity: complexity, image_ID: indexString, isGenerateddetail: false, image: image!, steps: Step.examples, ingredients: Ingredient.examples, status: DishGenerateStatus.none)
            return dish
        }
    }()
    
    convenience init?(json : DishJson) {
        var status : DishGenerateStatus = .none
        if let steps = json.steps,
           let ingredients = json.ingredients {
            
            status = !steps.isEmpty || !ingredients.isEmpty ? .already : .none
        }
        self.init(id: json.id, name: json.name, cuisine: json.cuisine, preference_id: json.preference_id, user_id: json.user_id ?? Environment.user_id, created_Time: json.created_time, summary: json.summary, costTime: json.costtime, complexity: Complexity.init(rawValue: json.complexity ?? "錯誤") ?? .error , image_ID: json.image_id, image_url: json.image_url, isGenerateddetail: json.isgenerateddetail ?? false, image: nil, steps: nil, ingredients: nil, status: status)
        self.steps = json.steps?.compactMap({ json in
            return Step(json: json)
        })
        self.ingredients = json.ingredients?.compactMap({ json in
            return Ingredient(json: json)
        })
    }
    
    
    
}

struct DishesJsonResponse : Decodable {
    var created : Int?
    var usage : OpenAIAPIUsageJson?
    var dishes : [DishJson]
    
    enum CodingKeys: CodingKey {
        case created
        case usage
        case dishes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created = try? container.decode(Int.self, forKey: .created)
        self.usage = try? container.decode(OpenAIAPIUsageJson.self, forKey: .usage)
        self.dishes = try container.decode([DishJson].self, forKey: .dishes)
    }
}

struct DishJson : Decodable {
    var id : String?
    var name : String?
    var cuisine : String?
    var preference_id : String?
    var user_id : String?
    var created_time : String?
    var summary : String?
    var costtime : String?
    var complexity : String?
    var image_id : String?
    var isgenerateddetail : Bool?
    var imageprompt : String?
    var image_url : String?
    
    var ingredients : [IngredientJson]?
    
    var steps : [StepJson]?
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case cuisine = "cuisine"
        case preference_id = "preference_id"
        case user_id = "user_id"
        case created_time = "created_time"
        case summary = "summary"
        case costtime = "costtime"
        case complexity = "complexity"
        case image_id = "image_id"
        case isgenerateddetail = "isgenerateddetail"
        case imageprompt = "imageprompt"
        case image_url = "image_url"
        case ingredients = "ingredients"
        case steps = "steps"
    }
    
    init(from decoder: any Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine)
            self.preference_id = try container.decodeIfPresent(String.self, forKey: .preference_id)
            self.user_id = try container.decodeIfPresent(String.self, forKey: .user_id)
            self.created_time = try? container.decodeIfPresent(String.self, forKey: .created_time)
            self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
            self.costtime = try container.decodeIfPresent(String.self, forKey: .costtime)
            self.complexity = try container.decodeIfPresent(String.self, forKey: .complexity)
            self.image_id = try container.decodeIfPresent(String.self, forKey: .image_id)
            self.isgenerateddetail = try container.decodeIfPresent(Bool.self, forKey: .isgenerateddetail)
            self.imageprompt = try? container.decodeIfPresent(String.self, forKey: .imageprompt)
            self.image_url = try? container.decodeIfPresent(String.self, forKey: .image_url)
            self.ingredients = try? container.decodeIfPresent([IngredientJson].self, forKey: .ingredients)
            self.steps = try? container.decodeIfPresent([StepJson].self, forKey: .steps)
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
