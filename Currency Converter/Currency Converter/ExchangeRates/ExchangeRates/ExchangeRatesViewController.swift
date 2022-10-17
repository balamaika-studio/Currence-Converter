//
//  ExchangeRatesViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ExchangeRatesDisplayLogic: class {
    func displayData(viewModel: ExchangeRates.Model.ViewModel.ViewModelData)
}

protocol ExchangeRatesDelegate: AnyObject {
    func setSelectedCurrency(model: FavoriteViewModel)
    func getTopCurrencyModels() -> (Relative?, Bool)
    func applySelectedCurrencies(exchangeType: ExchangeType)
}

class ExchangeRatesViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topCurrenciesView: ExchangeCurrenciesViews!
    @IBOutlet weak var navbarView: UIView!

    var interactor: ExchangeRatesBusinessLogic?
    var router: (NSObjectProtocol & ExchangeRatesRoutingLogic)?
    weak var delegate: CurrencyRatesDelegate?
    private var relativeCur: Relative = Relative(
        base: "USD",
        relative: "EUR",
        isSelected: false
    )

    private var relativeCryptoCur: Relative = Relative(
        base: "BTC",
        relative: "ETH",
        isSelected: false
    )
    private var isLeftSelected = true
    
    private lazy var cryptoCurrencyRatesVC: FavoriteCryptocurrencyViewController = {
        var viewController = FavoriteCryptocurrencyViewController(nib: R.nib.favoriteCryptocurrencyViewController)
        viewController.delegate = self
        add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var currencySelectionVC: FavoriteCurrencyViewController = {
        var viewController = FavoriteCurrencyViewController(nib: R.nib.favoriteCurrencyViewController)
        viewController.delegate = self
        add(asChildViewController: viewController)
        return viewController
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = ExchangeRatesInteractor()
        let presenter             = ExchangeRatesPresenter()
        let router                = ExchangeRatesRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.makeRequest(request: .configureExchangeRates)
        setupView()
        setupMainView()
        setUpTheming()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        DispatchQueue.main.async {
            self.setupSegmentedControl()
            self.updateView(selectedIndex: self.segmentedControl.selectedSegmentIndex)
        }
        topCurrenciesView.configureView()
        topCurrenciesView.delegate = self
    }

    private func setupMainView() {
        mainView.layer.cornerRadius = 14
        mainView.clipsToBounds = true
        titleLabel.text =  R.string.localizable.addPair()
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: R.string.localizable.favouriteCurrencySegmentTitle(),
                                       at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: R.string.localizable.favouriteCryptocurrencySegmentTitle(),
                                       at: 1, animated: false)
        segmentedControl.addTarget(self,
                                   action: #selector(selectionDidChange(_:)),
                                   for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white],
                                                for: .selected)
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        segmentedControl.setClearBackgroundSegmentControl()
    }
    
    @objc private func selectionDidChange(_ sender: UISegmentedControl) {
        updateView(selectedIndex: sender.selectedSegmentIndex)
    }
    
    private func updateView(selectedIndex: Int) {

        switch selectedIndex {
        case 0:
            remove(asChildViewController: cryptoCurrencyRatesVC)
            add(asChildViewController: currencySelectionVC)
            DispatchQueue.main.async {
                self.currencySelectionVC.loadData()
            }

        case 1:
            remove(asChildViewController: currencySelectionVC)
            add(asChildViewController: cryptoCurrencyRatesVC)
            DispatchQueue.main.async {
                self.cryptoCurrencyRatesVC.loadData()
            }

        default:
            break
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
}

// MARK: - Themed
extension ExchangeRatesViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        titleLabel.textColor = .white
        navbarView.backgroundColor = theme.barBackgroundColor
        mainView.backgroundColor = theme.backgroundColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: theme.textColor],
                                                for: .normal)
    }
}

// MARK: - ExchangeRatesDelegate
extension ExchangeRatesViewController: ExchangeRatesDelegate {

    public func setSelectedCurrency(model: FavoriteViewModel) {
        topCurrenciesView.setCurrency(viewModel: model)
    }

    public func getTopCurrencyModels() -> (Relative?, Bool) {
        return (topCurrenciesView.getCurrencies(), isLeftSelected)
    }

    public func applySelectedCurrencies(exchangeType: ExchangeType) {
        if let relative = topCurrenciesView.getCurrencies() {
            interactor?.makeRequest(request: .saveSelectedExchangeRates(relative))
            switch exchangeType {
            case .crypto:
                relativeCryptoCur = relative
            case .forex:
                relativeCur = relative
            }
            delegate?.reloadData()
        }
    }
}

extension ExchangeRatesViewController: ExchangeCurrenciesViewsDelegate {
    func itemDidChange(isLeftSelected: Bool) {
        self.isLeftSelected = isLeftSelected
        updateView(selectedIndex:  segmentedControl.selectedSegmentIndex)
    }
}
