import FirebaseAuth
import FirebaseDatabase

protocol SearchTripModelProtocol {
    func getTrips(date: Date, from: String, to: String, completion: @escaping ([Trip]?, Error?) -> Void)
    func signOut(completion: @escaping (Bool, Error?) -> Void)
}

class SearchTripModel: SearchTripModelProtocol {
    func getTrips(date: Date, from: String, to: String, completion: @escaping ([Trip]?, Error?) -> Void) {
        let tripsRef = Database.database().reference().child("trips")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let query = tripsRef.queryOrdered(byChild: "date").queryEqual(toValue: dateFormatter.string(from: date))
        query.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists(), let tripDIcts = snapshot.value as? [String: [String: Any]] else {
                completion(nil, nil)
                return
            }
            
            var trips: [Trip] = []
            
            for (_, tripDict) in tripDIcts {
                
                if let tripFrom = tripDict["from"] as? String,
                   let tripTo = tripDict["to"] as? String,
                   (tripFrom == from) || (from == ""),
                   (tripTo == to) || (to == "") {
                    
                    if let nameDriver = tripDict["nameDriver"] as? String,
                       let from = tripDict["from"] as? String,
                       let to = tripDict["to"] as? String,
                       let dateString = tripDict["date"] as? String,
                       let availableSeats = tripDict["availableSeats"] as? Int,
                       let phoneNumber = tripDict["phoneNumber"] as? String,
                       let date = dateFormatter.date(from: dateString) {
                        
                        let trip = Trip(nameDriver: nameDriver, from: from, to: to, date: date, availableSeats: availableSeats, phoneNumber: phoneNumber)
                        trips.append(trip)
                    }
                }
            }
            if trips.count > 0 {
                completion(trips, nil)
            } else {
                completion(nil, nil)
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
