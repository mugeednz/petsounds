//
//  IncomingCallViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 7.02.2025.
//

import UIKit
import AVFoundation
import AudioToolbox

class IncomingCallViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var incomingCallLabel: UILabel!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var answerCallButton: UIButton!
    @IBOutlet weak var declineCallButton: UIButton!
    
    var calls: [CallModel] = []
    var selectedCall: CallModel?
    var audioPlayer: AVAudioPlayer?
    var petName: String?
    var circlePetImage: String?
    var callVideo: String?
    var callTimer: Timer?
    var callDuration = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        labelDesign()
        if let firstCall = calls.first {
            configurePage(with: firstCall)
        } else {
            configurePageWithDefaults()
        }
        print("IncomingCallViewController - Long Sound:", selectedCall?.longSound ?? "Boş")
        playRingtone()
    }

    func playRingtone() {
        guard let soundURL = Bundle.main.url(forResource: "iphone", withExtension: "mp3") else {
            print("Zil sesi bulunamadı!")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Ses çalınırken hata oluştu: \(error.localizedDescription)")
        }
    }

    func stopRingtone() {
        audioPlayer?.stop()
    }
    
    func playLongSound() {
        stopRingtone()
        
        guard let soundFile = selectedCall?.longSound, let soundURL = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else {
            print("Uzun ses dosyası bulunamadı!")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Uzun ses çalınırken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    func startCallTimer() {
        callDuration = 0
        callTimer?.invalidate()
        callTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCallDuration), userInfo: nil, repeats: true)
    }

    @objc func updateCallDuration() {
        callDuration += 1
        let minutes = callDuration / 60
        let seconds = callDuration % 60
        incomingCallLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    func configurePage(with call: CallModel) {
        titleLabel.text = call.petName.uppercased()
        labelDesign()
        
        if let image = UIImage(named: call.circleImage) {
            circleImage.image = image
        } else {
            print("Resim yüklenemedi! Hata veren isim: \(call.circleImage)")
        }
    }

    func configurePageWithDefaults() {
        if let petName = petName {
            titleLabel.text = petName.uppercased()
            labelDesign()
        } else {
            print("Pet ismi mevcut değil!")
        }
        
        if let circlePetImage = circlePetImage, let image = UIImage(named: circlePetImage) {
            circleImage.image = image
        } else {
            print("Varsayılan resim yüklenemedi! Hata veren isim: \(circlePetImage ?? "Boş")")
            circleImage.image = UIImage(named: "default_image")
        }
    }

    // MARK: -Design-
    func labelDesign() {
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = NSAttributedString(
            string: titleLabel.text?.uppercased() ?? "",
            attributes: titleTextAttributes
        )
        let incomingCallTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        incomingCallLabel.adjustsFontSizeToFitWidth = true
        incomingCallLabel.attributedText = NSAttributedString(
            string: "is_incoming_call".translate(),
            attributes: incomingCallTextAttributes
        )
    }
//    func pageDesign() {
//        circleImage.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//
//            circleImage.topAnchor.constraint(equalTo: incomingCallLabel.topAnchor, constant: 40),
//            circleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            circleImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//            circleImage.heightAnchor.constraint(equalTo: circleImage.widthAnchor)
//        ])
//    }
    // MARK: -Actions-
    @IBAction func answerCallButtonAction() {
        if let call = selectedCall?.longSound  {
            playLongSound()
        }
        startCallTimer()
        
        answerCallButton.isHidden = true
        declineCallButton.translatesAutoresizingMaskIntoConstraints = false
        if let superview = declineCallButton.superview {
            NSLayoutConstraint.activate([
                declineCallButton.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                declineCallButton.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -40)
            ])
        }
    }

    @IBAction func declineCallButtonAction() {
        stopRingtone()
        audioPlayer?.stop()
        callTimer?.invalidate()
        navigationController?.popViewController(animated: true)
    }
}
