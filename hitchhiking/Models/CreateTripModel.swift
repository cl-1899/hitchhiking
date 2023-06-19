import FirebaseAuth
import FirebaseDatabase

protocol CreateTripModelProtocol {
    func addTrip(trip: Trip, completion: @escaping (Bool, Error?) -> Void)
    func signOut(completion: @escaping (Bool, Error?) -> Void)
}

class CreateTripModel: CreateTripModelProtocol {
    func addTrip(trip: Trip, completion: @escaping (Bool, Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let tripData: [String: Any] = [
            "nameDriver": trip.nameDriver,
            "from": trip.from,
            "to": trip.to,
            "date": dateFormatter.string(from: trip.date),
            "availableSeats": trip.availableSeats,
            "phoneNumber": trip.phoneNumber
        ]
        
        let databaseRef = Database.database().reference()
        let tripRef = databaseRef.child("trips").childByAutoId()
        
        tripRef.setValue(tripData) { (error, ref) in
            if let error {
                completion(false, error)
                return
            } else {
                completion(true, nil)
            }
        }
    }
    
    func signOut(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let error as NSError {
            completion(false, error)
        }
    }
}
