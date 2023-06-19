import FirebaseAuth

protocol LoginModelProtocol {
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void)
}

class LoginModel: LoginModelProtocol {
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error {
                completion(false, error)
                return
            }
            // Вход выполнен успешно
            completion(true, nil)
        }
    }
}
