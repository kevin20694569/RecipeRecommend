import UIKit

class User : Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    
    var id : String!
    
    var name : String!
    
    var image : UIImage?
    
    var image_URL : URL?
    
    var dislikeIngredient : [String] = ["茄子", "苦瓜", "薑", "小白菜"]
    
    init(id: String!, name: String!,  image : UIImage? , image_URL : URL?) {
        self.id = id
        self.name = name
        self.image = image
        self.image_URL = image_URL
    
    }
    
    static let example : User = User(id: "id", name: "NameNameNameName", image: UIImage.焗烤玉米濃湯, image_URL: nil)
    
    
}

