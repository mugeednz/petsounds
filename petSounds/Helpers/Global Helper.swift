//
//  Global Helper.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import Foundation
import UIKit
import SafariServices
import StoreKit

final class GlobalHelper {
    static let shared = GlobalHelper()
    
    static func isPremiumActive() -> Bool {
        var isPremiumActive: Bool = false
        isPremiumActive = PremiumManager.shared.isPremium
        return isPremiumActive
    }
    
    static func pushController<VC: UIViewController>(isAnimatedActive: Bool = true, id: String,_ vC: UIViewController, setup: (_ vc: VC) -> ()) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? VC {
            setup(vc)
            vC.navigationController?.pushViewController(vc, animated: isAnimatedActive)
        }
    }
    
    static func presentController<VC: UIViewController>(id: String, from vC: UIViewController, setup: (_ vc: VC) -> ()) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? VC {
            setup(vc)
            vC.present(vc, animated: true, completion: nil)
        }
    }
    
    static func openSubs(vC: UIViewController) {
        if let premiumVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumViewController") as? PremiumViewController {
            premiumVC.modalPresentationStyle = .fullScreen
            vC.present(premiumVC, animated: true)
        }
    }
    
    static func openPrivacy(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "https://sites.google.com/view/petify-privacy/ana-sayfa")
    }
    
    static func openTerms(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "https://sites.google.com/view/petify-eula/ana-sayfa")
    }
    
    static func openContact(_ vc: UIViewController) {
        openLinkInSafari(vc, url: "https://sites.google.com/view/captionai/support")
    }
    
    static func openLinkInSafari(_ vc: UIViewController, url: String) {
        guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        svc.overrideUserInterfaceStyle = .dark
        vc.present(svc, animated: true, completion: nil)
    }
    
    static func rateApp() {
        SKStoreReviewController.requestReview()
    }
}

import JGProgressHUD
extension GlobalHelper {
    static var HUD: JGProgressHUD!
    
    static func showHud(_ vc: UIViewController, title: String = "Loading".translate(), type: Int? = 0) {
        if type == 0 {
            GlobalHelper.HUD = JGProgressHUD(style: .dark)
        } else {
            GlobalHelper.HUD = JGProgressHUD(style: .light)
        }
        GlobalHelper.HUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        GlobalHelper.HUD.animation = JGProgressHUDFadeZoomAnimation()
        GlobalHelper.HUD.textLabel.text = title
        GlobalHelper.HUD.show(in: vc.view)
    }
    
    static func hideHud() {
        GlobalHelper.HUD.progress = 0.0
        GlobalHelper.HUD.dismiss()
    }
}
