import UIKit

protocol SearchTripViewProtocol: AnyObject {
    func showNoResultsAfterSearchAlert()
    func showTripResults(trips: [Trip])
    func showErrorAlert(_ error: Error)
    func showMainScreen()
    func showCityPickerView(with searchText: String?)
    func hideCityPickerView()
}

class SearchTripViewController: UIViewController {
    private var presenter: SearchTripPresenterProtocol!
    private var cityDataManager: CityDataManager!
    private var logoutButton: UIButton!
    private var searchTripView: UIView!
    private var fromWhereTextField: UITextField!
    private var toWhereTextField: UITextField!
    private var datePicker: UIDatePicker!
    private var searchButton: UIButton!
    private var cityPickerView: UITableView!
    private var cityPickerTopConstraint: NSLayoutConstraint!
    private var filteredCities: [String] = []
    private var isShowingCityPicker: Bool = false
    
    let backgroundImage = UIImage(named: "backgroundImageSearchTrip")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        cityDataManager = CityDataManager()
        setupViews()
        setupPresenter()
    }

    private func setupViews() {
        cityPickerView = UITableView(frame: .zero)
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        cityPickerView.isHidden = true
        cityPickerView.layer.cornerRadius = 15
        cityPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cityPickerView)
        
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.backgroundColor = UIColor.systemBlue
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.layer.cornerRadius = 15
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        searchTripView = UIView()
        searchTripView.backgroundColor = UIColor.white
        searchTripView.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.layer.cornerRadius = 15
        view.addSubview(searchTripView)
        
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
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        searchTripView.addSubview(datePicker)
        
        searchButton = UIButton(type: .system)
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
        
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        searchTripView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTripView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10).isActive = true
        
        cityPickerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4).isActive = true
        cityPickerView.centerXAnchor.constraint(equalTo: searchTripView.centerXAnchor).isActive = true
        cityPickerView.widthAnchor.constraint(equalToConstant: 315).isActive = true
    }
    
    private func setupPresenter() {
        let model = SearchTripModel()
        presenter = SearchTripPresenter(model: model, view: self)
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        let fromWhere = fromWhereTextField.text ?? ""
        let toWhere = toWhereTextField.text ?? ""
        let selectedDate = datePicker.date
        
        presenter.getTrips(from: fromWhere, to: toWhere, date: selectedDate)
    }
    
    @objc private func logoutButtonTapped() {
        presenter.signOut()
    }
    
    @objc private func dismissTripResults() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchTripViewController: SearchTripViewProtocol {
    func showNoResultsAfterSearchAlert() {
        AlertManager.noResultsAfterSearchAlert(self)
    }
    
    func showTripResults(trips: [Trip]) {
        let tripResultsVC = TripResultsViewController(trips: trips)
        let tripResultsNavController = UINavigationController(rootViewController: tripResultsVC)
        tripResultsNavController.modalPresentationStyle = .fullScreen

        let backButton = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(dismissTripResults))
        tripResultsVC.navigationItem.leftBarButtonItem = backButton

        present(tripResultsNavController, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ error: Error) {
        AlertManager.errorAlert(self, error)
    }
    
    func showMainScreen() {
        if let rootVC = storyboard?.instantiateViewController(withIdentifier: "ZeroViewController") {
            rootVC.modalPresentationStyle = .fullScreen
            rootVC.modalTransitionStyle = .flipHorizontal
            
            show(rootVC, sender: self)
        }
    }
    
    func showCityPickerView(with searchText: String?) {
        guard let searchText, !searchText.isEmpty else {
            hideCityPickerView()
            return
        }

        filteredCities = cityDataManager.searchCity(request: searchText)
        cityPickerView.reloadData()
        cityPickerView.layoutIfNeeded()
        
        view.bringSubviewToFront(cityPickerView)

        cityPickerView.isHidden = false
        isShowingCityPicker = true
    }

    func hideCityPickerView() {
        cityPickerView.isHidden = true
        isShowingCityPicker = false
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

            hideCityPickerView()
        }
    }
}

extension SearchTripViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == fromWhereTextField || textField == toWhereTextField {
            if cityPickerTopConstraint != nil {
                cityPickerTopConstraint.isActive = false
            }
            cityPickerTopConstraint = cityPickerView.topAnchor.constraint(equalTo: textField.bottomAnchor)
            cityPickerTopConstraint.isActive = true
            presenter.showCityPicker(with: textField.text)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fromWhereTextField || textField == toWhereTextField {
            cityPickerTopConstraint?.isActive = false
            presenter.hideCityPicker()
        }
    }
}
