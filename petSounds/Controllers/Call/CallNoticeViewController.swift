//
//  CallNoticeViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 8.02.2025.
//

import UIKit

class CallNoticeViewController: UIViewController {
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var textViewBigView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        labelDesign()
        textViewDesign()
        setupConstraints()
    }
    
    // MARK: - Design-
    func labelDesign() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = NSAttributedString(string: "notice".translate(), attributes: strokeTextAttributes)
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 36) ?? UIFont.systemFont(ofSize: 36, weight: .bold)
        ]
        buttonLabel.adjustsFontSizeToFitWidth = true
        buttonLabel.attributedText = NSAttributedString(string: "ok".translate(), attributes: buttonTextAttributes)
    }
    func setupConstraints() {
            guard let textViewBigView = textViewBigView else { return }
            
        textViewBigView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textViewBigView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
                textViewBigView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),

                textViewBigView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110),
                
                textViewBigView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            ])
        }

    func textViewDesign() {
        textView.text = "notice_message".translate()
        textView.font = .balooBold(ofSize: 18)
        textView.textColor = .black
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false

    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeNoteImage))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func closeNoteImage(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view)
        if !noteImage.frame.contains(touchPoint) {
            dismiss(animated: true)
        }
    }
    @IBAction func backButtonAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backButton.alpha = 1  
            self.view.bringSubviewToFront(self.backButton)
        }) { _ in
            self.dismiss(animated: true)
        }
    }



}
