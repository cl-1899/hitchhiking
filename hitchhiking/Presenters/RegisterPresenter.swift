import Foundation

protocol RegisterPresenterProtocol {
    func registerUser(email: String, password: String)
}

class RegisterPresenter: RegisterPresenterProtocol {
    private var registerModel: RegisterModelProtocol
    private weak var registerView: RegisterViewProtocol?
    
    init(registerModel: RegisterModelProtocol, registerView: RegisterViewProtocol) {
        self.registerModel = registerModel
        self.registerView = registerView
    }
    
    func registerUser(email: String, password: String) {
        registerModel.registerUser(email: email, password: password) { [weak self] success, error in
            guard let self = self else { return }
            
            if let error {
                self.registerView?.showErrorAlert(error)
            } else {
                self.registerView?.showRegistrationSuccessAlert()
            }
        }
    }
}
