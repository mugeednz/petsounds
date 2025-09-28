//
//  TranslateViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 12.02.2025.
//

import UIKit

class TranslateViewController: UIViewController {
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var wholePetImageView: UIImageView!
    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerView: UIView!
    var selectedPet: String = "dog"
    var selectedHuman = true

    override func viewDidLoad() {
        super.viewDidLoad()
        labelDesign()
        updatePetImage()
        navigateToFinalViewController()
        pageDesign()
    }
    
    // MARK: -Design
    func labelDesign() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        processingLabel.attributedText = NSAttributedString(
            string: "processing".translate(),
            attributes: strokeTextAttributes
        )
        let translationTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = NSAttributedString(string:"translate_title".translate(), attributes: translationTextAttributes)
    }
    
    func pageDesign() {
        centerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    // MARK: - Pet -
    func updatePetImage() {
        if selectedPet == "cat" {
            wholePetImageView.image = UIImage(named: "wholeCat")
        } else {
            wholePetImageView.image = UIImage(named: "wholeDog")
        }
    }
    
    private func navigateToFinalViewController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if self.selectedHuman {
                GlobalHelper.pushController(id: "TranslateSoundsViewController", self) { vc in
                    if let soundsVC = vc as? TranslateSoundsViewController {
                        soundsVC.selectedPet = self.selectedPet
                    }
                }
            } else {
                if self.selectedPet == "dog" || self.selectedPet == "cat" {
                    GlobalHelper.pushController(id: "FinalTranslationViewController", self) { vc in
                        if let finalVC = vc as? FinalTranslationViewController {
                            finalVC.selectedPet = self.selectedPet
                        }
                    }
                }
            }
        }
    }
}
