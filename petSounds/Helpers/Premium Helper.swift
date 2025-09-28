//
//  Premium Helper.swift
//  petSounds
//
//  Created by Müge Deniz on 26.02.2025.
//

import Foundation
import UIKit
import RevenueCat

protocol PurchaseDelegate: AnyObject {
    func didStartPurchase()
    func didShowPurchasePopup()
    func didDismissPurchasePopup()
    func didCompletePurchase(success: Bool, error: Error?)
    func didRestorePurchases(success: Bool, error: Error?)
    func didUpdateSubscriptionStatus(isPremium: Bool)
}

final class PremiumManager: NSObject {

    struct Constants {
        static let apiKey = "appl_IFkkIaSbJvSxuhcXFzvikIBMUHf"
        static let productIdentifiers = ["petify.weekly", "petify.monthly", "petify.yearly"]
    }

    private override init() {
        super.init()
        Purchases.configure(withAPIKey: Constants.apiKey)
        Purchases.shared.delegate = self
        updateSubscriptionStatus()
    }

    var availableProducts: [StoreProduct] = []
    weak var delegate: PurchaseDelegate?
    static let shared = PremiumManager()
    private let loadingView = LoadingView()
    private(set) var isPremium: Bool = false

    func updateSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            guard let self = self else { return }
            if let customerInfo = customerInfo {
                self.isPremium = !customerInfo.entitlements.active.isEmpty
            } else {
                self.isPremium = false
            }
            self.delegate?.didUpdateSubscriptionStatus(isPremium: self.isPremium)
        }
    }

    func fetchProducts(completion: @escaping ([StoreProduct]?, Error?) -> Void) {
        Purchases.shared.getProducts(Constants.productIdentifiers) { (products) in
            if !products.isEmpty {
                self.availableProducts = products
                completion(products, nil)
            } else {
                completion(nil, NSError(domain: "com.adilcan.petify", code: -1, userInfo: [NSLocalizedDescriptionKey: "No products found"]))
            }
        }
    }

    func purchase(product: StoreProduct, completion: @escaping (CustomerInfo?, Error?) -> Void) {
        delegate?.didStartPurchase()
        Purchases.shared.purchase(product: product) { [weak self] (transaction, customerInfo, error, userCancelled) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.didCompletePurchase(success: false, error: error)
                completion(nil, error)
            } else {
                self.updateSubscriptionStatus()
                self.delegate?.didCompletePurchase(success: true, error: nil)
                completion(customerInfo, nil)
            }
        }
    }

    func restorePurchases(completion: @escaping (CustomerInfo?, Error?) -> Void) {
        Purchases.shared.restorePurchases { [weak self] (customerInfo, error) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.didRestorePurchases(success: false, error: error)
                completion(customerInfo, error)
            } else if let customerInfo = customerInfo {
                self.updateSubscriptionStatus()
                self.delegate?.didRestorePurchases(success: !customerInfo.entitlements.active.isEmpty, error: nil)
                completion(customerInfo, nil)
            } else {
                self.delegate?.didRestorePurchases(success: false, error: nil)
            }
        }
    }

    func showLoading(in view: UIView) {
        DispatchQueue.main.async {
            self.loadingView.show(in: view)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView.hide()
        }
    }
}

private extension PremiumManager {
    final class LoadingView: UIView {
        
        private let activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.startAnimating()
            return indicator
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        private func setupView() {
            self.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.addSubview(activityIndicator)
            setupConstraints()
        }
        
        private func setupConstraints() {
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
        
        func show(in view: UIView) {
            self.frame = view.bounds
            view.addSubview(self)
        }
        
        func hide() {
            self.removeFromSuperview()
        }
    }
}

extension PremiumManager: PurchasesDelegate {
    
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        updateSubscriptionStatus()
    }
    
    func purchases(_ purchases: Purchases, readyForPromotedProduct product: StoreProduct, purchase makeDeferredPurchase: @escaping StartPurchaseBlock) {
        // Handle promotional product purchase
    }
}
