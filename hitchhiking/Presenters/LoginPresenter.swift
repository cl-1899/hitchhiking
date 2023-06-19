import Foundation

protocol LoginPresenterProtocol {
    func signIn(email: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {
    private var loginModel: LoginModelProtocol
    private weak var loginView: LoginViewProtocol?
    
    init(loginModel: LoginModelProtocol, loginView: LoginViewProtocol) {
        self.loginModel = loginModel
        self.loginView = loginView
    }
    
    func signIn(email: String, password: String) {
        loginModel.signIn(email: email, password: password) { [weak self] success, error in
            guard let self = self else { return }
            
            if let error {
                self.loginView?.showErrorAlert(error)
            } else {
                self.loginView?.showNextScreen()
            }
        }
    }
}
