//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterDisplayLogic: class {
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData)
}

class ConverterViewController: UIViewController, ConverterDisplayLogic {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var converterView: ConverterView!
    
    
    var interactor: ConverterBusinessLogic?
    var router: (ConverterRoutingLogic & ConverterDataPassing)?
    
    private var favoriteCurrencies: [FavoriteConverterViewModel]!
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var emptyStateView: UIView = {
        let frame = CGRect(x: tableView.center.x,
                           y: tableView.center.y,
                           width: tableView.bounds.size.width,
                           height: tableView.bounds.size.height)
        return EmptyState(frame: frame)
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
        let interactor            = ConverterInteractor()
        let presenter             = ConverterPresenter()
        let router                = ConverterRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore          = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.converterCurrencyTableViewCell)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor : UIColor.black,
            .foregroundColor : UIColor.white,
            .strokeWidth : -2.0,
            .font : UIFont.boldSystemFont(ofSize: 18)
        ]
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...",
                                                            attributes: strokeTextAttributes)

        refreshControl.addTarget(self,
                                 action: #selector(refreshCurrencies),
                                 for: .valueChanged)

        
        converterView.changeCurrencyTapped = self.didTap
        converterView.swapCurrencyTapped = self.swapCurrencyTapped
        
        favoriteCurrencies = []
        
        interactor?.makeRequest(request: .loadConverterCurrencies)
    }
    
    @objc private func refreshCurrencies(_ sender: Any) {
        interactor?.makeRequest(request: .updateCurrencies)
        interactor?.makeRequest(request: .loadFavoriteCurrencies)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .loadFavoriteCurrencies)
    }
    
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showConverterViewModel(let converterViewModel):
            converterView.justUpdate(converterViewModel)
            refreshControl.endRefreshing()
            
        case .showFavoriteViewModel(let favoriteViewModel):
            self.favoriteCurrencies = favoriteViewModel
            tableView.backgroundView = favoriteCurrencies.isEmpty ? emptyStateView : nil
            tableView.reloadData()
        }
    }
    
    func updateConverter() {
        let currencyName = converterView.replacingView.currencyName
        interactor?.makeRequest(request: .changeCurrency(name: currencyName))
    }
    
    // MARK: Private Methods
    func didTap(exchangeView: ExchangeView) {
        router?.showChoiceViewController()
    }
    
    func swapCurrencyTapped(baseCurrency: Currency) {
        interactor?.makeRequest(request: .updateBaseCurrency(base: baseCurrency))
        interactor?.makeRequest(request: .loadFavoriteCurrencies)
    }
}

extension ConverterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.converterCurrencyTableViewCell,
                                                           for: indexPath) else { fatalError() }
        
        let viewModel = favoriteCurrencies[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
}

extension ConverterViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class HalfSizePresentationController : UIPresentationController {
    var shadowView: UIView?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2,
                      width: containerView.bounds.width,
                      height: containerView.bounds.height / 2)
    }
    
    override func presentationTransitionWillBegin() {
        shadowView = UIView(frame: presentingViewController.view.frame)
        shadowView?.backgroundColor = .black
        shadowView?.layer.opacity = 0.3
        presentingViewController.view.addSubview(shadowView!)
    }
    
    override func dismissalTransitionWillBegin() {
        shadowView?.removeFromSuperview()
    }
}
