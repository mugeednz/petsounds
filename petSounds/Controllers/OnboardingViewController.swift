//
//  OnboardingViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func startButtonAction() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        GlobalHelper.pushController(id: "PethomeViewController", self) { vc in }
    }
    
}
