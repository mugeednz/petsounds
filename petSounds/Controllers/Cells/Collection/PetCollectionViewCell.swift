//
//  PetCollectionViewCell.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!

    func configurePets(with pet: PetModel) {
        statusImage.isHidden = GlobalHelper.isPremiumActive()
        statusImage.image = pet.soundsStatusIcon
        
          switch pet.petType {
          case .cat:
              petImage.image = UIImage(named: pet.imageName)
          case .dog:
              petImage.image = UIImage(named: pet.imageName)
          }
      }
}
