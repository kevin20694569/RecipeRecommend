import UIKit

struct Tag {
    var title : String!
    
    init(json : TagJson) {
        self.title = json.title
    }
    
    init(title : String) {
        self.title = title
    }
    
    static var realExamples : [[Tag]] = [[Tag(title: "#家常食材"), Tag(title: "#葉菜"), Tag(title : "#高麗菜"), Tag(title: "#異國料理"), Tag(title: "#夏日清爽")]]
}

class TagJson : Codable {
    var title : String?
    
    enum CodingKeys : String , CodingKey {
        case title = "title"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
    }
}
