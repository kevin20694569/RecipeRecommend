

import Foundation

class UserDefaultManager : NSObject {
    static let shared : UserDefaultManager = UserDefaultManager()
    
    
    
    func setEmail(email : String) {
        let userDefault = UserDefaults()
        userDefault.setValue(email, forKey: "email")
    }
    
    func getEmail() -> String? {
        let userDefault = UserDefaults()
        return userDefault.value(forKey: "email") as? String
    }
    
    func setPassword(password : String) {
        let userDefault = UserDefaults()
        userDefault.setValue(password, forKey: "password")
    }
    
    func getPassword() -> String? {
        let userDefault = UserDefaults()
        return userDefault.value(forKey: "password") as? String
    }
}
