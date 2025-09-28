//
//  StartCallViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 7.02.2025.
//

import UIKit
import AVFoundation

class StartCallViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var startCallButton: UIButton!
    @IBOutlet weak var normalCallButton: UIButton!
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var centerImageView: UIView!
    
    var selectedCall: CallModel?
    var petsCircle: String?
    var petVideo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePage()
//        pageDesign()
        print("Long Sound:", selectedCall?.longSound ?? "Boş")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configurePage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    func configurePage() {
        titleLabel.text = selectedCall?.petName
        labelDesign()
        if let imageName = self.petsCircle {
            circleImage.image = UIImage(named: imageName)
        } else {
            print("ERROR: Image name is nil or empty")
            circleImage.image = UIImage(named: "defaultImageName")
        }
    }


    // MARK: - Design-
    func labelDesign() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        ]

        titleLabel.attributedText = NSAttributedString(
            string: titleLabel.text?.uppercased() ?? "",
            attributes: strokeTextAttributes
        )
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        buttonLabel.adjustsFontSizeToFitWidth = true
        buttonLabel.attributedText = NSAttributedString(string: "start_call".translate(), attributes: buttonTextAttributes)
        
        let clockTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -3.0,
            .font: UIFont(name: "Baloo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        clockLabel.adjustsFontSizeToFitWidth = true
        clockLabel.attributedText = NSAttributedString(string: "your_call_will_be_started_now".translate(), attributes: clockTextAttributes)
    }
//    func pageDesign() {
//        clockImage.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            clockImage.topAnchor.constraint(equalTo: circleImage.topAnchor, constant: 0)
//        ])
//    }

    // MARK: -Actions-
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func noticeButtonAction() {
        GlobalHelper.presentController(id: "CallNoticeViewController", from: self) { (vc: CallNoticeViewController) in
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
        }
    }
    
    @IBAction func normalCallButtonAction() {
        animateButton(normalCallButton)

        GlobalHelper.pushController(id: "IncomingCallViewController", self) { (vc: IncomingCallViewController) in
            vc.petName = self.selectedCall?.petName
            vc.circlePetImage = self.petsCircle
            vc.selectedCall = self.selectedCall
            vc.playRingtone()
        }
    }

    @IBAction func startButtonAction() {
        animateButton(startCallButton)
        GlobalHelper.pushController(id: "VideoCallViewController", self) { (vc: VideoCallViewController) in
            vc.selectedCall = selectedCall
        }
    }
    
    @IBAction func videoCallButtonAction() {
        animateButton(videoCallButton)
        GlobalHelper.pushController(id: "VideoCallViewController", self) { (vc: VideoCallViewController) in
            vc.selectedCall = selectedCall
        }
   }
    //MARK: - Button Animation -
    func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 6,
                       options: .allowUserInteraction,
                       animations: {
            button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                button.transform = .identity
            }
        }
    }
}
