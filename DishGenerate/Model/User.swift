import UIKit

class User : Equatable, GetImageModel {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    var id : String!
    
    var name : String!
    
    
    var image : UIImage?
    
    var image_URL : URL?
    
    var created_time : String?
    
    var dislikeIngredient : [String] = ["茄子", "苦瓜", "薑", "小白菜"]
    
    init(id: String!, name: String!,  image : UIImage? , image_URLString : String? = nil, created_time : String? = nil) {
        self.id = id
        self.name = name
        self.image = image
        if let urlString = image_URLString {
            self.image_URL = URL(string: urlString)
        }
    }
    
    static let example : User = User(id: "id", name: "世新大學", image: UIImage.焗烤玉米濃湯)
    
    convenience init(json : UserJson) {
        self.init(id: json.id, name: json.name, image: nil, image_URLString: json.image_url, created_time: json.created_time)
    }
    
    
}

struct UserJson : Codable {
    var id : String
    var name : String
    var email : String
    var created_time : String
    var image_id : String?
    var image_url : String?

    

    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.created_time = try container.decode(String.self, forKey: .created_time)

        self.name = try container.decode(String.self, forKey: .name)
        self.image_id = try? container.decodeIfPresent(String.self, forKey: .image_id)
        self.image_url = try? container.decodeIfPresent(String.self, forKey: .image_url)
    }
    
    
}

