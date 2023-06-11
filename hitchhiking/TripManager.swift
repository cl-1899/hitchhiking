import Foundation

struct Trip {
    let nameDriver: String?
    let from: CityData
    let to: CityData
    let date: Date
    let availableSeats: Int
    let phoneNumber: String
}

class TripManager {
    var trips: [Trip] = []
    private let cityDataManager = CityDataManager()
    
    init() {
        cityDataManager.parseJSON()
        createTrips()
        createRandomTrips(count: 50)
    }
    
    func createTrips() {
        let phoneNumber = "1234567890"
        
        let cityDataFrom1 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo1 = CityData(cityName: "Борисов", fullName: "Борисов, Минская обл.")
        let trip1 = Trip(nameDriver: "Игорь", from: cityDataFrom1, to: cityDataTo1, date: Date(), availableSeats: 3, phoneNumber: phoneNumber)
        addTrip(trip: trip1)
        
        let cityDataFrom2 = CityData(cityName: "Лида", fullName: "Лида, Гродненская обл.")
        let cityDataTo2 = CityData(cityName: "Слоним", fullName: "Слоним, Гродненская обл.")
        let trip2 = Trip(nameDriver: "Андрей", from: cityDataFrom2, to: cityDataTo2, date: Date(), availableSeats: 2, phoneNumber: phoneNumber)
        addTrip(trip: trip2)
        
        let cityDataFrom3 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo3 = CityData(cityName: "Слоним", fullName: "Слоним, Гродненская обл.")
        let trip3 = Trip(nameDriver: "Сергей", from: cityDataFrom3, to: cityDataTo3, date: Date(), availableSeats: 1, phoneNumber: phoneNumber)
        addTrip(trip: trip3)
        
        let cityDataFrom4 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo4 = CityData(cityName: "Слоним", fullName: "Слоним, Гродненская обл.")
        let trip4 = Trip(nameDriver: "Сергей", from: cityDataFrom4, to: cityDataTo4, date: Date(), availableSeats: 7, phoneNumber: phoneNumber)
        addTrip(trip: trip4)
        
        let cityDataFrom5 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo5 = CityData(cityName: "Гродно", fullName: "Гродно, Гродненская обл.")
        let trip5 = Trip(nameDriver: "Ирина", from: cityDataFrom5, to: cityDataTo5, date: Date(), availableSeats: 2, phoneNumber: phoneNumber)
        addTrip(trip: trip5)
        
        let cityDataFrom6 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo6 = CityData(cityName: "Гродно", fullName: "Гродно, Гродненская обл.")
        let trip6 = Trip(nameDriver: "Михаил", from: cityDataFrom6, to: cityDataTo6, date: Date(), availableSeats: 3, phoneNumber: phoneNumber)
        addTrip(trip: trip6)
        
        let cityDataFrom7 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo7 = CityData(cityName: "Гродно", fullName: "Гродно, Гродненская обл.")
        let trip7 = Trip(nameDriver: nil, from: cityDataFrom7, to: cityDataTo7, date: Date(), availableSeats: 1, phoneNumber: phoneNumber)
        addTrip(trip: trip7)
        
        let cityDataFrom8 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo8 = CityData(cityName: "Гродно", fullName: "Гродно, Гродненская обл.")
        let trip8 = Trip(nameDriver: "Александр", from: cityDataFrom8, to: cityDataTo8, date: Date(), availableSeats: 3, phoneNumber: phoneNumber)
        addTrip(trip: trip8)
        
        let cityDataFrom9 = CityData(cityName: "Минск", fullName: "Минск, Минская обл.")
        let cityDataTo9 = CityData(cityName: "Гродно", fullName: "Гродно, Гродненская обл.")
        let trip9 = Trip(nameDriver: nil, from: cityDataFrom9, to: cityDataTo9, date: Date(), availableSeats: 4, phoneNumber: phoneNumber)
        addTrip(trip: trip9)
        
        let cityDataFrom10 = CityData(cityName: "Минск", fullName: "Минская обл.")
        let cityDataTo10 = CityData(cityName: "Гродно", fullName: "Гродно, Гродненская обл.")
        let trip10 = Trip(nameDriver: "Андрей", from: cityDataFrom10, to: cityDataTo10, date: Date(), availableSeats: 2, phoneNumber: phoneNumber)
        addTrip(trip: trip10)
    }
    
    func createRandomTrips(count: Int) {
        let cityDataArray = cityDataManager.cityDataArray
        
        for _ in 1...count {
            let randomIndexFrom = Int.random(in: 0..<cityDataArray.count)
            let randomIndexTo = Int.random(in: 0..<cityDataArray.count)
            let randomAvailableSeats = Int.random(in: 1...10)
            
            let phoneNumber = "9876543210"
            let fromCityData = cityDataArray[randomIndexFrom]
            let toCityData = cityDataArray[randomIndexTo]
            
            let trip = Trip(nameDriver: nil, from: fromCityData, to: toCityData, date: Date(), availableSeats: randomAvailableSeats, phoneNumber: phoneNumber)
            
            addTrip(trip: trip)
        }
    }

    func addTrip(trip: Trip) {
        trips.append(trip)
    }

    func removeTrip(at index: Int) {
        trips.remove(at: index)
    }

    func getAllTrips() -> [Trip] {
        return trips
    }
}
