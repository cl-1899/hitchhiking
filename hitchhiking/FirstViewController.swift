import UIKit
import FirebaseAuth

class FirstViewController: UIViewController {
    
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var usernameTextField: StyleChangedTextField!
    @IBOutlet weak var passwordTextField: StyleChangedTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private let textFieldHeight = 40.0
    private let buttonHeight = 37.0
    
    private func setupAppearance() {
        self.navigationItem.title = title
        
        self.usernameTextField.keyboardType = .emailAddress
        
        self.passwordTextField.isSecureTextEntry = true
        
        self.forgotPasswordButton.layer.cornerRadius = 20
        self.forgotPasswordButton.setTitle("Забыли пароль?", for: .normal)
        self.forgotPasswordButton.setTitleColor(.black, for: .normal)
        self.forgotPasswordButton.backgroundColor = .yellow
        
        self.loginButton.layer.cornerRadius = 20
        self.loginButton.setTitle("Логин", for: .normal)
        self.loginButton.setTitleColor(.white, for: .normal)
        self.loginButton.backgroundColor = .orange
        
        self.usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.usernameTextField.leadingAnchor.constraint(equalTo: self.signInView.leadingAnchor, constant: 25),
            self.usernameTextField.trailingAnchor.constraint(equalTo: self.signInView.trailingAnchor, constant: -25),
            self.usernameTextField.topAnchor.constraint(equalTo: self.signInView.topAnchor, constant: 15),
            self.usernameTextField.heightAnchor.constraint(equalToConstant: self.textFieldHeight),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.signInView.leadingAnchor, constant: 25),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.signInView.trailingAnchor, constant: -25),
            self.passwordTextField.topAnchor.constraint(equalTo: self.usernameTextField.bottomAnchor, constant: 15),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: self.textFieldHeight),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.forgotPasswordButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 15),
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: self.buttonHeight),
            self.loginButton.leadingAnchor.constraint(equalTo: self.signInView.leadingAnchor, constant: 30),
            self.loginButton.trailingAnchor.constraint(equalTo: self.signInView.trailingAnchor, constant: -30),
            self.loginButton.topAnchor.constraint(equalTo: self.forgotPasswordButton.bottomAnchor, constant: 15),
            self.loginButton.heightAnchor.constraint(equalToConstant: self.buttonHeight),
        ])
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func alertAfterPress(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            let message = "Не всё заполнено"
            print(message)
            alertAfterPress(message)
            return
        }
        
        guard isValidEmail(email) else {
            let message = "Адрес электронной почты введён неверно."
            print(message)
            alertAfterPress(message)
            return
        }
        
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                let message = "Ошибка при проверке существования email."
                print(message + ": " + error.localizedDescription)
                self.alertAfterPress(message)
                return
            }
            
            if signInMethods != nil {
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        let message = "Неверный пароль"
                        print(message + ": " + error.localizedDescription)
                        self.alertAfterPress(message)
                        return
                    }
                    
                    if let destinationVC = self.storyboard?.instantiateViewController(identifier: "SearchTripViewController") {
                        destinationVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(destinationVC, animated: true)
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                }
            } else {
                let message = "Такой email ещё не зарегестрирован."
                print(message)
                self.alertAfterPress(message)
            }
        }
        
    }
}
