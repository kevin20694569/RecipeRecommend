import UIKit

protocol SelectedModel : AnyObject, Equatable {
    var id : String { get set }
    var name : String? { get set }
    var isSelected : Bool { get set }
    
    static func getRequestString(models : [Self]) -> String
        
    

}

extension SelectedModel {
    
    static func getRequestString(models : [Self]) -> String {
        guard models.count > 0 && !models.isEmpty else {
            return ""
        }
    
        var titles = models.compactMap {
            if $0.isSelected {
                return $0.name
            }
            return nil
        }
        let result = titles.joined(separator: ",")
        return result
    }
}

class Equipment : SelectedModel, NSCopying, Codable  {
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Equipment(name: name, isSelected: isSelected)
    }
    
    
    static func == (lhs: Equipment, rhs: Equipment) -> Bool {
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
    
    
    static var examples : [Equipment] = [Equipment(name: "烤箱", isSelected: false),
                                         Equipment(name: "平底鍋", isSelected: false),
                                         Equipment(name: "氣炸鍋", isSelected: false),
                                         Equipment(name: "電鍋", isSelected: false),
                                         Equipment(name: "快煮鍋", isSelected: false)]
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
    
}


