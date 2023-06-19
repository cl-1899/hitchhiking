import Foundation

class TelegramBotManager {
    static func sendToTelegramBot(message: String, completion: @escaping (Error?) -> Void) {
        let token = "6041296828:AAFAXgZWKb8xqt5umV3Y0okx0msQvVm3NTY"
        let chatId = "-994071360"
        
        let url = URL(string: "https://api.telegram.org/bot\(token)/sendMessage")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "chat_id": chatId,
            "text": message
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error {
                    print("Error sending message to Telegram bot: \(error.localizedDescription)")
                    completion(error)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
}
