import UIKit

class AlertManager {
    private static func alertAfterPress(_ vc: UIViewController, _ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alertController.addAction(okAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}

// Validation

extension AlertManager {
    public static func invalidEmailAlert(_ vc: UIViewController) {
        let message = "Адрес электронной почты введён неверно."
        self.alertAfterPress(vc, message)
        print(message)
    }
    
    public static func invalidPasswordAlert(_ vc: UIViewController) {
        let message = "Пароль должен содержать не менее 6 символов."
        self.alertAfterPress(vc, message)
        print(message)
    }
}

// Error

extension AlertManager {
    public static func errorAlert(_ vc: UIViewController, _ error: Error) {
        let message = error.localizedDescription
        self.alertAfterPress(vc, message)
        print(message)
    }
}

// Login

extension AlertManager {
    public static func smthIsEmptyAlert(_ vc: UIViewController) {
        let message = "Не всё заполнено."
        self.alertAfterPress(vc, message)
        print(message)
    }
}

// Registration

extension AlertManager {
    public static func noEmailAlert(_ vc: UIViewController) {
        let message = "Введите адрес электронной почты."
        self.alertAfterPress(vc, message)
        print(message)
    }
    
    public static func noPasswordAlert(_ vc: UIViewController) {
        let message = "Введите пароль."
        self.alertAfterPress(vc, message)
        print(message)
    }
    
    public static func noPasswordConfirmationAlert(_ vc: UIViewController) {
        let message = "Введите подтверждение пароля."
        self.alertAfterPress(vc, message)
        print(message)
    }
    
    public static func passwordsMismatchAlert(_ vc: UIViewController) {
        let message = "Пароли не совпадают."
        self.alertAfterPress(vc, message)
        print(message)
    }
    
    public static func registrationHadSuccessAlert(_ vc: UIViewController) {
        let message = "Регистрация прошла успешно"
        self.alertAfterPress(vc, message)
        print(message)
    }
}

// Logout

extension AlertManager {
    public static func logoutErrorAlert(_ vc: UIViewController, _ error: Error) {
        let message = "Ошибка при разлогине"
        self.alertAfterPress(vc, message)
        print(message + ": " + error.localizedDescription)
    }
}

// Forgot Password

extension AlertManager {
    public static func emailSendSuccessAlert(_ vc: UIViewController) {
        let message = "Ваш Email отправлен для восстановления пароля, ждите обратной связи."
        self.alertAfterPress(vc, message)
    }
}

// Search Trip

extension AlertManager {
    public static func noResultsAfterSearchAlert(_ vc: UIViewController) {
        let message = "Ничего не найдено"
        self.alertAfterPress(vc, message)
    }
}

// Create Trip

extension AlertManager {
    public static func tripCreationHadSuccessAlert(_ vc: UIViewController) {
        let message = "Поездка создана успешно"
        self.alertAfterPress(vc, message)
        print(message)
    }
    
    public static func NotEverythingFilled(_ vc: UIViewController) {
        let message = "Заполните пожалуйста все поля"
        self.alertAfterPress(vc, message)
        print(message)
    }
}
