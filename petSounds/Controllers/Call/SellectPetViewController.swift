//
//  SellectPetViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 6.02.2025.
//

import UIKit

class SellectPetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CallTableViewCellDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var callTableView: UITableView!

    var calls: [CallModel] = []
    var isCatSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDesign()
        setTableView()
        updateFilteredCalls()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        callTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func updateFilteredCalls() {
        calls = AppConfig.calls

        DispatchQueue.main.async {
            self.callTableView.reloadData()
        }
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
        titleLabel.attributedText = NSAttributedString(string: "select_pet".translate(), attributes: strokeTextAttributes)
    }
    
        
    // MARK: -Actions-
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    func didSelectCall(_ call: CallModel) {
        if call.callType == .free || GlobalHelper.isPremiumActive()  {
            navigateToCallView(with: call)
        } else {
         navigateToPremium()
        }
    }
    
    func navigateToPremium() {
        GlobalHelper.openSubs(vC: self)
    }
    
    func navigateToCallView(with call: CallModel) {
        if let callVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartCallViewController") as? StartCallViewController {
            callVC.selectedCall = call
            callVC.petsCircle = call.circleImage
            callVC.petVideo = call.callVideo
            navigationController?.pushViewController(callVC, animated: true)
        }
    }

    // MARK: -TableView-
    func setTableView() {
        callTableView.dataSource = self
        callTableView.delegate = self
        callTableView.register(UINib(nibName: "CallTableViewCell", bundle: nil), forCellReuseIdentifier: "CallTableViewCell")
        callTableView.showsVerticalScrollIndicator = false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallTableViewCell", for: indexPath) as! CallTableViewCell
        cell.configureCall(with: calls)
        cell.delegate = self 
        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
}
