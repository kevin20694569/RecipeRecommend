
import UIKit

class Cuisine : SelectedModel, NSCopying, Codable   {
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Cuisine(name: name, isSelected: isSelected)
    }
    
    static func == (lhs: Cuisine, rhs: Cuisine) -> Bool {
        (lhs.id == rhs.id || lhs.name == rhs.name) && lhs.isSelected == rhs.isSelected
    }
    
    
    var id : String = UUID().uuidString
    
    var name : String?
    var isSelected : Bool = false
    
    init(name : String?, isSelected : Bool) {
        self.name = name
        self.isSelected = isSelected
    }
    
    init(name : String?) {
        self.name = name
    }
    
    init() {
        self.name = ""
    }
    
    init(isSelected : Bool ) {
        self.name = ""
        self.isSelected = isSelected
    }
    
    
    static var examples : [Cuisine] = [Cuisine(name: "中式", isSelected: false),
                                       Cuisine(name: "日式", isSelected: false),
                                       Cuisine(name: "韓式", isSelected: false),
                                       Cuisine(name: "美式", isSelected: false),
                                       Cuisine(name: "泰式", isSelected: false),]
}
