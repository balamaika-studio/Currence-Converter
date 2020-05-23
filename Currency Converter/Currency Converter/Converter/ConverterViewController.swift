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
    var router: (ConverterRoutingLogic & ChoiceDataPassing)?
    
    private var rightBarButtonItem: UIBarButtonItem!
    private var longPressGesture: UILongPressGestureRecognizer!
    private var gestureRecognizer: UITapGestureRecognizer!
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
        setupView()
        setUpTheming()
    }
    
    @objc private func refreshCurrencies(_ sender: Any) {
        interactor?.makeRequest(request: .updateCurrencies)
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .loadConverterCurrencies)
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
    }
    
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showConverterViewModel(let converterViewModel):
            converterView.updateWith(converterViewModel)
            refreshControl.endRefreshing()
            // request updated favorite after changing of main currencies
            interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
            
        case .showFavoriteViewModel(let favoriteViewModel):
            self.favoriteCurrencies = favoriteViewModel
            tableView.backgroundView = favoriteCurrencies.isEmpty ? emptyStateView : nil
            tableView.reloadData()
            
        case .showError(let message):
            showAlert(with: message, title: R.string.localizable.error())
        }
    }
    
    // MARK: Private Methods
    // MARK: Router
    private func changeCurrencyTapped(exchangeView: ExchangeView) {
        router?.showChoiceViewController()
    }
    
    private func swapCurrencyTapped(baseCurrency: Currency) {
        interactor?.makeRequest(request: .updateBaseCurrency(base: baseCurrency))
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
        tableView.register(R.nib.converterCurrencyTableViewCell)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self,
                                 action: #selector(refreshCurrencies),
                                 for: .valueChanged)

        favoriteCurrencies = []
        converterView.changeCurrencyTapped = self.changeCurrencyTapped
        converterView.swapCurrencyTapped = self.swapCurrencyTapped
        converterView.topCurrencyTotal = self.updateFavoriteWith
        
        setupGestureRecognizer()
        rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                            target: self,
                                            action: #selector(reorder))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        longPressGesture = UILongPressGestureRecognizer(target: self,
                                                        action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5 // 0.5 second press
        longPressGesture.allowableMovement = 15
        self.tableView.addGestureRecognizer(longPressGesture)
    }

    // MARK: Handlers
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let currency = favoriteCurrencies[indexPath.row]
                interactor?.makeRequest(request: .changeBottomCurrency(with: currency))
            }
        }
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func reorder() {
        let isEditing = tableView.isEditing
        var tableDelagete: UITableViewDelegate?
        if isEditing {
            tableDelagete = nil
            rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                 target: self,
                                                 action: #selector(reorder))
        } else {
            tableDelagete = self
            rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                 target: self,
                                                 action: #selector(reorder))
        }
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                                  for: .normal)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        tableView.delegate = tableDelagete
        longPressGesture.isEnabled = !longPressGesture.isEnabled
        tableView.setEditing(!isEditing, animated: true)
    }
    
}

// MARK: - Themed
extension ConverterViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = .clear
        view.backgroundColor = theme.backgroundColor
        tableView.reloadData()
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                                  for: .normal)
    }
}

// MARK: - ChoiceBackDataPassing
extension ConverterViewController: ChoiceBackDataPassing {
    func getRouter() -> ChoiceDataPassing {
        return router!
    }
    
    func updateControllerWithSelectedCurrency() {
        let currencyName = converterView.replacingView.currencyName
        interactor?.makeRequest(request: .changeCurrency(name: currencyName))
    }
}

// MARK: - UITableViewDataSource
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
    
    // Moving Cells
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currency = favoriteCurrencies[sourceIndexPath.row]
        favoriteCurrencies.insert(currency, at: destinationIndexPath.row)
        favoriteCurrencies.remove(at: sourceIndexPath.row)
    }
    
    // Deleting
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            let currency = favoriteCurrencies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            interactor?.makeRequest(request: .remove(favorite: currency))
        default: return
        }
    }
}

// MARK: - UITableViewDelegate
extension ConverterViewController: UITableViewDelegate {
    // Disable the delete buttons
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ConverterViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
