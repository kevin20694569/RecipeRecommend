import Foundation


struct Environment {
    static let ServerIP : String = {
        if let path = Bundle.main.path(forResource: "env", ofType: "plist") {
            
            return NSDictionary(contentsOfFile: path)?["ServerIP"] as? String ?? ""
        }
        return ""
    }()
    
    static var user_id : String = "qC3kJ1fgfOGHp0dimxXPn"
}






