import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol RegisterViewProtocol: AnyObject {
    func showErrorAlert(_ error: Error)
    func showRegistrationSuccessAlert()
}

class RegisterViewController: UIViewController {
    private var registerPresenter: RegisterPresenterProtocol!
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: StyleChangedTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: StyleChangedTextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: StyleChangedTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupPresenter()
    }
    
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
    
    private func setupPresenter() {
        let registerModel = RegisterModel()
        registerPresenter = RegisterPresenter(registerModel: registerModel, registerView: self)
    }
    
    private func clearTextFields() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.confirmPasswordTextField.text = ""
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            AlertManager.noEmailAlert(self)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            AlertManager.noPasswordAlert(self)
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            AlertManager.noPasswordConfirmationAlert(self)
            return
        }
        
        guard ValidationManager.isValidEmail(email) else {
            AlertManager.invalidEmailAlert(self)
            return
        }
        
        guard ValidationManager.isValidPassword(password) else {
            AlertManager.invalidPasswordAlert(self)
            return
        }
        
        guard password == confirmPassword else {
            AlertManager.passwordsMismatchAlert(self)
            return
        }
        
        registerPresenter.registerUser(email: email, password: password)
    }
}

extension RegisterViewController: RegisterViewProtocol {
    func showErrorAlert(_ error: Error) {
        AlertManager.errorAlert(self, error)
    }
    
    func showRegistrationSuccessAlert() {
        AlertManager.registrationHadSuccessAlert(self)
        
        DispatchQueue.main.async {
            [weak self] in self?.clearTextFields()
        }
    }
}
