
import UIKit

class TripResultsViewController: UIViewController {
    
    private let tableView = UITableView()
    var trips: [Trip]
    
    init(trips: [Trip]) {
        self.trips = trips
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) не был реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TripCell.self, forCellReuseIdentifier: "TripCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.reloadData()
    }
}

extension TripResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
        let trip = trips[indexPath.row]
        
        cell.titleLabel.text = "Имя: " + trip.nameDriver
        cell.fromLabel.text = "Откуда: " + trip.from
        cell.toLabel.text = "Куда: " + trip.to
        cell.dateLabel.text = "Дата: " + formatDate(trip.date)
        cell.availableSeatsLabel.text = "Кол-во мест: \(trip.availableSeats)"
        cell.phoneNumberLabel.text = "Телефон: " + trip.phoneNumber
        
        return cell
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
}
