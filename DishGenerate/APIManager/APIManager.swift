import UIKit

protocol APIManager : NSObject {
    var serverResourcePrefix : String { get }
}



class SessionManager : NSObject {
    
    static let shared : SessionManager = SessionManager()
    
    static var jwt_token : String?
    
    static var user_id : String = "uKBgj-m98kPAxOhbI2hA0"
    
    static let anonymous_user_id = "uKBgj-m98kPAxOhbI2hA0"
    
    func initAuthURLRequest(url : URL) throws -> URLRequest {
        guard let jwt_token = SessionManager.jwt_token else {
            throw AuthenticError.LostJWTKey
        }

        var req = URLRequest(url: url)
        req.setValue("Bearer \(jwt_token)", forHTTPHeaderField: "Authorization")
        return req
    }
    
    func getJWTTokenFromUserDefaults() -> String? {
        let userDefault = UserDefaults()
        if let jwt_token = SessionManager.jwt_token {
            return jwt_token
        }
        guard let jwt_token = userDefault.value(forKey: "jwt-token") as? String else {
            return nil
        }
        SessionManager.shared.setJWTTokenToUserDefaults(jwt_token: jwt_token)
        return jwt_token
    }
    
    func setJWTTokenToUserDefaults(jwt_token : String) {
        SessionManager.jwt_token = jwt_token
        let userDefault = UserDefaults()
        userDefault.setValue(jwt_token, forKey: "jwt-token")
    }

}
class MainServerAPIManager : NSObject, APIManager {
    
    var user_id : String = SessionManager.user_id
    var serverResourcePrefix : String {
        return Environment.ServerIP
    }
    var jwt_token : String? {
        return SessionManager.jwt_token
    }
    
    
    func insertJwtTokenToHeadersDefault( req : inout URLRequest) throws {
        guard let jwt_token = self.jwt_token else {
            throw AuthenticError.LostJWTKey
        }
        req.setValue("Bearer \(jwt_token)", forHTTPHeaderField: "Authorization")
    }
}
