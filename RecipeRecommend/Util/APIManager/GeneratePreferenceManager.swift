import UIKit

final class GeneratePreferenceManager : MainServerAPIManager {
    
    static let shared : GeneratePreferenceManager = GeneratePreferenceManager()
    
    override var serverResourcePrefix: String {
        return super.serverResourcePrefix + "/preferences"
    }
    
    func getHistoryPreferences(user_id : String, dateThreshold : String? ) async throws -> [RecommendRecipePreference] {
        do {
            guard let url = URL(string: "\(self.serverResourcePrefix)/\(user_id)?dateThreshold=\(dateThreshold ?? "")") else {
                throw APIError.BadRequestURL
            }
            var req = URLRequest(url: url)
            try self.insertJwtTokenToHeadersDefault(req: &req)
            
            
            let (data, _) = try await URLSession.shared.data(for: req)
            let decoder = JSONDecoder()
            let results =  try decoder.decode([RecommendPreferenceJson].self, from: data)
            let preferences = results.compactMap { json in
                return RecommendRecipePreference(json : json)
            }
            return preferences
        } catch {
            throw error
        }
    }
    
    
}
