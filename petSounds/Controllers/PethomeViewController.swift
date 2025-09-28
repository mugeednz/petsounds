//
//  PethomeViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import UIKit

class PethomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PetTableViewCellDelegate {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var dogLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var petTableView: UITableView!
    @IBOutlet weak var whistleButton: UIButton!
    @IBOutlet weak var clickerButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var recordPageButton: UIButton!
    @IBOutlet weak var secondDogButton: UIButton!
    @IBOutlet weak var secondCatButton: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var pets: [PetModel] = []
    var isCatSelected = false
    var filteredPets: [PetModel] {
        return AppConfig.pets.filter { $0.petType == (isCatSelected ? .cat : .dog) }
    }
    let filledCircleImage = UIImage(named: "full_selection_circle")
    let emptyCircleImage = UIImage(named: "empty_selection_circle")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondDogButton.layer.zPosition = 1
        labelDesign()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        premiumButton.isHidden = GlobalHelper.isPremiumActive()
        petTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let cell = petTableView.visibleCells.first as? PetTableViewCell {
            cell.audioPlayer?.stop()
            cell.audioPlayer = nil
        }
        SoundManager.shared.stopAllSounds()
    }
    // MARK: -User Experience-
    
    func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func animateButtonPress(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    button.transform = CGAffineTransform.identity
                }
            }
        }
    }

    func updateFilteredPets() {
        self.petTableView.performBatchUpdates({
            self.petTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }, completion: nil)
    }

    // MARK: -TableView-
    func setTableView() {
        petTableView.dataSource = self
        petTableView.delegate = self
        petTableView.register(UINib(nibName: "PetTableViewCell", bundle: nil), forCellReuseIdentifier: "PetTableViewCell")
        petTableView.showsVerticalScrollIndicator = false
        petTableView.backgroundColor = .clear
        view.backgroundColor = .clear

    }
    func didSelectPet(_ pet: PetModel) {
        if pet.soundType == .free || GlobalHelper.isPremiumActive() {
            navigateToDetailView(with: pet)
        } else {
           navigateToPremium()
        }
    }
    func navigateToDetailView(with pet: PetModel) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.pet = pet
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    func navigateToPremium() {
        GlobalHelper.openSubs(vC: self)
    }
    
    // MARK: -Design-
    func labelDesign() {
        dogLabel.text = "Dogs"
        dogLabel.adjustsFontSizeToFitWidth = true
        dogLabel.font = .balooRegular(ofSize: 14)
        dogLabel.attributedText = NSAttributedString(string: "dogs".translate())
        dogLabel.textColor = .white
        catLabel.text = "Cats"
        catLabel.adjustsFontSizeToFitWidth = true
        catLabel.font = .balooRegular(ofSize: 14)
        catLabel.textColor = .white
        catLabel.attributedText = NSAttributedString(string: "cats".translate())
    }
    
    // MARK: -Actions-
    @IBAction func settingsButtonAction() {
        animateButtonPress(settingsButton)
        GlobalHelper.presentController(id: "SettingsViewController", from: self) { (vc: SettingsViewController) in
            vc.modalPresentationStyle = .fullScreen
        }
    }
    
    @IBAction func premiumButtonAction() {
        animateButtonPress(premiumButton)
        GlobalHelper.openSubs(vC: self)
    }
    
    @IBAction func catButtonAction() {
        if !isCatSelected {
            triggerHapticFeedback()
            animateButtonPress(catButton)
            UIView.transition(with: catButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.catButton.setImage(self.filledCircleImage, for: .normal)
                self.dogButton.setImage(self.emptyCircleImage, for: .normal)
               
            })
            isCatSelected = true
            petTableView.reloadData()
        }
    }
    
    @IBAction func dogButtonAction() {
        if isCatSelected {
            triggerHapticFeedback()
            animateButtonPress(dogButton)
            UIView.transition(with: dogButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.dogButton.setImage(self.filledCircleImage, for: .normal)
                self.catButton.setImage(self.emptyCircleImage, for: .normal)
            })
            isCatSelected = false
            petTableView.reloadData()
        }
    }
    @IBAction func secondCatButtonAction() {
        if !isCatSelected {
            triggerHapticFeedback()
            animateButtonPress(secondCatButton)

            UIView.transition(with: catButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.catButton.setImage(self.filledCircleImage, for: .normal)
                self.dogButton.setImage(self.emptyCircleImage, for: .normal)
               
            })
            isCatSelected = true
            petTableView.reloadData()
        }
    }
    
    @IBAction func secondDogButtonAction() {
        if isCatSelected {
            triggerHapticFeedback()
            animateButtonPress(secondDogButton)
            UIView.transition(with: dogButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.dogButton.setImage(self.filledCircleImage, for: .normal)
                self.catButton.setImage(self.emptyCircleImage, for: .normal)
            })
            isCatSelected = false
            petTableView.reloadData()
        }
        
    }
    
    @IBAction func whistleButtonAction() {
        animateButtonPress(whistleButton)
        GlobalHelper.presentController(id: "WhistleViewController", from: self) { (vc: WhistleViewController) in
            vc.modalPresentationStyle = .fullScreen
        }
    }
    
    @IBAction func clickerButtonAction() {
        animateButtonPress(clickerButton)
        GlobalHelper.presentController(id: "ClickerViewController", from: self) { (vc: ClickerViewController) in
            vc.modalPresentationStyle = .fullScreen
        }
    }
    
    @IBAction func callButtonAction() {
        animateButtonPress(callButton)
        GlobalHelper.pushController(id: "SellectPetViewController", self) { vc in }

    }
    @IBAction func recordPageButtonAction() {
        animateButtonPress(recordPageButton)
        GlobalHelper.pushController(id: "PetChoicesViewController", self) { vc in }
    }
    
    // MARK: -UITableViewDelegate, UITableViewDataSource-
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath) as! PetTableViewCell
        let pet = filteredPets[indexPath.row]
        cell.configurePets(with: filteredPets)
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 500
    }
    
}
