//
//  SettingsTableViewCell.swift
//  petSounds
//
//  Created by Müge Deniz on 4.02.2025.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionIcon: UIImageView!
    @IBOutlet weak var settingsContainerView: UIView!

    private let leftIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemPink
        imageView.isHidden = true
        return imageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupLeftIcon()
    }

    func configure(option: String, icon: UIImage?) {
        optionLabel.text = option
        optionIcon.image = icon
        optionLabel.adjustsFontSizeToFitWidth = true
        if option == "get_premium".translate() {
            setupPremiumUI()
        } else {
            resetUI()
        }
    }
    
    private func setupPremiumUI() {
        optionLabel.textAlignment = .center
        optionLabel.font = .balooBold(ofSize: 20)
        optionLabel.textColor = .systemPink

        optionIcon.isHidden = false
        leftIconView.isHidden = false
        leftIconView.image = UIImage(named: "crown")

        optionIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionIcon.widthAnchor.constraint(equalToConstant: 30),
            optionIcon.heightAnchor.constraint(equalToConstant: 30)
        ])

        settingsContainerView.backgroundColor = UIColor(hex: "#FEE4E1")
        settingsContainerView.layer.borderWidth = 2
        settingsContainerView.layer.borderColor = UIColor.systemPink.cgColor
    }


    
    private func setupUI() {
        optionLabel.font = .balooBold(ofSize: 18)
        optionLabel.textColor = .strokeColor
        optionIcon.tintColor = .strokeColor
        optionLabel.textColor = .strokeColor
        optionLabel.textAlignment = .left
        settingsContainerView.layer.cornerRadius = 20
        settingsContainerView.layer.borderWidth = 2
        settingsContainerView.layer.borderColor = UIColor(hex: "CB5501").cgColor
        settingsContainerView.clipsToBounds = true
    }

    private func setupLeftIcon() {
        settingsContainerView.addSubview(leftIconView)
        leftIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftIconView.leadingAnchor.constraint(equalTo: settingsContainerView.leadingAnchor, constant: 10),
            leftIconView.centerYAnchor.constraint(equalTo: settingsContainerView.centerYAnchor),
            leftIconView.widthAnchor.constraint(equalToConstant: 20),
            leftIconView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func resetUI() {
        leftIconView.isHidden = true
        settingsContainerView.backgroundColor = .white
        settingsContainerView.layer.borderWidth = 2
        settingsContainerView.layer.borderColor = UIColor(hex: "CB5501").cgColor
        setupUI()
    }
}
