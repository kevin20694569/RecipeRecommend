
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

enum DishError : LocalizedError {
    case RespondError
    
    var errorDescription: String? {
        switch self {
        case .RespondError :
            return "Respond錯誤"
        }
        
    }
}
