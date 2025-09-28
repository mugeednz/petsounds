//
//  FinalTranslationViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 12.02.2025.
//

import UIKit

class FinalTranslationViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var petToHumanImageView: UIImageView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var petToHumanButton: UIButton!
    
    var selectedPet: String = "dog"
    var animalWords: [AnimalWords] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDesign()
        updatePetImage()
        loadAnimalWords()
//        translateButton.isHidden = true
    }
    
    // MARK: -Label Design-
    func labelDesign() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold)
        ]
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = NSAttributedString(string: "translation_done".translate(), attributes: strokeTextAttributes)
        
        let translationTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.translationStrokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        translationLabel.adjustsFontSizeToFitWidth = true
        translationLabel.attributedText = NSAttributedString(
            string: translationLabel.text ?? "",
            attributes: translationTextAttributes
        )
    }
    func updatePetImage() {
        if selectedPet == "cat" {
            centerImageView.image = UIImage(named: "bigCatChoices")
            petToHumanImageView.image = UIImage(named: "cattoHuman")
        } else {
            centerImageView.image = UIImage(named: "translate_dog")
            petToHumanImageView.image = UIImage(named: "dogtoHuman")
        }
    }
    func loadAnimalWords() {
        if let dogPath = Bundle.main.path(forResource: "dog_words", ofType: "json"),
           let catPath = Bundle.main.path(forResource: "cat_words", ofType: "json") {
            
            do {
                var animalWords: [AnimalWords] = []
                
                if selectedPet == "dog" {
                    let dogData = try Data(contentsOf: URL(fileURLWithPath: dogPath))
                    let decoder = JSONDecoder()
                    animalWords = try decoder.decode([AnimalWords].self, from: dogData)
                }
                else if selectedPet == "cat" {
                    let catData = try Data(contentsOf: URL(fileURLWithPath: catPath))
                    let decoder = JSONDecoder()
                    animalWords = try decoder.decode([AnimalWords].self, from: catData)
                }
                
                print(animalWords)
                
                if let randomWord = animalWords.randomElement() {
                    translationLabel.text = randomWord.meaning.translate()
                    print("JSON: \(translationLabel.text?.translate() ?? "")")
                } else {
                    translationLabel.text = "No matching word found"
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("One or both of the JSON files not found.")
        }
    }

    @IBAction func backButtonAction() {
        GlobalHelper.pushController(id: "PetChoicesViewController", self) { vc in}
    }
    @IBAction func petToHumanButtonAction() {
        GlobalHelper.pushController(id: "PetChoicesViewController", self) { vc in}
    }
    @IBAction func cleanButtonAction() {
        GlobalHelper.pushController(id: "PetChoicesViewController", self) { vc in}

    }
}
