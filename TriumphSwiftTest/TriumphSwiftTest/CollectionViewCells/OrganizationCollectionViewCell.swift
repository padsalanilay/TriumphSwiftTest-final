//
//  OrganizationCollectionViewCell.swift
//  TriumphSwiftTest
//
//  Created by Nilay Padsala on 9/10/21.
//

import UIKit
protocol DonationProtocol: AnyObject {
    func donate(to cell: OrganizationCollectionViewCell)
}

class OrganizationCollectionViewCell: UICollectionViewCell {
    var organization: Organization? {
        didSet {
            self.downloadImage(from: organization?.profilePhotoURL ?? "")
            self.nameLabel.text = organization?.name
            self.totalAmountLabel.text = "Donation received: \(organization?.amountGiven ?? 0.0)"
        }
    }
    
    weak var delegate: DonationProtocol?
    
    // MARK: UI components
    var organizationImageView = UIImageView()
    var nameLabel = UILabel()
    var totalAmountLabel = UILabel()
    var donateButton = UIButton()
    
    // UI Size constants
    let imageViewHeight = 200
    let donateButtonHeight = 50
    let donateButtonWidth = 100
    
    // ui message and string
    let donateButtonTitle = "Donate"

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setConstraints() {
        contentView.addSubview(organizationImageView)
        organizationImageView.translatesAutoresizingMaskIntoConstraints = false
        organizationImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        organizationImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        organizationImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        organizationImageView.heightAnchor.constraint(equalToConstant: CGFloat(imageViewHeight)).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: organizationImageView.bottomAnchor, constant: 5).isActive = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        contentView.addSubview(totalAmountLabel)
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAmountLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        totalAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        totalAmountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        
        totalAmountLabel.numberOfLines = 0
        totalAmountLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        contentView.addSubview(donateButton)
        donateButton.translatesAutoresizingMaskIntoConstraints = false
        donateButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        donateButton.heightAnchor.constraint(equalToConstant: CGFloat(donateButtonHeight)).isActive = true
        donateButton.widthAnchor.constraint(equalToConstant: CGFloat(donateButtonWidth)).isActive = true
        donateButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        donateButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        donateButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        donateButton.setTitle(donateButtonTitle, for: .normal)
        donateButton.layer.cornerRadius = CGFloat(donateButtonHeight / 2)
        donateButton.addTarget(self, action: #selector(donateButtonClicked), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentView.clipsToBounds = true
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func downloadImage(from urlString: String) {
        guard let imageUrl = URL(string: urlString) else { return }
        
        self.organizationImageView.sd_setImage(with: imageUrl)
    }
    
    @objc private func donateButtonClicked() {
        delegate?.donate(to: self)
    }
}
