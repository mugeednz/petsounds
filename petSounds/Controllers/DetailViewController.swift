//
//  DetailViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 4.02.2025.
//

import UIKit
import AVFAudio
class DetailViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var circleImage: UIImageView!
    var pet: PetModel?
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        labelDesign()
        imageDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: -Design-
    func updateUI() {
        guard let pet = pet else {return}
        circleImage.image = UIImage(named: pet.circleImage)
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
        titleLabel.attributedText = NSAttributedString(string: "detail_title".translate(), attributes: strokeTextAttributes)
        
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        buttonLabel.adjustsFontSizeToFitWidth = true
        buttonLabel.attributedText = NSAttributedString(string: "tap_to_play_sound".translate(), attributes: buttonTextAttributes)
    }
    func imageDesign() {
        guard let superview = circleImage.superview else { return }
        
        circleImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circleImage.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 30),
            circleImage.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -30),
            circleImage.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            circleImage.heightAnchor.constraint(equalToConstant: 120),
            circleImage.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
    }

    // MARK: -Actions-
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButtonAction() {
        guard let pet = pet else { return }
        playSound(named: pet.soundName)
    }
    
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Ses çalınamadı: \(error)")
        }
    }
}
