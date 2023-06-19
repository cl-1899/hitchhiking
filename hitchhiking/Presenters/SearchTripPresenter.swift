import Foundation

protocol SearchTripPresenterProtocol {
    func getTrips(from: String, to: String, date: Date)
    func signOut()
    func showCityPicker(with searchText: String?)
    func hideCityPicker()
}

class SearchTripPresenter: SearchTripPresenterProtocol {
    private let model: SearchTripModelProtocol
    private weak var view: SearchTripViewProtocol?
    
    init(model: SearchTripModelProtocol, view: SearchTripViewProtocol) {
        self.model = model
        self.view = view
    }
    
    func getTrips(from: String, to: String, date: Date) {
        model.getTrips(date: date, from: from, to: to) { [weak self] trips, error in
            guard let self = self else { return }
            
            if let error {
                self.view?.showErrorAlert(error)
            } else if let trips {
                self.view?.showTripResults(trips: trips)
            } else {
                self.view?.showNoResultsAfterSearchAlert()
            }
        }
    }
    
    func signOut() {
        model.signOut() { [weak self] success, error in
            guard let self = self else { return }
            
            if let error {
                self.view?.showErrorAlert(error)
            } else {
                self.view?.showMainScreen()
            }
        }
    }
    
    func showCityPicker(with searchText: String?) {
        view?.showCityPickerView(with: searchText)
    }
    
    func hideCityPicker() {
        view?.hideCityPickerView()
    }
}
