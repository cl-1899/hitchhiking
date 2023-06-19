import Foundation

protocol ForgotPasswordModelProtocol {
    func sendEmailForRecovery(email: String, completion: @escaping (Error?) -> Void)
}

class ForgotPasswordModel: ForgotPasswordModelProtocol {
    func sendEmailForRecovery(email: String, completion: @escaping (Error?) -> Void) {
        TelegramBotManager.sendToTelegramBot(message: email) { error in
            completion(error)
        }
    }
}
