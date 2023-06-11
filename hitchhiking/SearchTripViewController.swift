import UIKit
import FirebaseAuth

class SearchTripViewController: UIViewController {
    
    var cityDataManager: CityDataManager!
    var tripManager: TripManager!
    var searchTripView: UIView!
    var fromWhereTextField: UITextField!
    var toWhereTextField: UITextField!
    var datePicker: UIDatePicker!
    var cityPickerView: UITableView!
    var filteredCities: [String] = []
    var isShowingCityPicker: Bool = false
    
    let backgroundImage = UIImage(named: "backgroundImage")

    private func addSearchTripView(parentView: UIViewController) {
        cityPickerView = UITableView(frame: .zero)
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        cityPickerView.isHidden = true
        cityPickerView.layer.cornerRadius = 15
        cityPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.backgroundColor = UIColor.systemBlue
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.layer.cornerRadius = 15
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchTripView = UIView()
        searchTripView.backgroundColor = UIColor.white
        searchTripView.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.layer.cornerRadius = 15
        
        fromWhereTextField = UITextField()
        fromWhereTextField.tag = 1
        fromWhereTextField.borderStyle = .none
        fromWhereTextField.placeholder = "Откуда"
        fromWhereTextField.delegate = self
        fromWhereTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.addSubview(fromWhereTextField)
        
        let firstSeparatorView = UIView()
        firstSeparatorView.backgroundColor = UIColor.lightGray
        firstSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.addSubview(firstSeparatorView)
        
        toWhereTextField = UITextField()
        toWhereTextField.tag = 2
        toWhereTextField.borderStyle = .none
        toWhereTextField.placeholder = "Куда"
        toWhereTextField.delegate = self
        toWhereTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.addSubview(toWhereTextField)
        
        let secondSeparatorView = UIView()
        secondSeparatorView.backgroundColor = UIColor.lightGray
        secondSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.addSubview(secondSeparatorView)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: false)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.addSubview(datePicker)
        
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("Поиск", for: .normal)
        searchButton.backgroundColor = UIColor.systemBlue
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.layer.cornerRadius = 15
        searchButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.addSubview(searchButton)
        
        searchTripView.widthAnchor.constraint(equalToConstant: 315).isActive = true
        searchTripView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        fromWhereTextField.leadingAnchor.constraint(equalTo: searchTripView.leadingAnchor, constant: 10).isActive = true
        fromWhereTextField.trailingAnchor.constraint(equalTo: searchTripView.trailingAnchor, constant: -10).isActive = true
        fromWhereTextField.topAnchor.constraint(equalTo: searchTripView.topAnchor, constant: 10).isActive = true
        fromWhereTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        firstSeparatorView.leadingAnchor.constraint(equalTo: fromWhereTextField.leadingAnchor).isActive = true
        firstSeparatorView.trailingAnchor.constraint(equalTo: fromWhereTextField.trailingAnchor).isActive = true
        firstSeparatorView.topAnchor.constraint(equalTo: fromWhereTextField.bottomAnchor).isActive = true
        firstSeparatorView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        toWhereTextField.leadingAnchor.constraint(equalTo: searchTripView.leadingAnchor, constant: 10).isActive = true
        toWhereTextField.trailingAnchor.constraint(equalTo: searchTripView.trailingAnchor, constant: -10).isActive = true
        toWhereTextField.topAnchor.constraint(equalTo: firstSeparatorView.bottomAnchor).isActive = true
        toWhereTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        secondSeparatorView.leadingAnchor.constraint(equalTo: toWhereTextField.leadingAnchor).isActive = true
        secondSeparatorView.trailingAnchor.constraint(equalTo: toWhereTextField.trailingAnchor).isActive = true
        secondSeparatorView.topAnchor.constraint(equalTo: toWhereTextField.bottomAnchor).isActive = true
        secondSeparatorView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        datePicker.leadingAnchor.constraint(equalTo: searchTripView.leadingAnchor, constant: 10).isActive = true
        datePicker.topAnchor.constraint(equalTo: secondSeparatorView.bottomAnchor, constant: 10).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        searchButton.leadingAnchor.constraint(equalTo: searchTripView.leadingAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: searchTripView.trailingAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: searchTripView.bottomAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        parentView.view.addSubview(searchTripView)
        parentView.view.addSubview(cityPickerView)
        parentView.view.addSubview(logoutButton)
        
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        searchTripView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTripView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10).isActive = true
        
        cityPickerView.topAnchor.constraint(equalTo: searchTripView.bottomAnchor, constant: 10).isActive = true
        cityPickerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4).isActive = true
        cityPickerView.centerXAnchor.constraint(equalTo: searchTripView.centerXAnchor).isActive = true
        cityPickerView.widthAnchor.constraint(equalToConstant: 315).isActive = true
    }
    
    private func alertAfterPress(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        addSearchTripView(parentView: self)
        
        cityDataManager = CityDataManager()
        tripManager = TripManager()
        
        print(tripManager.trips)
    }
    
    func showCityPicker(with searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredCities = cityDataManager.searchCity(request: searchText)
            cityPickerView.reloadData()
            cityPickerView.layoutIfNeeded()
                        
            cityPickerView.isHidden = false
            isShowingCityPicker = true
        } else {
            hideCityPicker()
        }
    }
    
    func hideCityPicker() {
        cityPickerView.isHidden = true
        isShowingCityPicker = false
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        let fromWhere = fromWhereTextField.text ?? ""
        let toWhere = toWhereTextField.text ?? ""
        let selectedDate = datePicker.date
        
        let filteredTrips = tripManager.getAllTrips().filter { trip in
            let fromMatch = fromWhere.isEmpty || trip.from.fullName.localizedCaseInsensitiveContains(fromWhere)
            let toMatch = toWhere.isEmpty || trip.to.fullName.localizedCaseInsensitiveContains(toWhere)
            let dateMatch = Calendar.current.isDate(trip.date, inSameDayAs: selectedDate)
            
            return fromMatch && toMatch && dateMatch
        }
        
        if filteredTrips.isEmpty {
            let alert = UIAlertController(title: "Ничего не найдено", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let tripResultsVC = TripResultsViewController(trips: filteredTrips)
            let tripResultsNavController = UINavigationController(rootViewController: tripResultsVC)
            present(tripResultsNavController, animated: true, completion: nil)
//            navigationController?.pushViewController(tripResultsVC, animated: true)
        }
    }
    
    @objc private func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            let message = "Ошибка при разлогине"
            print(message + ": " + signOutError.localizedDescription)
            self.alertAfterPress(message)
            return
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        view.endEditing(true)
    }
}

extension SearchTripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCities.isEmpty {
            return 1
        } else {
            return filteredCities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredCities.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "нет результатов"
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = filteredCities[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredCities.isEmpty {
            let selectedCity = filteredCities[indexPath.row]
            
            if fromWhereTextField.isFirstResponder {
                fromWhereTextField.text = selectedCity
            } else if toWhereTextField.isFirstResponder {
                toWhereTextField.text = selectedCity
            }
            
            hideCityPicker()
        }
    }
}

extension SearchTripViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == fromWhereTextField || textField == toWhereTextField {
            showCityPicker(with: textField.text)
        }
    }
}

//func showCityPicker(with searchText: String?) {
//        if let searchText = searchText, !searchText.isEmpty {
//            filteredCities = cityDataManager.searchCity(request: searchText)
//            cityPickerView.reloadData()
//
//            cityPickerView.isHidden = false
//            isShowingCityPicker = true
//
//            let maxTableHeight: CGFloat = 180
//            let rowHeight: CGFloat = 36
//            var numRows: Int
//            if !filteredCities.isEmpty {
//                numRows = filteredCities.count
//            } else {
//                numRows = 1
//            }
//            let tableHeight = min(Double(numRows) * rowHeight, maxTableHeight)
//
//            cityPickerView.frame.size.height = tableHeight
//
//            self.view.bringSubviewToFront(cityPickerView)
//        } else {
//            hideCityPicker()
//        }
//    }
