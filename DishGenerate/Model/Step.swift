
import UIKit

class Step : GetImageModel {

    
    
    var order : Int!
    
    var description : String!
    
    var image_ID : String?
    
    var image: UIImage?
    
    var image_URL : URL?
    
    var dish_ID : String!
    
    var created_time : String!
    
    static var examples : [Step]! = [Step(order: 0, description: "第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步第一步", image_ID: nil, dish_ID:
                                            nil, created_time: nil),
                                     Step(order: 1, description: "第二步第第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步第二步二步第二步第二步第二步第二步", image_ID: nil, dish_ID: nil, created_time: nil),
                                     Step(order: 2, description: "第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步第三步", image_ID: nil, dish_ID: nil, created_time: nil),
                                     Step(order: 3, description: "第四步第四步第四步第四步第四第四步第四步第四步第四步第四步第四步第四步第四步第四步第四步第四步第四步步第四步", image_ID: nil, dish_ID: nil, created_time: nil),
                                     Step(order: 4, description: "第五步第五步第五步第五步第五步第五步", image_ID: nil, dish_ID: nil, created_time: nil),
                                     Step(order: 5, description: "第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步第六步", image_ID: nil, dish_ID: nil, created_time: nil),
                                     Step(order: 6, description: "第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步第七步", image_ID: nil, dish_ID: nil, created_time: nil),]
    init(order: Int, description: String, image_ID: String? = nil, dish_ID: String? = nil, created_time: String? = nil, urlString : String? = nil) {
        self.order = order
        self.description = description
        self.image_ID = image_ID
        self.dish_ID = dish_ID
        self.created_time = created_time
        if let url = urlString {
            self.image_URL = URL(string: url)
        }
        
        
    }
    
    convenience init(json : StepJson) {
        self.init(order: json.step_order, description: json.description, image_ID: json.image_id, dish_ID: json.dish_id, created_time: json.created_time, urlString: json.image_url)
    }
    
    
}


struct StepJson : Decodable {
    var id : String
    var step_order : Int
    var description : String
    var image_id : String
    var dish_id : String
    var created_time : String
    var imageprompt : String?
    
    var image_url : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case step_order = "step_order"
        case description = "description"
        case image_id = "image_id"
        case dish_id = "dish_id"
        case created_time = "created_time"
        case imageprompt = "imageprompt"
        case image_url = "image_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.step_order = try container.decode(Int.self, forKey: .step_order)
        self.description = try container.decode(String.self, forKey: .description)
        self.image_id = try container.decode(String.self, forKey: .image_id)
        self.dish_id = try container.decode(String.self, forKey: .dish_id)
        self.created_time = try container.decode(String.self, forKey: .created_time)
        self.imageprompt = try? container.decode(String.self, forKey: .imageprompt)
        self.image_url = try? container.decode(String.self, forKey: .image_url)
    }
    
    
}

