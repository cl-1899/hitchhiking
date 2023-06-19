import Foundation

protocol CreateTripPresenterProtocol {
    func addTrip(trip: Trip)
    func signOut()
    func showCityPicker(with searchText: String?)
    func hideCityPicker()
}

class CreateTripPresenter: CreateTripPresenterProtocol {
    private var model: CreateTripModelProtocol
    private weak var view: CreateTripViewProtocol?
    
    init(model: CreateTripModelProtocol, view: CreateTripViewProtocol?) {
        self.model = model
        self.view = view
    }
    
    func addTrip(trip: Trip) {
        model.addTrip(trip: trip) { [weak self] success, error in
            guard let self = self else { return }
            
            if let error {
                self.view?.showErrorAlert(error)
            } else {
                self.view?.showCreatingTripSuccessAlert()
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
