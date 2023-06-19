import UIKit

protocol ForgotPasswordViewProtocol: AnyObject {
    func showErrorAlert(_ error: Error)
    func showEmailSendSuccessAlert()
}

class ForgotPasswordViewController: UIViewController {
    private var presenter: ForgotPasswordPresenterProtocol!
    private var emailTextField: StyleChangedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupPresenter()
    }
    
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
    
    private func setupPresenter() {
        let model = ForgotPasswordModel()
        presenter = ForgotPasswordPresenter(model: model, view: self)
    }
    
    private func clearTextField() {
        emailTextField.text = ""
    }
    
    @objc func buttonTapped() {
        guard let email = emailTextField.text else {
            return
        }
        
        guard ValidationManager.isValidEmail(email) else {
            AlertManager.invalidEmailAlert(self)
            return
        }
        
        presenter.sendEmailForRecoveryWithCompletion(email: email)
    }
}

extension ForgotPasswordViewController: ForgotPasswordViewProtocol {
    func showErrorAlert(_ error: Error) {
        AlertManager.errorAlert(self, error)
    }
    
    func showEmailSendSuccessAlert() {
        AlertManager.emailSendSuccessAlert(self)
        
        DispatchQueue.main.async {
            [weak self] in self?.clearTextField()
        }
    }
}
