import UIKit

protocol LoginViewProtocol: AnyObject {
    func showErrorAlert(_ error: Error)
    func showNextScreen()
}

class LoginViewController: UIViewController {
    private var loginPresenter: LoginPresenterProtocol!
    
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var usernameTextField: StyleChangedTextField!
    @IBOutlet weak var passwordTextField: StyleChangedTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private let textFieldHeight = 40.0
    private let buttonHeight = 37.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupPresenter()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupAppearance() {
        self.navigationItem.title = title
        
        self.usernameTextField.keyboardType = .emailAddress
        self.usernameTextField.textContentType = .username
        
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.textContentType = .password
        
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
    
    private func setupPresenter() {
        let loginModel = LoginModel()
        loginPresenter = LoginPresenter(loginModel: loginModel, loginView:  self)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = usernameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            AlertManager.smthIsEmptyAlert(self)
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
        
        loginPresenter.signIn(email: email, password: password)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension LoginViewController: LoginViewProtocol {
    func showErrorAlert(_ error: Error) {
        AlertManager.errorAlert(self, error)
    }
    
    func showNextScreen() {
        if let searchTripVC = storyboard?.instantiateViewController(withIdentifier: "TripsViewController") {
            searchTripVC.hidesBottomBarWhenPushed = true
            searchTripVC.modalPresentationStyle = .fullScreen
            searchTripVC.modalTransitionStyle = .partialCurl

            show(searchTripVC, sender: self)
        }
    }
}
