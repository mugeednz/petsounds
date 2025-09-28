//
//  PetTableViewCell.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//
protocol PetTableViewCellDelegate: AnyObject {
    func didSelectPet(_ pet: PetModel)
    func navigateToPremium()
}

import UIKit
import AVFoundation
class PetTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var petCollectionView: UICollectionView!
    var pets: [PetModel] = []
    var audioPlayer: AVAudioPlayer?
    weak var delegate: PetTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Ses dosyası bulunamadı: \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Ses çalınamadı: \(error)")
        }
    }
    // MARK: -CollectionView-
    func setCollectionView() {
        petCollectionView.dataSource = self
        petCollectionView.delegate = self
        petCollectionView.register(UINib(nibName: "PetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PetCollectionViewCell")
        petCollectionView.backgroundColor = .clear
    }
    func configurePets(with pets: [PetModel]) {
        self.pets = pets
        petCollectionView.reloadData()
    }
    
    //MARK: -UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout-
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
        let pet = pets[indexPath.row]
        cell.configurePets(with: pet)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 10 * 2
        let numberOfItemsPerRow: CGFloat = 3
        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPet = pets[indexPath.row]
        if selectedPet.soundType != .free && !GlobalHelper.isPremiumActive() {
            delegate?.navigateToPremium()
            return
        }
        delegate?.didSelectPet(selectedPet)
    }

    
}

