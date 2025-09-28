//
//  PetChoicesViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 11.02.2025.
//

import UIKit

class PetChoicesViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var dogLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var petStackView: UIStackView!
    @IBOutlet weak var topImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDesign()
       // pageDesign()
    }

    // MARK: -Design-
    func labelDesign() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center

        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -3.0,
            .font: UIFont(name: "Baloo-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold),
            .paragraphStyle: paragraphStyle
        ]
        dogLabel.adjustsFontSizeToFitWidth = true
        dogLabel.attributedText = NSAttributedString(
            string: "dog_translation".translate(),
            attributes: strokeTextAttributes
        )
        catLabel.adjustsFontSizeToFitWidth = true
        catLabel.attributedText = NSAttributedString(
            string: "cat_translation".translate(),
            attributes: strokeTextAttributes
        )
        
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold)
        ]
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = NSAttributedString(string: "choose_to_translate".translate(), attributes: titleTextAttributes)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
    }
    func pageDesign() {
        petStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            petStackView.topAnchor.constraint(greaterThanOrEqualTo: topImage.bottomAnchor, constant: 10),
            petStackView.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: view.bounds.height * 0.05),
            petStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * 0),
        ])
    }

    
    // MARK: -Actions-
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func catButtonAction() {
        GlobalHelper.pushController(id: "HumanToDogViewController", self) { vc in
            (vc as? HumanToDogViewController)?.selectedPet = "cat"
        }
    }

    @IBAction func dogButtonAction() {
        GlobalHelper.pushController(id: "HumanToDogViewController", self) { vc in
            (vc as? HumanToDogViewController)?.selectedPet = "dog"
        }
    }

}
