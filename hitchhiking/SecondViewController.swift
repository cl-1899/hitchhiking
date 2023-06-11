import UIKit
import FirebaseAuth
import FirebaseDatabase

class SecondViewController: UIViewController {
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: StyleChangedTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: StyleChangedTextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: StyleChangedTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    private func setupAppearance() {
        self.navigationItem.title = title
        
        self.registrationLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.registrationLabel.sizeToFit()
        
        self.emailTextField.keyboardType = .emailAddress
        
        self.passwordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.isSecureTextEntry = true
        
        self.registerButton.layer.cornerRadius = 10
        self.registerButton.setTitle("Зарегистрироваться", for: .normal)
        self.registerButton.setTitleColor(.white, for: .normal)
        self.registerButton.backgroundColor = .black
        
        self.registrationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.registrationLabel.topAnchor.constraint(equalTo: self.signUpView.topAnchor, constant: 15),
            self.registrationLabel.centerXAnchor.constraint(equalTo: signUpView.centerXAnchor),
            self.emailLabel.leadingAnchor.constraint(equalTo: self.signUpView.leadingAnchor, constant: 25),
            self.emailLabel.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 15),
            self.emailTextField.leadingAnchor.constraint(equalTo: self.signUpView.leadingAnchor, constant: 25),
            self.emailTextField.trailingAnchor.constraint(equalTo: self.signUpView.trailingAnchor, constant: -25),
            self.emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 10),
            self.passwordLabel.leadingAnchor.constraint(equalTo: self.signUpView.leadingAnchor, constant: 25),
            self.passwordLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.signUpView.leadingAnchor, constant: 25),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.signUpView.trailingAnchor, constant: -25),
            self.passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 10),
            self.confirmPasswordLabel.leadingAnchor.constraint(equalTo: self.signUpView.leadingAnchor, constant: 25),
            self.confirmPasswordLabel.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20),
            self.confirmPasswordTextField.leadingAnchor.constraint(equalTo: self.signUpView.leadingAnchor, constant: 25),
            self.confirmPasswordTextField.trailingAnchor.constraint(equalTo: self.signUpView.trailingAnchor, constant: -25),
            self.confirmPasswordTextField.topAnchor.constraint(equalTo: self.confirmPasswordLabel.bottomAnchor, constant: 10),
            self.registerButton.leadingAnchor.constraint(equalTo: self.signUpView.leadingAnchor, constant: 25),
            self.registerButton.trailingAnchor.constraint(equalTo: self.signUpView.trailingAnchor, constant: -25),
            self.registerButton.topAnchor.constraint(equalTo: self.confirmPasswordTextField.bottomAnchor, constant: 30),
        ])
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
                if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        let messsage = "Данный email уже зарегестрирован."
                        print(messsage)
                        self.alertAfterPress(messsage)
                    default:
                        print("Ошибка при сохранении данных пользователя: \(error.localizedDescription)")
                        self.alertAfterPress("Произошла ошибка при регистрации, попробуйте ещё раз чуть позже.")
                    }
                }
                return
            }
            
            guard let userId = authResult?.user.uid else {
                print("Не удалось получить идентификатор пользователя")
                self.alertAfterPress("Произошла ошибка при регистрации, попробуйте ещё раз чуть позже.")
                return
            }
            
            let userData = ["email": email, "password": password]
            let userRef = Database.database().reference().child("users").child(userId)
            
            userRef.setValue(userData) { (error, ref) in
                if let error = error {
                    print("Ошибка при сохранении данных пользователя: \(error.localizedDescription)")
                    self.alertAfterPress("Произошла ошибка при регистрации, попробуйте ещё раз чуть позже.")
                } else {
                    let message = "Регистрация прошла успешно."
                    print(message)
                    self.alertAfterPress(message)
                    DispatchQueue.main.async {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.confirmPasswordTextField.text = ""
                    }
                }
            }
        }
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
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            let message = "Введите адрес электронной почты."
            print(message)
            alertAfterPress(message)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            let message = "Введите пароль."
            print(message)
            alertAfterPress(message)
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            let message = "Введите подтверждение пароля."
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
        
        guard password == confirmPassword else {
            let message = "Пароли не совпадают."
            print(message)
            alertAfterPress(message)
            return
        }
        
        registerUser(email: email, password: password)
    }
    
}
