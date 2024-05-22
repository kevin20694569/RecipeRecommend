
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
    var isGeneratedDetail : Bool! = false
    var image_URL : URL?
    var image : UIImage?
    
    var liked : Bool = false
    
    var steps : [Step]?
    
    
    init(id: String!, name: String!, cuisine: String!, preference_id: String!, user_id: String, created_Time: String!, summary: String!, costTime: String!, complexity: String!, image_ID: String!, isGenerateddetail: Bool, image : UIImage, steps : [Step]) {
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
    }
    
    
    
    static var examples : [Dish] = {
        var titles : [String] = ["焗烤玉米濃湯", "蕃茄炒蛋", "拔絲地瓜" ]
        var times : [String] = ["40分鐘", "20分鐘", "30分鐘"]
        var descriptions : [String] = ["焗烤玉米濃湯", "蕃茄炒蛋", "拔絲地瓜" ]
        var complexities : [String] = ["普通", "簡單", "困難"]
        var cuisines : [String] = ["歐式", "中式" , "中式"]
        return (0...2).compactMap { index in
            let title = titles[index]
            let time  = times[index]
            let description = descriptions[index]
            let image = UIImage.dishImages[index]
            let cuisine = cuisines[index]
            let complexity = complexities[index]
            let indexString = String("番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵番茄義大利麵")
            let dish = Dish(id: indexString, name: title, cuisine: cuisine, preference_id: indexString, user_id: indexString, created_Time: indexString, summary: description, costTime: time, complexity: complexity, image_ID: indexString, isGenerateddetail: false, image: image!, steps: Step.examples)
            return dish
        }
    }()
}
