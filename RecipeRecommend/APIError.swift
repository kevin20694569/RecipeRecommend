
import Foundation

enum APIError : LocalizedError {
    case BadRequestURL
    
    
    var errorDescription: String? {
        switch self {
        case .BadRequestURL :
            return "URL失效"
        }
    }
}

enum AuthenticError : LocalizedError {
    case LostJWTKey
    case InvalidJWTKey
    case DecodeDataFail
    case LoginFail
    
    var errorDescription: String? {
        switch self {
        case .LostJWTKey :
            return "Lost Jwt-Key"
        case .InvalidJWTKey :
            return "Invalid Jwt-Key"
        case .DecodeDataFail :
            return "Decode Data Fail"
        case .LoginFail :
            return "LoginFail"
        }

    }
}



enum DishError : LocalizedError {
    case RespondError
    
    var errorDescription: String? {
        switch self {
        case .RespondError :
            return "Respond錯誤"
        }
        
    }
}
