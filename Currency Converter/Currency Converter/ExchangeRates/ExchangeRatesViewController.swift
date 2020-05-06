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

class ExchangeRatesViewController: UIViewController, ExchangeRatesDisplayLogic {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var interactor: ExchangeRatesBusinessLogic?
    var router: (NSObjectProtocol & ExchangeRatesRoutingLogic)?
    
    private lazy var currencyRatesVC: CurrencyRatesViewController = {
        var viewController = CurrencyRatesViewController(nib: R.nib.currencyRatesViewController)
        add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var currencySelectionVC: CurrencySelectionViewController = {
        var viewController = CurrencySelectionViewController(nib: R.nib.currencySelectionViewController)
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
        setUpTheming()
    }
    
    func displayData(viewModel: ExchangeRates.Model.ViewModel.ViewModelData) {
        
    }
    
    // MARK: - Private Methods
    private func setupView() {
        setupSegmentedControl()
        updateView(selectedIndex: segmentedControl.selectedSegmentIndex)
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Курсы", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Выбор валют", at: 1, animated: false)
        segmentedControl.addTarget(self,
                                   action: #selector(selectionDidChange(_:)),
                                   for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white],
                                                for: .selected)
    }
    
    @objc private func selectionDidChange(_ sender: UISegmentedControl) {
        updateView(selectedIndex: sender.selectedSegmentIndex)
    }
    
    private func updateView(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            remove(asChildViewController: currencySelectionVC)
            add(asChildViewController: currencyRatesVC)
        case 1:
            remove(asChildViewController: currencyRatesVC)
            add(asChildViewController: currencySelectionVC)
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

extension ExchangeRatesViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor
        segmentedControl.backgroundColor = theme.backgroundColor
        segmentedControl.tintColor = theme.segmentedControlTintColor
        let normalColor = theme.segmentedControlTintColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: normalColor],
                                                for: .normal)
    }
}
