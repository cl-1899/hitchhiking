import Foundation

protocol ForgotPasswordPresenterProtocol {
    func sendEmailForRecoveryWithCompletion(email: String)
}

class ForgotPasswordPresenter: ForgotPasswordPresenterProtocol {
    private let model: ForgotPasswordModelProtocol
    private weak var view: ForgotPasswordViewProtocol?
    
    init(model: ForgotPasswordModelProtocol, view: ForgotPasswordViewProtocol) {
        self.model = model
        self.view = view
    }
    
    func sendEmailForRecoveryWithCompletion(email: String) {
        model.sendEmailForRecovery(email: email) { [weak self] error in
            if let error {
                self?.view?.showErrorAlert(error)
            } else {
                self?.view?.showEmailSendSuccessAlert()
            }
        }
    }
}
