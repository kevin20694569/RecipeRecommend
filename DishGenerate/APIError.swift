
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
