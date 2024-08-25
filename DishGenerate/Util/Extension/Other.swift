import UIKit

extension Notification.Name {
    static let reloadDishNotification = Notification.Name("ReloadDishNotification")
}

extension String {
    func strip(characters: CharacterSet = .whitespacesAndNewlines) -> String {
        return self.trimmingCharacters(in: characters)
    }
}

