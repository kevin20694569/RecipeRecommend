import UIKit

class User : Equatable, GetImageModel {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    var id : String!
    
    var name : String!
    
    var email : String!
    
    var image : UIImage?
    
    var image_URL : URL?
    
    var created_time : String?
    
    var dislikeIngredient : [String] = ["茄子", "苦瓜", "薑", "小白菜"]
    
    init(id: String!, name: String!, email : String,  image : UIImage? , image_URLString : String? = nil, created_time : String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.image = image
        if let urlString = image_URLString {
            self.image_URL = URL(string: urlString)
        }
    }
    
    static let example : User = User(id: "id", name: "世新大學", email: "kevin22", image: UIImage.焗烤玉米濃湯)
    
    static let `default` : User = User(id: "", name: "", email: "", image: nil)
    
    convenience init(json : UserJson) {
        self.init(id: json.id, name: json.name, email: json.email, image: nil, image_URLString: json.image_url, created_time: json.created_time)
    }
    
    static let Nologin : User = User(id: "", name: "", email: "", image: nil)
    
    func getImage() async -> UIImage? {

        
        if let image = self.image {
            return image
        }
        if let image = await image_URL?.getImage() {
            self.image = image
        } else {
            self.image = UIImage(named: "app_icon")
        }
        return image
        
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

