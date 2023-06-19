import Foundation

class ValidationManager {
    static func isValidEmail(_ email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedPassword.count >= 6
    }
}
