
import UIKit
import Alamofire

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
        
        let (data, response) = try await URLSession.shared.data(for: req)
        guard let httpRes = response as? HTTPURLResponse else {
            throw APIError.BadRequestURL
        }
        guard 200...299  ~= httpRes.statusCode else {
            throw AuthenticError.LoginFail
        }
        let headers = httpRes.allHeaderFields
        guard let jwt_token = headers["jwt-token"] as? String,
              let dict = try JSONSerialization.jsonObject(with: data) as? [String : Any],
              let user = dict["user"] as? [String : Any] else {
            print("decode fail")
            throw AuthenticError.DecodeDataFail
        }
        
        let user_id = user["id"] as! String
        SessionManager.shared.setUserID(user_id: user_id)
        SessionManager.shared.setJWTTokenToUserDefaults(jwt_token: jwt_token)
        return jwt_token
    }
    
    func getUser(user_id : String) async throws -> User {
        guard let url = URL(string: "\(self.serverResourcePrefix)?user_id=\(user_id)") else {
            throw APIError.BadRequestURL
        }
        let req = try SessionManager.shared.initAuthURLRequest(url: url)
        
        
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
    }
    
    func rename(user_id : String, newName : String) async throws {
        guard let url = URL(string: "\(self.serverResourcePrefix)?user_id=\(user_id)") else {
            throw APIError.BadRequestURL
        }
        guard let nameData = newName.data(using: .utf8) else {
            throw APIError.BadRequestURL
        }
        
        let res = try await withUnsafeThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(user_id.utf8), withName: "user_id")
                multipartFormData.append(nameData, withName: "name")
            }, to: url, method : .put, headers: .default).response { response in
                switch response.result {
                case .success:
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func changeUserImage(user_id : String, newImage : UIImage) async throws {
        guard let url = URL(string: "\(self.serverResourcePrefix)?user_id=\(user_id)") else {
            throw APIError.BadRequestURL
        }
        guard let imageData = newImage.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        let res = try await withUnsafeThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(user_id.utf8), withName: "user_id")
                multipartFormData.append(imageData, withName: "userimage", fileName: "\(user_id)_userimage.jpg", mimeType: "image/jpeg")

            }, to: url, method : .put, headers: .default).response { response in
                switch response.result {
                case .success:
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func register(name : String, email : String, password : String, image : UIImage?) async throws {
        guard let url = URL(string: "\(self.serverResourcePrefix)/register") else {
            throw APIError.BadRequestURL
        }
        guard let nameData = name.data(using: .utf8),
              let emailData = email.data(using: .utf8),
            let passwordData = password.data(using: .utf8) else {
            throw APIError.BadRequestURL
        }
        

        
        let res = try await withUnsafeThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(nameData, withName: "name")
                multipartFormData.append(emailData, withName: "email")
                multipartFormData.append(passwordData, withName: "password")
                if let image = image,
                   let imageData = image.jpegData(compressionQuality: 0.7){
                    multipartFormData.append(imageData, withName: "userimage", fileName: "userimage.jpg", mimeType: "image/jpeg")
                }
                

            }, to: url, method : .post, headers: .default).response { response in
                switch response.result {
                case .success:
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
