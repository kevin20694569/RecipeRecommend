import UIKit

protocol APIManager : NSObject {
    var serverResourcePrefix : String { get }
}

extension APIManager {
    var serverResourcePrefix : String { 
        return Environment.ServerIP
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
