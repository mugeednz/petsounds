//
//  SettingsViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 4.02.2025.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    let settingsOptions: [(String, UIImage?)] = [
        ("get_premium".translate(), UIImage(named: "crown")),
        ("privacy_policy".translate(), UIImage(systemName: "chevron.right")),
        ("terms_of_services".translate(), UIImage(systemName: "chevron.right")),
        ("help_and_support".translate(), UIImage(systemName: "chevron.right")),
        ("rate_us".translate(), UIImage(systemName: "chevron.right"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.showsHorizontalScrollIndicator = false
        settingsTableView.separatorStyle = .none
        setTableView()
        labelDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        settingsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    // MARK: -Label Design-
    func labelDesign() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold)
        ]
        
        titleLabel.attributedText = NSAttributedString(string: "settings_title".translate(), attributes: strokeTextAttributes)
    }
    
    @IBAction func backButtonAction() {
        dismiss(animated: true)
    }
    
    // MARK: -TableView-
    func setTableView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        settingsTableView.showsVerticalScrollIndicator = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        cell.selectionStyle = .none
        let option = settingsOptions[indexPath.row]
        cell.configure(option: option.0, icon: option.1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            GlobalHelper.openSubs(vC: self)
        case 1:
            GlobalHelper.openPrivacy(self)
        case 2:
            GlobalHelper.openTerms(self)
        case 3:
            GlobalHelper.openContact(self)
        case 4:
            GlobalHelper.rateApp()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && GlobalHelper.isPremiumActive() {
            return 0
        }
        return 62
    }
}
