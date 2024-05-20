
import UIKit

class Cuisine : SelectedModel  {

    
    var name : String!
    var isSelected : Bool = false
    
    init(name : String, isSelected : Bool) {
        self.name = name
        self.isSelected = isSelected
    }
    
    init() {
        self.name = ""
        
    }
    
    
    static var examples : [Cuisine] = [Cuisine(name: "台式", isSelected: false),
                                       Cuisine(name: "日式", isSelected: false),
                                       Cuisine(name: "韓式", isSelected: false),
                                       Cuisine(name: "中式", isSelected: false),
                                       Cuisine(name: "泰式", isSelected: false),
                                       Cuisine(name: "義式", isSelected: false)]
}
