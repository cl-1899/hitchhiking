import UIKit

class ForgotPasswordViewController: UIViewController {
    
    var emailTextField: StyleChangedTextField!
    
    private func setupAppearance() {
        emailTextField = StyleChangedTextField()
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = UIColor.systemGray3
        emailTextField.placeholder = "Введите email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailTextField)
        
        let sendEmailButton = UIButton(type: .system)
        sendEmailButton.layer.cornerRadius = 20
        sendEmailButton.setTitle("Отправить для восстановления", for: .normal)
        sendEmailButton.setTitleColor(.white, for: .normal)
        sendEmailButton.backgroundColor = .orange
        sendEmailButton.translatesAutoresizingMaskIntoConstraints = false
        sendEmailButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(sendEmailButton)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            sendEmailButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 19),
            sendEmailButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            sendEmailButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            sendEmailButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    func sendToTelegramBot(message: String) {
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
                if let error = error {
                    print("Error sending message to Telegram bot: \(error.localizedDescription)")
                }
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
    @objc func buttonTapped() {
        guard let text = emailTextField.text else {
            return
        }
        
        guard isValidEmail(emailTextField.text!) else {
            let alertController = UIAlertController(title: nil, message: "Адрес электронной почты введён неверно.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        sendToTelegramBot(message: text)
        let alertController = UIAlertController(title: nil, message: "Ваш Email отправлен для восстановления пароля, ждите обратной связи.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        emailTextField.text = ""
    }
}
