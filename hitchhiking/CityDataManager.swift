import Foundation

struct City: Codable {
    let name: String
    let lat: Double
    let lng: Double
}

struct Region: Codable {
    let name: String
    let cities: [City]
}

struct Country: Codable {
    let name: String
    let regions: [Region]
}

struct CityData {
    let cityName: String
    let fullName: String
}

class CityDataManager {
    var cityDataArray: [CityData] = []
    
    init() {
        parseJSON()
    }
    
    func parseJSON() {
        guard let fileURL = Bundle.main.url(forResource: "BelarusCities", withExtension: "json") else {
            print("JSON file is not found")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let country = try decoder.decode(Country.self, from: jsonData)
            
            for region in country.regions {
                for city in region.cities {
                    let fullName = "\(city.name), \(region.name)"
                    let cityData = CityData(cityName: city.name, fullName: fullName)
                    cityDataArray.append(cityData)
                }
            }
        } catch {
            print("Ошибка разбора файла JSON: \(error.localizedDescription)")
        }
    }
    
    func searchCity(request: String) -> [String] {
        let filteredData = cityDataArray.filter { $0.cityName.lowercased().contains(request.lowercased()) }
        let result = filteredData.map { $0.fullName }
        return result
    }
}
