import Foundation
import UIKit
import Alamofire

final class RecognizeImageManager : MainServerAPIManager {
    
    static let shared : RecognizeImageManager = RecognizeImageManager()
    
    override var serverResourcePrefix: String {
        return super.serverResourcePrefix + "/remote/recognizeimages"
    }
    
    
    func recognizeImages(images : [UIImage], user_id : String) async throws -> [[RecognizeImageJson]]  {
        
        guard let url = URL(string: "\(self.serverResourcePrefix)") else {
            throw APIError.BadRequestURL
        }
        guard let jwt_token = self.jwt_token else {
            throw AuthenticError.LostJWTKey
        }
        
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "authorization" : "Bearer \(jwt_token)"
        ]


        let res = try await withUnsafeThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(user_id.utf8), withName: "user_id")
                images.enumerated().forEach() { index, image in
                    guard let data = image.compressImage() else {
                        return
                    }
                    multipartFormData.append(data, withName: "images", fileName: "image_\(index).jpg", mimeType: "image/jpeg")
                }

            }, to: url, headers: headers).response { response in
                switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    guard let data = response.data else {
                        return
                    }
                    guard let res = try? decoder.decode(RecognizeImageResponse.self, from: data) else {
                        return
                    }
                    continuation.resume(returning: res)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        guard let results = res.results else {
            throw APIError.BadRequestURL
        }
        return results
        
    }
    
}

struct RecognizeImageResponse : Codable {
    var results : [[RecognizeImageJson]]?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent([[RecognizeImageJson]].self, forKey: .results)
    }
}

struct RecognizeImageJson : Codable {
    
    var name : String?
    var value : String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.value = try? container.decodeIfPresent(String.self, forKey: .value)
    }
    
}
