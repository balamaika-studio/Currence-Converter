//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import LongPressReorder

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
    
    private var reorderTableView: LongPressReorderTableView!
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
        interactor?.makeRequest(request: .loadConverterCurrencies)
        interactor?.makeRequest(request: .loadCryptoCurrencies)
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.makeRequest(request: .saveFavoriteOrder(currencies: favoriteCurrencies))
    }
    
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showConverterViewModel(let converterViewModel):
            self.exchangedCurrencies = converterViewModel
//            converterView.updateWith(converterViewModel)
            refreshControl.endRefreshing()
            // request updated favorite after changing of main currencies
            interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
            
        case .showFavoriteViewModel(let favoriteViewModel):
            self.favoriteCurrencies = favoriteViewModel
            tableView.backgroundView = favoriteCurrencies.isEmpty ? emptyStateView : nil
            tableView.reloadData()
            
        case .showError(let message):
            // dont show alert over top controller
            if let _ = presentedViewController { break }
            showAlert(with: message, title: R.string.localizable.error())
        }
    }
    
    // MARK: Private Methods
    // MARK: Router
    private func changeCurrencyTapped(exchangeView: ExchangeView) {
        router?.showChoiceViewController()
    }
    
    private func swapCurrencyTapped(converter model: ConverterViewModel) {
//        interactor?.makeRequest(request: .updateBaseCurrency(base: model.firstExchange))
//        interactor?.makeRequest(request: .changeBottomCurrency(with: model.secondExchange))
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
    }
    
    private func updateFavoriteWith(total: Double) {
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: total))
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
        
        tableView.register(R.nib.converterCurrencyTableViewCellType2)
        tableView.register(UINib(nibName: R.nib.type2SectionHeaderView.name, bundle: nil), forHeaderFooterViewReuseIdentifier: R.nib.type2SectionHeaderView.name)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        reorderTableView = LongPressReorderTableView(tableView,
                                                     scrollBehaviour: .late,
                                                     selectedRowScale: .big)
        reorderTableView.delegate = self
        reorderTableView.enableLongPressReorder()
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self,
                                 action: #selector(refreshCurrencies),
                                 for: .valueChanged)

        favoriteCurrencies = []
//        converterView.changeCurrencyTapped = self.changeCurrencyTapped
//        converterView.swapCurrencyTapped = self.swapCurrencyTapped
//        converterView.topCurrencyTotal = self.updateFavoriteWith

        setupNavBar()
    }
    
    private func setupNavBar() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        navigationItem.rightBarButtonItems = [add]
    }
    
    @objc private func addTapped() {
        router?.showFavoriteViewController()
    }
  
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func refreshCurrencies(_ sender: Any) {
        interactor?.makeRequest(request: .updateCurrencies)
        interactor?.makeRequest(request: .updateCrypto)
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
    }
}

// MARK: - Themed
extension ConverterViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = .clear
        view.backgroundColor = theme.backgroundColor
        tableView.reloadData()
    }
}

// MARK: - ChoiceBackDataPassing
extension ConverterViewController: ChoiceBackDataPassing {
    func getRouter() -> ChoiceDataPassing {
        return router!
    }
    
    func updateControllerWithSelectedCurrency() {
//        let currencyName = converterView.replacingView.currencyName
//        interactor?.makeRequest(request: .changeCurrency(name: currencyName))
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
        deleteAction.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.tableView.setSwipeActionFont(R.font.poppinsRegular(size: 15)!, withTintColor: .red)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Type2SectionHeaderView") as! Type2SectionHeaderView
        view.updateTitle(Date().toString())

        return view

    }
}

// MARK: - UITableViewDelegate
extension ConverterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = favoriteCurrencies[indexPath.row]
        interactor?.makeRequest(request: .changeBottomCurrency(with: currency))
    }
}

// MARK: - LongPressReorder Delegate
extension ConverterViewController {
    override func reorderFinished(initialIndex: IndexPath, finalIndex: IndexPath) {
        let currency = favoriteCurrencies.remove(at: initialIndex.row)
        favoriteCurrencies.insert(currency, at: finalIndex.row)
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
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
    }
}

extension ConverterViewController: ConverterCurrencyTableViewCellType2Deleagte {
    func changeCurrencyTapped(exchangeView view: UITableViewCell, currencyName: String) {
        interactor?.makeRequest(request: .changeCurrency(name: currencyName))
    }

    func convert(exchangeView sender: UITableViewCell, total: Double) {
        // MARK: - TODO
//        updateFavoriteWith(total: total)
    }
}
