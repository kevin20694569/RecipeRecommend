import UIKit

protocol SelectedModel : AnyObject, Equatable {
    var name : String! { get set }
    var isSelected : Bool { get set }
}

class Equipment : SelectedModel  {
    static func == (lhs: Equipment, rhs: Equipment) -> Bool {
        lhs.id == rhs.id    
    }
    
    var id : UUID = UUID()
    
    var name : String!
    var isSelected : Bool = false
    
    init(name : String, isSelected : Bool) {
        self.name = name
        self.isSelected = isSelected
    }
    
    init() {
        self.name = ""
    }
    
    
    static var examples : [Equipment] = [Equipment(name: "微波爐", isSelected: false),
                                         Equipment(name: "烤箱", isSelected: false),
                                         Equipment(name: "瓦斯爐", isSelected: false),
                                         Equipment(name: "氣炸鍋", isSelected: false),
                                         Equipment(name: "電鍋", isSelected: false)]
}


