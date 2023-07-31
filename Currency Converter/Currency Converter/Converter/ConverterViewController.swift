//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import Appodeal

protocol ConverterUpdateViewDelegate: AnyObject {
    func updateView()
}

protocol ConverterDisplayLogic: class {
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData)
}

class ConverterViewController: UIViewController, ConverterDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: ConverterBusinessLogic?
    var router: (ConverterRoutingLogic & ChoiceDataPassing)?
    
    private var horizontalConstraint: NSLayoutConstraint!
    private var verticalConstraint: NSLayoutConstraint!
    
    private var longPressGesture: UILongPressGestureRecognizer!
    private var gestureRecognizer: UITapGestureRecognizer!
    private var favoriteCurrencies: [FavoriteConverterViewModel]! {
        didSet {
            interactor?.makeRequest(request: .saveFavoriteOrder(currencies: favoriteCurrencies))
        }
    }

    private var exchangedCurrencies: ConverterViewModel!

    private let refreshControl = UIRefreshControl()
    private lazy var emptyStateView: UIView = {
        let frame = CGRect(x: tableView.center.x,
                           y: tableView.center.y,
                           width: tableView.bounds.size.width,
                           height: tableView.bounds.size.height)
        return EmptyState(frame: frame)
    }()
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        }
        else {
            return bottomLayoutGuide.topAnchor
        }
    }
    
    var safeArea: UILayoutGuide {
        if #available(iOS 11.0, *) { return view.safeAreaLayoutGuide}
        else { return view.layoutMarginsGuide }
    }
    
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
        setupView()
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor?.makeRequest(request: .firstLoad)
        interactor?.makeRequest(request: .loadConverterCurrencies)
        interactor?.makeRequest(request: .loadCryptoCurrencies)
        interactor?.makeRequest(request: .loadFavoriteCurrenciesFirst())
        let adsProductId = ConverterProducts.SwiftShopping
        if ConverterProducts.store.isProductPurchased(adsProductId) {
            Appodeal.hideBanner()
            return
        }
        Appodeal.showAd(
            .bannerBottom,
            forPlacement: "Banner",
            rootViewController: self
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.makeRequest(request: .saveFavoriteOrder(currencies: favoriteCurrencies))
        closeKeyboard()
    }

    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showConverterViewModel(let converterViewModel):
//            self.exchangedCurrencies = converterViewModel
            refreshControl.endRefreshing()
            // request updated favorite after changing of main currencies
            interactor?.makeRequest(request: .loadFavoriteCurrenciesFirst())
            
        case .showFavoriteViewModel(let favoriteViewModel):
            self.favoriteCurrencies = favoriteViewModel
            if !UserDefaultsService.shared.isFirstLoad {
                tableView.backgroundView = favoriteCurrencies.isEmpty ? emptyStateView : nil
            }
            tableView.reloadData()

        case .updateFavoriteViewModel(let favoriteViewModel, let indexPathes):
            self.favoriteCurrencies = favoriteViewModel
            if !UserDefaultsService.shared.isFirstLoad {
                tableView.backgroundView = favoriteCurrencies.isEmpty ? emptyStateView : nil
            }
            tableView.reloadRows(at: indexPathes, with: .none)
            indexPathes.forEach {
                tableView.deselectRow(at: $0, animated: true)
            }

        case .showError(let message):
            // dont show alert over top controller
            if let _ = presentedViewController { break }
            showAlert(with: message, title: R.string.localizable.error())
            
        case .firstLoadComplete:
            tableView.reloadData()
        }
    }
    
    // MARK: Private Methods
    // MARK: Router
    private func changeCurrencyTapped(exchangeView: ExchangeView) {
        router?.showChoiceViewController()
    }
    
    private func updateFavoriteWith(total: Double, index: Int) {
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: total, index: index))
    }
    
    // MARK: Alert
    private func showAlert(with message: String, title: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localizable.oK(),
                                     style: .default) { [weak self] _ in
                                        self?.refreshControl.endRefreshing()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Setup
    private func setupView() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(R.nib.converterCurrencyTableViewCellType2)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.allowsSelectionDuringEditing = true
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self,
                                 action: #selector(refreshCurrencies),
                                 for: .valueChanged)

        favoriteCurrencies = []

        setupNavBar()
        
        let adsProductId = ConverterProducts.SwiftShopping
        if !ConverterProducts.store.isProductPurchased(adsProductId) {
            Notify.showWith(title: R.string.localizable.firstLoadBunner(), duration: 1)
            
            if UserDefaultsService.shared.isFirstLoad {
                router?.showPurchaseViewController()
            }
            
            if ((UserDefaultsService.shared.purchaseViewShowCounter % 4) == 0) {
                router?.showPurchaseViewController()
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItems = [add]
    }
    
    @objc private func addTapped() {
        router?.showFavoriteViewController()
    }
  
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func refreshCurrencies(_ sender: Any) {
        let adsProductId = ConverterProducts.SwiftShopping
        if !ConverterProducts.store.isProductPurchased(adsProductId) &&
            (Date().timeIntervalSince1970 - UserDefaultsService.shared.lastUpdateTimeInteraval) < 3600 {
            self.refreshControl.endRefreshing()
            Notify.showWith(title: R.string.localizable.purchaseTitleBanner(), duration: 1)
            
            return
        }
        interactor?.makeRequest(request: .updateCurrencies)
        interactor?.makeRequest(request: .updateCrypto)
        interactor?.makeRequest(request: .loadFavoriteCurrencies())
    }
}

// MARK: - Themed
extension ConverterViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = .clear
        view.backgroundColor = theme.backgroundColor
        tableView.reloadData()
        navigationController?.navigationBar.update(backroundColor: theme.backgroundColor, titleColor: theme.textColor)
        tabBarController?.tabBar.backgroundColor = theme.barBackgroundColor
    }
}

// MARK: - ChoiceBackDataPassing
extension ConverterViewController: ChoiceBackDataPassing {
    func getRouter() -> ChoiceDataPassing {
        return router!
    }
    
    func updateControllerWithSelectedCurrency() {
    }
}

// MARK: - UITableViewDataSource
extension ConverterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.converterCurrencyTableViewCellType2,
                                                           for: indexPath) else { fatalError() }
        let viewModel = favoriteCurrencies[indexPath.row]
        cell.delegate = self
        cell.configure(with: viewModel)
        return cell
    }
    
    // Deleting
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: R.string.localizable.delete()) { (_, _, completionHandler) in
            tableView.beginUpdates()
            let currency = self.favoriteCurrencies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            self.interactor?.makeRequest(request: .remove(favorite: currency))
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModel = favoriteCurrencies[indexPath.row]
        if viewModel.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

// MARK: - UITableViewDelegate
extension ConverterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow,
           let currentCell = tableView.cellForRow(at: indexPath) as? ConverterCurrencyTableViewCellType2 {
            currentCell.countTextField.becomeFirstResponder()
        }
    }
    
    private func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currency = favoriteCurrencies.remove(at: sourceIndexPath.row)
        favoriteCurrencies.insert(currency, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ConverterViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - ConverterUpdateViewDelegate
extension ConverterViewController: ConverterUpdateViewDelegate {
    func updateView() {
        interactor?.makeRequest(request: .updateCurrencies)
    }
}

extension ConverterViewController: ConverterCurrencyTableViewCellType2Deleagte {
    func changeCurrencyTapped(exchangeView view: UITableViewCell, currencyName: Currency) {
        interactor?.makeRequest(request: .updateBaseCurrency(base: currencyName))
        view.setSelected(true, animated: true)
    }

    func convert(exchangeView sender: UITableViewCell, total: Double, index: Int) {
        updateFavoriteWith(total: total, index: index)
    }
}

