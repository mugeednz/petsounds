//
//  PremiumViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 10.02.2025.
//

import UIKit
import RevenueCat

enum SelectedPremiumType: String {
    case weekly = "petify.weekly", monthly = "petify.monthly", yearly = "petify.yearly"
}

class PremiumViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var weekTitleLabel: UILabel!
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var yearTitleLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var selectionWeekImage: UIImageView!
    @IBOutlet weak var selectionMonthImage: UIImageView!
    @IBOutlet weak var selectionYearImage: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var premiumOptionsStackView: UIStackView!
    private var selectedProduct: SelectedPremiumType = .yearly

    var imageScrollView: UIScrollView!
    var imageStackView: UIStackView!
    var pageControl: UIPageControl!
    var autoScrollTimer: Timer?
    let premiumImagesArray = [
        "ic_firstPremium",
        "ic_secondPremium",
        "ic_thirtPremium",
        "ic_fourthPremium",
        "ic_fifthPremium",
        "ic_sixthPremium"
    ]
    
    var products: [StoreProduct] = [] {
          didSet {
              setupPrice()
          }
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        setPremiumProducts()
        setupScrollView()
        setupPageControl()
        updateSelection(for: nil)
        labelDesign()
        buttonDesign()
        updateSelection(for: yearButton)
        setupAutoScroll()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPageControl()
    }
    
    private func setPremiumProducts() {
        PremiumManager.shared.delegate = self
        fetchProducts()
    }
    
    private func fetchProducts() {
        PremiumManager.shared.showLoading(in: view)
        PremiumManager.shared.fetchProducts { [weak self] products, error in
            PremiumManager.shared.hideLoading()
            if let error = error {
                print("Failed to fetch products: \(error.localizedDescription)")
            } else if let products = products {
                self?.products = products
            }
        }
    }
    
    // MARK: - UI Setup -
    func labelDesign() {
        weekLabel.font = .balooRegular(ofSize: 20)
        weekLabel.textColor = .white
        monthLabel.font = .balooRegular(ofSize: 20)
        monthLabel.textColor = .white
        yearLabel.font = .balooRegular(ofSize: 20)
        yearLabel.textColor = .white
        
        weekTitleLabel.adjustsFontSizeToFitWidth = true
        weekTitleLabel.font = .balooRegular(ofSize: 20)
        weekTitleLabel.textColor = .weekLabelColor
        weekTitleLabel.text = "one_week".translate()

        monthTitleLabel.adjustsFontSizeToFitWidth = true
        monthTitleLabel.font = .balooRegular(ofSize: 20)
        monthTitleLabel.textColor = .monthLabelColor
        monthTitleLabel.text = "one_month".translate()

        yearTitleLabel.adjustsFontSizeToFitWidth = true
        yearTitleLabel.font = .balooRegular(ofSize: 20)
        yearTitleLabel.textColor = .yearLabelColor
        yearTitleLabel.text = "one_year".translate()

        
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        buttonLabel.attributedText = NSAttributedString(string: "continue_button".translate(), attributes: buttonTextAttributes)
        buttonLabel.adjustsFontSizeToFitWidth = true
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 36) ?? UIFont.systemFont(ofSize: 36, weight: .bold)
        ]
        
        titleLabel.attributedText = NSAttributedString(string: "premium_title".translate(), attributes: strokeTextAttributes)
    }
    
    func buttonDesign() {
        termsButton.titleLabel?.textAlignment = .left
        termsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        termsButton.setTitleColor(.white, for: .normal)
        termsButton.setTitle("terms".translate(), for: .normal)
        termsButton.titleLabel?.font = .baloo2Regular(ofSize: 14)

        restoreButton.titleLabel?.font = .baloo2Regular(ofSize: 20)
        restoreButton.titleLabel?.textAlignment = .center
        restoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        restoreButton.setTitleColor(.white, for: .normal)
        restoreButton.setTitle("restore".translate(), for: .normal)

        privacyButton.titleLabel?.textAlignment = .right
        privacyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        privacyButton.setTitleColor(.white, for: .normal)
        privacyButton.setTitle("privacy".translate(), for: .normal)
        privacyButton.titleLabel?.font = .baloo2Regular(ofSize: 14)
    }

    
    func updateSelection(for selectedButton: UIButton?) {
        selectionWeekImage.isHidden = selectedButton != weekButton
        selectionMonthImage.isHidden = selectedButton != monthButton
        selectionYearImage.isHidden = selectedButton != yearButton
    }
    //MARK: -Scroll View-
    func setupScrollView() {
        imageScrollView = UIScrollView()
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        view.addSubview(imageScrollView)
        
        imageStackView = UIStackView()
        imageStackView.axis = .horizontal
        imageStackView.distribution = .fillEqually
        imageStackView.spacing = 0
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.addSubview(imageStackView)
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: -20),
            imageScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: premiumOptionsStackView.topAnchor, constant: -20),

            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor)
        ])

        
        for imageName in premiumImagesArray {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageStackView.addArrangedSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: imageScrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor)
            ])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    func setupAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScrollImages), userInfo: nil, repeats: true)
    }
    @objc func autoScrollImages() {
        let nextPage = (pageControl.currentPage + 1) % premiumImagesArray.count
        let xOffset = CGFloat(nextPage) * imageScrollView.frame.width
        imageScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        
        if nextPage == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.imageScrollView.setContentOffset(.zero, animated: false)
            }
        }
    }
    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = premiumImagesArray.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let xOffset = CGFloat(sender.currentPage) * imageScrollView.frame.width
        imageScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    
    
    // MARK: - Actions-
    @IBAction func closeButtonAction() {
        dismiss(animated: true)
    }
    
    @IBAction func weekButtonAction() {
        selectedProduct = .weekly
        updateSelection(for: weekButton)
    }
    
    @IBAction func monthButtonAction() {
        selectedProduct = .monthly
        updateSelection(for: monthButton)
    }
    
    @IBAction func yearButtonAction() {
        selectedProduct = .yearly
        updateSelection(for: yearButton)
    }
    
    @IBAction func continueButtonAction() {
        if let index = products.firstIndex(where: { $0.productIdentifier == selectedProduct.rawValue }) {
            purchase(product: products[index])
        } else {
            purchase(product: StoreProduct(sk1Product: .init()))
        }
    }
    
    @IBAction func termsButtonAction() {
        GlobalHelper.openTerms(self)
    }
    
    @IBAction func restoreButtonAction() {
        PremiumManager.shared.restorePurchases { customerInfo, error in }
    }
    
    @IBAction func privacyButtonAction() {
        GlobalHelper.openPrivacy(self)
    }
    
    private func purchase(product: StoreProduct) {
       // PremiumManager.shared.showLoading(in: view)
        PremiumManager.shared.purchase(product: product) { customerInfo, error in
           // PremiumManager.shared.hideLoading()
                GlobalHelper.hideHud()
            if let error = error {
                print("Purchase failed: \(error.localizedDescription)")
            } else {
                print("Purchase successful: \(String(describing: customerInfo))")
            }
        }
    }
}

extension PremiumViewController: PurchaseDelegate {
    func didStartPurchase() {
        GlobalHelper.showHud(self)
        //PremiumManager.shared.showLoading(in: view)
    }
    
    func didShowPurchasePopup() {
        
    }
    
    func didDismissPurchasePopup() {
        GlobalHelper.hideHud()
        //PremiumManager.shared.hideLoading()
    }
    
    func didCompletePurchase(success: Bool, error: (any Error)?) {
        GlobalHelper.hideHud()
        //PremiumManager.shared.hideLoading()
        if success {
            closeButtonAction()
        } else {
//            showAlert(message: "Purchase failed: \(error?.localizedDescription ?? "")")
        }
    }
    
    func didRestorePurchases(success: Bool, error: (any Error)?) {
        GlobalHelper.hideHud()
        //PremiumManager.shared.hideLoading()
        if success {
            closeButtonAction()
        } else {
//            showAlert(message: "Restore failed: \(error?.localizedDescription ?? "")")
        }
    }
    
    private func setupPrice() {
        for product in products {
            if product.productIdentifier == SelectedPremiumType.yearly.rawValue {
                yearLabel.text = product.localizedPriceString
            } else if product.productIdentifier == SelectedPremiumType.monthly.rawValue {
                monthLabel.text = product.localizedPriceString
            } else if product.productIdentifier == SelectedPremiumType.weekly.rawValue {
                weekLabel.text = product.localizedPriceString
            }
        }
    }
    
    func didUpdateSubscriptionStatus(isPremium: Bool) {
    }
}
