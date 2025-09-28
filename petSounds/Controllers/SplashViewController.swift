//
//  SplashViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOnboardingStatus()
    }
    
    func checkOnboardingStatus() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            navigateToHome()
        } else {
            navigateToOnboarding()
        }
    }
    
    func navigateToHome() {
        GlobalHelper.pushController(id: "PethomeViewController", self) { vc in }
        
    }
    
    func navigateToOnboarding() {
        GlobalHelper.pushController(id: "OnboardingViewController", self) { vc in
            (vc as? PethomeViewController)?.navigationItem.hidesBackButton = true
        }

    }
}

