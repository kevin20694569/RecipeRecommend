import UIKit

class SessionManager : NSObject, APIManager {
    
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
    
    func deleteJWT_Token() {
        let userDefault = UserDefaults()
        return userDefault.removeObject(forKey: "jwt-token")
    }
    
    
    @MainActor
    func verifyJwtTokenToLogout(currentViewController : UIViewController, token : String) async throws {
        do {
            guard let url = URL(string: self.serverResourcePrefix + "/users/verifyjwttoken") else {
                return
            }
            
            var req = try initAuthURLRequest(url: url)
            req.httpMethod = "POST"
            
            let (_, res) = try await URLSession.shared.data(for: req)
            guard let httpRes = res as? HTTPURLResponse,
                  200...299 ~= httpRes.statusCode else {
                throw NSError(domain: "verifyJwtToken Fail", code: 404)
            }
        } catch {
            
            let alertController = UIAlertController(title: "登入逾時", message: "請重新登入", preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "重新登入", style: .default) { action in
                currentViewController.dismiss(animated: true) {
                    SceneDelegate.logout()
                }
                
            }
            alertController.addAction(logoutAction)
            currentViewController.present(alertController, animated: true)

            throw error
        }
        

    }
    
}
