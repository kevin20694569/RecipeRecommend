import UIKit

final class GeneratePreferenceManager : MainServerAPIManager {
    
    static let shared : GeneratePreferenceManager = GeneratePreferenceManager()
    
    override var serverResourcePrefix: String {
        return super.serverResourcePrefix + "/preferences"
    }
    
    func getHistoryPreferences(user_id : String, dateThreshold : String? ) async throws -> [GenerateRecipePreference] {
        do {
            guard let url = URL(string: "\(self.serverResourcePrefix)/\(user_id)?dateThreshold=\(dateThreshold ?? "")") else {
                throw APIError.BadRequestURL
            }
            var req = URLRequest(url: url)
            try self.insertJwtTokenToHeadersDefault(req: &req)
            
            
            let (data, _) = try await URLSession.shared.data(for: req)
            let decoder = JSONDecoder()
            let results =  try decoder.decode([DishPreferenceJson].self, from: data)
            let preferences = results.compactMap { json in
                return GenerateRecipePreference(json : json)
            }
            return preferences
        } catch {
            throw error
        }
    }
    
    
}
