import UIKit

protocol APIManager : NSObject {
    var serverUrlPrefix : String { get }
}
class MainServerAPIManager : NSObject, APIManager {
    var user_id : String = Environment.user_id
    var serverUrlPrefix : String = Environment.ServerIP
}
