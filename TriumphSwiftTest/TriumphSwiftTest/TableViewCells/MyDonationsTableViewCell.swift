import UIKit
import SDWebImage

class MyDonationsTableViewCell: UITableViewCell {
    
    // Views and labels
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var usernameLabel = UILabel()
    var moneyLabel = UILabel()
    let profileCircleSize = 43
    
    
    var donation: Donation? {
        didSet {
            let userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
            
            let dateString = self.getDateString(from: donation?.timestamp) ?? "--"
            self.usernameLabel.text = "\(userName) (\(dateString))"
            moneyLabel.text = "$\(donation?.amount ?? 0.0)"
            getOraganization(donation?.receiverId)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setConstraints() {
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: CGFloat(profileCircleSize)).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: CGFloat(profileCircleSize)).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = CGFloat(profileCircleSize/2)
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        usernameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        usernameLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
        
        contentView.addSubview(moneyLabel)
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        moneyLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: 0).isActive = true
        moneyLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        moneyLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        moneyLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        moneyLabel.text = ""
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setConstraints()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func getOraganization(_ orgID: String?) {
        guard let orgId = orgID else { return }
        
        Api.Organization.getOrganizationFromId(orgId: orgId) { [weak self] organization in
            DispatchQueue.main.async {
                self?.nameLabel.text = organization?.name
                self?.downloadImage(from: organization?.profilePhotoURL ?? "")
            }
        }
    }
    
    private func downloadImage(from urlString: String) {
        guard let imageUrl = URL(string: urlString) else { return }
        
        self.profileImageView.sd_setImage(with: imageUrl)
    }
    
    private func getDateString(from timeStamp: Double?) -> String?{
        guard let timeStamp = timeStamp else { return nil }
        
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
}

