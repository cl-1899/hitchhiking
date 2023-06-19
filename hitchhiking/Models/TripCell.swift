import UIKit

class TripCell: UITableViewCell {
    let titleLabel = UILabel()
    let fromLabel = UILabel()
    let toLabel = UILabel()
    let dateLabel = UILabel()
    let availableSeatsLabel = UILabel()
    let phoneNumberLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        fromLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        toLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        availableSeatsLabel.font = UIFont.systemFont(ofSize: 15.0)
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(fromLabel)
        contentView.addSubview(toLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(availableSeatsLabel)
        contentView.addSubview(phoneNumberLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        availableSeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            
            fromLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            fromLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            
            toLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 4.0),
            toLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            
            dateLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 4.0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            
            availableSeatsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4.0),
            availableSeatsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: availableSeatsLabel.bottomAnchor, constant: 4.0),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            phoneNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }
}
