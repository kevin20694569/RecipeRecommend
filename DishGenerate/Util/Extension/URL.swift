

import UIKit

extension URL {
    func getImage() async -> UIImage? {
        guard let (data, res) = try? await URLSession.shared.data(from: self) else {
            return nil
        }
        return UIImage(data: data)
    }
}
