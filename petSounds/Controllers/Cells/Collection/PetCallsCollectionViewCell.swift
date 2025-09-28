//
//  PetCallsCollectionViewCell.swift
//  petSounds
//
//  Created by Müge Deniz on 6.02.2025.
//

import UIKit

class PetCallsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configureCalls(with calls: CallModel) {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .strokeWidth: -3.0,
            .font: UIFont(name: "Baloo-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
        let attributedString = NSAttributedString(string: calls.petName, attributes: strokeTextAttributes)
        petNameLabel.attributedText = attributedString
        petNameLabel.adjustsFontSizeToFitWidth = true
        petImage.image = UIImage(named: calls.imageName)
        
        statusImage.isHidden = GlobalHelper.isPremiumActive()
        statusImage.image = calls.callStatusIcon
    }

    
}
