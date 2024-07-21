import UIKit

final class GeneratePreferenceManager : MainServerAPIManager {
    
    static let shared : GeneratePreferenceManager = GeneratePreferenceManager()
    
    override var serverUrlPrefix: String {
        return super.serverUrlPrefix + "/preferences"
    }
    
    func getHistoryPreferences(user_id : String, dateThreshold : String? = "") async throws -> [DishPreference] {
        do {
            guard let url = URL(string: "\(self.serverUrlPrefix)/\(user_id)?date=\(dateThreshold ?? "")") else {
                throw APIError.BadRequestURL
            }
            
            let req = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: req)
            let decoder = JSONDecoder()
            let results =  try decoder.decode([DishPreferenceJson].self, from: data)
            let preferences = results.compactMap { json in
                return DishPreference(json : json)
            }
            return preferences
        } catch {
            throw error
        }
    }
    
    
}
