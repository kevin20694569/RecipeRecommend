
import UIKit

class Step : GetImageModel {
    static func == (lhs: Step, rhs: Step) -> Bool {
        lhs.description == rhs.description
    }
    
    
    
    
    var order : Int!
    
    var description : String!
    
    var image_ID : String?
    
    var image: UIImage?
    
    var image_URL : URL?
    
    var dish_ID : String!
    
    var created_time : String!
    
    static var beefVegetableSteps : [Step] = [
        Step(order: 0, description: "牛肉絲加入醬油，太白粉，水抓勻備用。", image_ID: nil, dish_ID:
                nil, created_time: nil),
        Step(order: 1, description: "空心菜用廚房剪刀剪除根部再用水清洗乾淨，切成段裝；蔥切成小段，蔥白，蔥綠分開放置。", image_ID: nil, dish_ID: nil, created_time: nil),
        Step(order: 2, description: "起油鍋將牛肉片過油炒至八分熟取出。", image_ID: nil, dish_ID: nil, created_time: nil),
        Step(order: 3, description: "原鍋洗淨，起油鍋爆香蒜末，蔥白；下空心菜，鹽拌炒再倒入牛肉絲拌勻炒至熟後即可裝盤。", image_ID: nil, dish_ID: nil, created_time: nil),
    ]
    
    
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
    
    init(order: Int,  description: String?, image_URL : String?) {
        self.order = order
        self.description = description
        if let url = image_URL {
            self.image_URL = URL(string: url)
        }
    }
    
    static var realExamplesArray : [[Step]] = [[Step(order: 0, description: "1. 將雞胸肉燙熟、放涼之後，剝成絲備用。\n2. 酸高麗菜切絲，川燙過後放入冰開水冷卻。", image_URL: "https://imageproxy.icook.network/resize?background=255%2C255%2C255&height=300&nocrop=false&stripmeta=true&type=auto&url=http%3A%2F%2Ftokyo-kitchen.icook.tw.s3.amazonaws.com%2Fuploads%2Fstep%2Fcover%2F467114%2F72395a7292db1db4.jpg&width=400"), Step(order: 1, description: "將雞肉絲、小黃瓜絲、紅蘿蔔絲、洋蔥絲、辣椒絲放入碗中，將調味料放入(蠔油、開水、白胡椒粉、鹽、少許糖)充分混合。", image_URL: "https://imageproxy.icook.network/resize?background=255%2C255%2C255&height=300&nocrop=false&stripmeta=true&type=auto&url=http%3A%2F%2Ftokyo-kitchen.icook.tw.s3.amazonaws.com%2Fuploads%2Fstep%2Fcover%2F467115%2F1161581db000575b.jpg&width=400"), Step(order: 2, description: "上桌前再加入少許香油、白芝麻，即可擺盤上菜囉!", image_URL: "https://imageproxy.icook.network/resize?background=255%2C255%2C255&height=300&nocrop=false&stripmeta=true&type=auto&url=http%3A%2F%2Ftokyo-kitchen.icook.tw.s3.amazonaws.com%2Fuploads%2Fstep%2Fcover%2F467116%2F36b7dbe05e66b7e6.jpg&width=400")]]
    
    convenience init(json : StepJson) {
        self.init(order: json.step_order, description: json.description, image_URL: json.image_url)
    }
    
    
}


struct StepJson : Decodable {
    var step_order : Int
    var description : String
    var image_url : String?
    
    enum CodingKeys: String, CodingKey {
        case step_order = "step_order"
        case description = "description"
        case image_url = "image_url"
    }
    
    
    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.step_order = try container.decode(Int.self, forKey: .step_order)
        self.description = try container.decode(String.self, forKey: .description)
        self.image_url = try? container.decode(String.self, forKey: .image_url)
    }

    
    
}

