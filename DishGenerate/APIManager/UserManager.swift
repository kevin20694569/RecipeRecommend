
import UIKit

final class UserManager : MainServerAPIManager {
    
    static let shared : UserManager = UserManager()
    
    override var serverResourcePrefix: String {
        return super.serverResourcePrefix + "/users"
    }
    
    func login(email : String, password : String) async throws -> String {
        guard let url = URL(string: "\(self.serverResourcePrefix)/login") else {
            throw APIError.BadRequestURL
        }
        
        var req = URLRequest(url: url)

        let params : [String : String] = [
            "email" : email,
            "password" : password
        ]

        let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
        let (_, response) = try await URLSession.shared.data(for: req)
        guard let httpRes = response as? HTTPURLResponse else {
            throw APIError.BadRequestURL
        }
        guard 200...299  ~= httpRes.statusCode else {
            throw APIError.BadRequestURL
        }
        let headers = httpRes.allHeaderFields
        if let jwt_token = headers["jwt-token"] as? String {
            SessionManager.shared.setJWTTokenToUserDefaults(jwt_token: jwt_token)
            return jwt_token
        }
        throw AuthenticError.DecodeDataFail
    }
    
    func getUser(user_id : String) async throws -> User {
        guard let url = URL(string: "\(self.serverResourcePrefix)?user_id=\(user_id)") else {
            throw APIError.BadRequestURL
        }
       // var req = URLRequest(url: url)
        var req = try SessionManager.shared.initAuthURLRequest(url: url)
      //  try self.insertJwtTokenToHeadersDefault(req: &req)
        
        
        let (data, response) = try await URLSession.shared.data(for: req)
        guard let httpRes = response as? HTTPURLResponse else {
            throw APIError.BadRequestURL
        }
        guard 200...299  ~= httpRes.statusCode else {
            throw APIError.BadRequestURL
        }
        let decoder = JSONDecoder()
        let userJson = try decoder.decode(UserJson.self, from: data)
        let user = User.init(json: userJson)
        return user
      //  throw AuthenticError.DecodeDataFail
    }
    
    
}
