
import UIKit

class Dish {
    
    var id : String!
    var name : String!
    var cuisine : String!
    var preference_id : String!
    var user_id : String
    var created_Time : String!
    var summary : String!
    var costTime : String!
    var complexity : String!
    var image_ID : String!
    var isGenerateddetail : Bool! = false
    var image_URL : URL?
    var image : UIImage?
    
    var liked : Bool = false
    
    
    init(id: String!, name: String!, cuisine: String!, preference_id: String!, user_id: String, created_Time: String!, summary: String!, costTime: String!, complexity: String!, image_ID: String!, isGenerateddetail: Bool, image : UIImage) {
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
        self.isGenerateddetail = isGenerateddetail
        self.image = image
    }
    
    
    static var examples : [Dish] = {
        return (1...10).compactMap { index in
            let indexString = String(index)
            let dish = Dish(id: indexString, name: "番茄義大利麵", cuisine: indexString, preference_id: indexString, user_id: indexString, created_Time: indexString, summary: indexString, costTime: "20分鐘", complexity: indexString, image_ID: indexString, isGenerateddetail: false, image: UIImage(systemName: "birthday.cake.fill")!)
            return dish
        }
    }()
}
