import UIKit

protocol APIManager : NSObject {
    var serverResourcePrefix : String { get }
}

class SessionManager : NSObject {
    
    static let shared : SessionManager = SessionManager()
    
    var jwt_token : String? {
        return getJWT_Token()
    }
    
    var user_id : String! {
        if let user_id = try? getUserID() {
            return user_id
        }
        return SessionManager.anonymous_user_id
    }
    
    static let anonymous_user_id = "uKBgj-m98kPAxOhbI2hA0"
    
    func initAuthURLRequest(url : URL) throws -> URLRequest {
        guard let jwt_token = jwt_token else {
            throw AuthenticError.LostJWTKey
        }

        var req = URLRequest(url: url)
        
        req.setValue("Bearer \(jwt_token)", forHTTPHeaderField: "Authorization")
        return req
    }
    
    func setJWTTokenToUserDefaults(jwt_token : String) {
        let userDefault = UserDefaults()
        userDefault.setValue(jwt_token, forKey: "jwt-token")
    }
    
    func setUserID(user_id : String) {
        let userDefault = UserDefaults()
        userDefault.setValue(user_id, forKey: "user_id")
    }
    
    func getUserID() throws -> String {
        let userDefault = UserDefaults()
        guard let user_id = userDefault.value(forKey: "user_id") as? String else {
            throw AuthenticError.LoginFail
        }
        return user_id
    }
    
    func getJWT_Token() -> String? {
        let userDefault = UserDefaults()
        return userDefault.value(forKey: "jwt-token") as? String
    }
    
    func deleteUserID() {
        let userDefault = UserDefaults()
        userDefault.removeObject(forKey:  "user_id")
    }
    
    func deleteJWT_Token(){
        let userDefault = UserDefaults()
        return userDefault.removeObject(forKey: "jwt-token")
    }

}
class MainServerAPIManager : NSObject, APIManager {
    
    var user_id : String {
        return SessionManager.shared.user_id
    }
    var serverResourcePrefix : String {
        return Environment.ServerIP
    }
    var jwt_token : String? {
        return SessionManager.shared.jwt_token
    }
    
    
    func insertJwtTokenToHeadersDefault(req : inout URLRequest) throws {
        guard let jwt_token = self.jwt_token else {
            throw AuthenticError.LostJWTKey
        }
        req.setValue("Bearer \(jwt_token)", forHTTPHeaderField: "Authorization")
    }
}
