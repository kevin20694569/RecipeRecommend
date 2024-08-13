
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
    
    var LostJWTKey: String? {
        switch self {
        case .LostJWTKey :
            return "Lost Jwt-Key"
        case .InvalidJWTKey :
            return "Invalid Jwt-Key"
        case .DecodeDataFail :
            return "Decode Data Fail"
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
