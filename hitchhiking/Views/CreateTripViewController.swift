import UIKit

protocol CreateTripViewProtocol: AnyObject {
    func showErrorAlert(_ error: Error)
    func showCreatingTripSuccessAlert()
    func showMainScreen()
    func showCityPickerView(with searchText: String?)
    func hideCityPickerView()
}

class CreateTripViewController: UIViewController {
    private var presenter: CreateTripPresenterProtocol!
    private var cityDataManager: CityDataManager!
    private var logoutButton: UIButton!
    private var createTripView: UIView!
    private var nameTextField: UITextField!
    private var fromWhereTextField: UITextField!
    private var toWhereTextField: UITextField!
    private var phoneNumberTextField: UITextField!
    private var datePicker: UIDatePicker!
    private var availableSeatsStepper: UIStepper!
    private var availableSeatsCountLabel: UILabel!
    private var createButton: UIButton!
    private var cityPickerView: UITableView!
    private var filteredCities: [String] = []
    private var isShowingCityPicker: Bool = false
    
    let backgroundImage = UIImage(named: "backgroundImageCreateTrip")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        cityDataManager = CityDataManager()
        addCreateTripView()
        setupPresenter()
    }

    private func addCreateTripView() {
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
        logoutButton.backgroundColor = UIColor.white
        logoutButton.setTitleColor(UIColor.systemBlue, for: .normal)
        logoutButton.layer.cornerRadius = 15
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        createTripView = UIView()
        createTripView.backgroundColor = UIColor.white
        createTripView.translatesAutoresizingMaskIntoConstraints = false
        createTripView.layer.cornerRadius = 15
        view.addSubview(createTripView)
        
        nameTextField = UITextField()
        nameTextField.borderStyle = .none
        nameTextField.placeholder = "Ваше имя"
        nameTextField.delegate = self
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(nameTextField)
        
        let firstSeparatorView = UIView()
        firstSeparatorView.backgroundColor = UIColor.lightGray
        firstSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(firstSeparatorView)
        
        fromWhereTextField = UITextField()
        fromWhereTextField.tag = 1
        fromWhereTextField.borderStyle = .none
        fromWhereTextField.placeholder = "Откуда"
        fromWhereTextField.delegate = self
        fromWhereTextField.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(fromWhereTextField)
        
        let secondSeparatorView = UIView()
        secondSeparatorView.backgroundColor = UIColor.lightGray
        secondSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(secondSeparatorView)
        
        toWhereTextField = UITextField()
        toWhereTextField.tag = 2
        toWhereTextField.borderStyle = .none
        toWhereTextField.placeholder = "Куда"
        toWhereTextField.delegate = self
        toWhereTextField.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(toWhereTextField)
        
        let thirdSeparatorView = UIView()
        thirdSeparatorView.backgroundColor = UIColor.lightGray
        thirdSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(thirdSeparatorView)
        
        phoneNumberTextField = UITextField()
        phoneNumberTextField.borderStyle = .none
        phoneNumberTextField.placeholder = "Ваш номер телефона"
        phoneNumberTextField.delegate = self
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(phoneNumberTextField)
        
        let forthSeparatorView = UIView()
        forthSeparatorView.backgroundColor = UIColor.lightGray
        forthSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(forthSeparatorView)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: false)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(datePicker)
        
        availableSeatsStepper = UIStepper()
        availableSeatsStepper.minimumValue = 1
        availableSeatsStepper.maximumValue = 10
        availableSeatsStepper.stepValue = 1
        availableSeatsStepper.value = 1
        availableSeatsStepper.addTarget(self, action: #selector(availableSeatsStepperValueChanged), for: .valueChanged)
        availableSeatsStepper.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(availableSeatsStepper)
        
        availableSeatsCountLabel = UILabel()
        availableSeatsCountLabel.text = "Количество свободных мест: 1"
        availableSeatsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(availableSeatsCountLabel)
        
        createButton = UIButton(type: .system)
        createButton.setTitle("Создать", for: .normal)
        createButton.backgroundColor = UIColor.systemBlue
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.layer.cornerRadius = 15
        createButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        createButton.addTarget(self, action: #selector(createTripButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createTripView.addSubview(createButton)
        
        createTripView.widthAnchor.constraint(equalToConstant: 315).isActive = true
        createTripView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: createTripView.leadingAnchor, constant: 10).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: createTripView.trailingAnchor, constant: -10).isActive = true
        nameTextField.topAnchor.constraint(equalTo: createTripView.topAnchor, constant: 5).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        firstSeparatorView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        firstSeparatorView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor).isActive = true
        firstSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        firstSeparatorView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        fromWhereTextField.leadingAnchor.constraint(equalTo: createTripView.leadingAnchor, constant: 10).isActive = true
        fromWhereTextField.trailingAnchor.constraint(equalTo: createTripView.trailingAnchor, constant: -10).isActive = true
        fromWhereTextField.topAnchor.constraint(equalTo: firstSeparatorView.bottomAnchor).isActive = true
        fromWhereTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        secondSeparatorView.leadingAnchor.constraint(equalTo: fromWhereTextField.leadingAnchor).isActive = true
        secondSeparatorView.trailingAnchor.constraint(equalTo: fromWhereTextField.trailingAnchor).isActive = true
        secondSeparatorView.topAnchor.constraint(equalTo: fromWhereTextField.bottomAnchor).isActive = true
        secondSeparatorView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        toWhereTextField.leadingAnchor.constraint(equalTo: createTripView.leadingAnchor, constant: 10).isActive = true
        toWhereTextField.trailingAnchor.constraint(equalTo: createTripView.trailingAnchor, constant: -10).isActive = true
        toWhereTextField.topAnchor.constraint(equalTo: secondSeparatorView.bottomAnchor).isActive = true
        toWhereTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        thirdSeparatorView.leadingAnchor.constraint(equalTo: toWhereTextField.leadingAnchor).isActive = true
        thirdSeparatorView.trailingAnchor.constraint(equalTo: toWhereTextField.trailingAnchor).isActive = true
        thirdSeparatorView.topAnchor.constraint(equalTo: toWhereTextField.bottomAnchor).isActive = true
        thirdSeparatorView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        phoneNumberTextField.leadingAnchor.constraint(equalTo: createTripView.leadingAnchor, constant: 10).isActive = true
        phoneNumberTextField.trailingAnchor.constraint(equalTo: createTripView.trailingAnchor, constant: -10).isActive = true
        phoneNumberTextField.topAnchor.constraint(equalTo: thirdSeparatorView.bottomAnchor).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        forthSeparatorView.leadingAnchor.constraint(equalTo: phoneNumberTextField.leadingAnchor).isActive = true
        forthSeparatorView.trailingAnchor.constraint(equalTo: phoneNumberTextField.trailingAnchor).isActive = true
        forthSeparatorView.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor).isActive = true
        forthSeparatorView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        datePicker.leadingAnchor.constraint(equalTo: createTripView.leadingAnchor, constant: 10).isActive = true
        datePicker.topAnchor.constraint(equalTo: forthSeparatorView.bottomAnchor, constant: 5).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        availableSeatsStepper.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 5).isActive = true
        availableSeatsStepper.centerXAnchor.constraint(equalTo: createTripView.centerXAnchor).isActive = true
        availableSeatsStepper.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        availableSeatsCountLabel.topAnchor.constraint(equalTo: availableSeatsStepper.bottomAnchor, constant: 5).isActive = true
        availableSeatsCountLabel.centerXAnchor.constraint(equalTo: createTripView.centerXAnchor).isActive = true
        availableSeatsCountLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        createButton.leadingAnchor.constraint(equalTo: createTripView.leadingAnchor).isActive = true
        createButton.trailingAnchor.constraint(equalTo: createTripView.trailingAnchor).isActive = true
        createButton.bottomAnchor.constraint(equalTo: createTripView.bottomAnchor).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        createTripView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createTripView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10).isActive = true
        
        cityPickerView.topAnchor.constraint(equalTo: createTripView.bottomAnchor, constant: 10).isActive = true
        cityPickerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4).isActive = true
        cityPickerView.centerXAnchor.constraint(equalTo: createTripView.centerXAnchor).isActive = true
        cityPickerView.widthAnchor.constraint(equalToConstant: 315).isActive = true
    }
    
    private func setupPresenter() {
        let model = CreateTripModel()
        presenter = CreateTripPresenter(model: model, view: self)
    }
    
    private func clearTextFields() {
        self.nameTextField.text = ""
        self.fromWhereTextField.text = ""
        self.toWhereTextField.text = ""
        self.phoneNumberTextField.text = ""
        self.datePicker.setDate(Date(), animated: false)
        self.availableSeatsStepper.value = 1
        self.availableSeatsCountLabel.text = "Количество свободных мест: 1"
    }
    
    @objc private func availableSeatsStepperValueChanged() {
        let seatCount = Int(availableSeatsStepper.value)
        availableSeatsCountLabel.text = "Количество свободных мест: \(seatCount)"
    }
    
    @objc func createTripButtonTapped(_ sender: UIButton) {
        guard
            let nameDriver = nameTextField.text,
            let fromWhere = fromWhereTextField.text,
            let toWhere = toWhereTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            !nameDriver.isEmpty,
            !fromWhere.isEmpty,
            !toWhere.isEmpty,
            !phoneNumber.isEmpty
        else {
            AlertManager.NotEverythingFilled(self)
            return
        }
                
        let selectedDate = datePicker.date
        let availableSeats = availableSeatsStepper.value
        
        let trip = Trip(nameDriver: nameDriver, from: fromWhere, to: toWhere, date: selectedDate, availableSeats: Int(availableSeats), phoneNumber: phoneNumber)

        presenter.addTrip(trip: trip)
    }
    
    @objc private func logoutButtonTapped() {
        presenter.signOut()
    }

    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        view.endEditing(true)
    }
}

extension CreateTripViewController: CreateTripViewProtocol {
    func showErrorAlert(_ error: Error) {
        AlertManager.errorAlert(self, error)
    }
    
    func showCreatingTripSuccessAlert() {
        AlertManager.tripCreationHadSuccessAlert(self)
        
        DispatchQueue.main.async {
            [weak self] in self?.clearTextFields()
        }
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

        cityPickerView.isHidden = false
        isShowingCityPicker = true
    }

    func hideCityPickerView() {
        cityPickerView.isHidden = true
        isShowingCityPicker = false
    }
}

extension CreateTripViewController: UITableViewDataSource, UITableViewDelegate {
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

extension CreateTripViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == fromWhereTextField || textField == toWhereTextField {
            presenter.showCityPicker(with: textField.text)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fromWhereTextField || textField == toWhereTextField {
            presenter.hideCityPicker()
        }
    }
}
