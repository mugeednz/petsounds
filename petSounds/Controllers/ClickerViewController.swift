//
//  ClickerViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 5.02.2025.
//

import UIKit
import AVFoundation

class ClickerViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var imageView: UIView!
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        labelDesign()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        clickButton.addGestureRecognizer(longPressGesture)
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
        titleLabel.attributedText = NSAttributedString(string: "clicker_title".translate(), attributes: strokeTextAttributes)
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        buttonLabel.adjustsFontSizeToFitWidth = true
        buttonLabel.attributedText = NSAttributedString(string: "tap_to_play_sound".translate(), attributes: buttonTextAttributes)
        let imageTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.white,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo2-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        imageLabel.adjustsFontSizeToFitWidth = true
        imageLabel.attributedText = NSAttributedString(string: "clicker".translate(), attributes: imageTextAttributes)
    }

    
    // MARK: -Actions-
    @IBAction func backButtonAction() {
        dismiss(animated: true)
    }
    
    @IBAction func noticeButtonAction() {
        GlobalHelper.presentController(id: "NoticeViewController", from: self) { (vc: NoticeViewController) in
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
        }
    }
    @IBAction func clickButtonAction() {
        playSound()
    }
    @IBAction func playButtonAction() {
        playSound()
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            playSound()
        case .ended, .cancelled:
            stopSound()
        default:
            break
        }
    }
    
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "clickSound", withExtension: "wav") else {
            print("Ses dosyası bulunamadı!")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Ses çalınamadı: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
