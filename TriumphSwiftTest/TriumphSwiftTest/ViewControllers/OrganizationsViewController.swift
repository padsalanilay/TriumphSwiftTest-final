//
//  OrganizationsViewController.swift
//  TriumphSwiftTest
//
//  Created by Nilay Padsala on 9/10/21.
//

import UIKit
import SwiftSpinner

class OrganizationsViewController: UIViewController {

    var collectionView: UICollectionView!
    
    var organizations = [Organization]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.useContainerView(view)
        SwiftSpinner.show("Loading organizations.")

        constrainCollectionView()
        
        getOrganizationsList()
    }
    
    func constrainCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let spacing = layout.minimumInteritemSpacing + view.safeAreaInsets.right + view.safeAreaInsets.left + 20
        layout.itemSize = CGSize(width: (view.frame.width - spacing) / 2, height: 400)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        view.addSubview(collectionView)
        
        collectionView.register(OrganizationCollectionViewCell.self, forCellWithReuseIdentifier: "OrganizationCollectionViewCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.1404019296, green: 0.1568107307, blue: 0.162248373, alpha: 0.8031288804)
        
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Methods
    
    func getOrganizationsList() {
        Api.Organization.getOrganizations { [weak self] organizationsList in
            DispatchQueue.main.async {
                self?.organizations = organizationsList
                self?.collectionView.reloadData()
                
                SwiftSpinner.hide()
                SwiftSpinner.useContainerView(nil)

            }
        }
    }
}

extension OrganizationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        organizations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrganizationCollectionViewCell", for: indexPath) as! OrganizationCollectionViewCell
        cell.organization = organizations[indexPath.item]
        cell.delegate = self
        return cell
    }
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: 100, height: 50)
    }
}

extension OrganizationsViewController: DonationProtocol {
    func donate(to cell: OrganizationCollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        
        let organization = self.organizations[indexPath.item]
        
        let donationRequestMessage: String = "How much would like to donate to \(organization.name ?? "")?" 

        let alertSheet = UIAlertController(title: donationRequestMessage, message: nil, preferredStyle: .actionSheet)
        
        let donationAmounts = [1, 5, 10, 100]
        
        for amount in donationAmounts {
            let action = UIAlertAction(title: "$\(amount)", style: .default) { action in
                let title = action.title!
                
                
                if let amount = Double(title.replacingOccurrences(of: "$", with: "")), let donatedAmount = organization.amountGiven {
                    organization.amountGiven = donatedAmount + amount
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
            
            alertSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertSheet.addAction(cancelAction)
        
        self.present(alertSheet, animated: true)
    }
    

}
