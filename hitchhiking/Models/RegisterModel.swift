import FirebaseAuth
import FirebaseDatabase

protocol RegisterModelProtocol {
    func registerUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void)
}

class RegisterModel: RegisterModelProtocol {
    func registerUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error {
                completion(false, error)
                return
            }
            
            guard let userID = authResult?.user.uid else {
                completion(false, nil)
                return
            }
            
            let userData: [String: Any] = [
                "email": email,
                "password": password
            ]
            
            let databaseRef = Database.database().reference()
            let usersRef = databaseRef.child("users")
            
            usersRef.child(userID).setValue(userData) { (error, _) in
                if let error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}
