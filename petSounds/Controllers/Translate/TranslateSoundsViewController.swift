//
//  TranslateSoundsViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 13.02.2025.
//

import UIKit
import AVFoundation

class TranslateSoundsViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    var selectedPet: String = "dog"
    var audioPlayer: AVAudioPlayer?
    var isAudioPlaying = false
    var lastPlayedSound: String?
    var dogSounds: [String] = ["joyful_dog", "so_happy_dog", "come_here_dog", "lets_play_dog", "sixthDog", "seventhDog"]
    var catSounds: [String] = ["first", "fourth", "cat-1", "eighth", "second", "cat-2", "cat-3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        updatePetImage()
        labelDesign()
    }

    // MARK: - Label Design
    func labelDesign() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        buttonLabel.adjustsFontSizeToFitWidth = true
        buttonLabel.attributedText = NSAttributedString(string: "tap_to_play_sound".translate(), attributes: strokeTextAttributes)
    }

    func updatePetImage() {
        if selectedPet == "cat" {
            petImageView.image = UIImage(named: "ic_translate_cat_circle")
            playRandomSound(from: catSounds)
        } else {
            petImageView.image = UIImage(named: "ic_translate_dog_circle")
            playRandomSound(from: dogSounds)
        }
    }

    func playRandomSound(from sounds: [String]) {
        let randomIndex = Int.random(in: 0..<sounds.count)
        lastPlayedSound = sounds[randomIndex]
        playSound(named: lastPlayedSound!)
    }

    func playSound(named soundName: String) {
        let fileExtensions = ["mp3", "wav"]
        var filePath: String?
        
        for ext in fileExtensions {
            if let path = Bundle.main.path(forResource: soundName, ofType: ext) {
                filePath = path
                break
            }
        }
        guard let path = filePath else {
            print("Sound file not found: \(soundName)")
            return
        }

        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isAudioPlaying = true
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSound()
    }

    func stopSound() {
        audioPlayer?.pause()
        audioPlayer = nil
        isAudioPlaying = false
    }

    // MARK: - Actions
    @IBAction func backButtonAction() {
        if let navigationController = navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count >= 3 {
                let targetViewController = viewControllers[viewControllers.count - 3]
                navigationController.popToViewController(targetViewController, animated: true)
            } else {
                print("Stack'te 2 sayfa geri gitmek için yeterli view controller yok.")
            }
        }

    }

    @IBAction func finishButtonAction() {
        if !isAudioPlaying, let soundName = lastPlayedSound {
            playSound(named: soundName)
        }
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isAudioPlaying = false
    }
}
