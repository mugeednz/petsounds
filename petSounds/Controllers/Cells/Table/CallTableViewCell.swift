//
//  CallTableViewCell.swift
//  petSounds
//
//  Created by Müge Deniz on 6.02.2025.
//
protocol CallTableViewCellDelegate: AnyObject {
    func didSelectCall(_ call: CallModel)
    func navigateToPremium()
}
import UIKit

class CallTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var petCallCollectionView: UICollectionView!
    var calls: [CallModel] = []
    weak var delegate: CallTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }

    func configureCall(with calls: [CallModel]) {
        self.calls = calls
        petCallCollectionView.reloadData()
    }
    
    
    // MARK: -CollectionView-
    func setCollectionView() {
        petCallCollectionView.dataSource = self
        petCallCollectionView.delegate = self
        petCallCollectionView.register(UINib(nibName: "PetCallsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PetCallsCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calls.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCallsCollectionViewCell", for: indexPath) as! PetCallsCollectionViewCell
        let calls = calls[indexPath.row]
        cell.configureCalls(with: calls)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let spacing: CGFloat = 10
        let numberOfColumns: CGFloat = 2
        let totalSpacing = (numberOfColumns - 1) * spacing
        let width = (collectionViewWidth - totalSpacing) / numberOfColumns

        let height: CGFloat = 210

        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedcall = calls[indexPath.row]
        if selectedcall.callType != .free && !GlobalHelper.isPremiumActive() {
            delegate?.navigateToPremium()
            return
        }
        delegate?.didSelectCall(selectedcall)
    }
}
