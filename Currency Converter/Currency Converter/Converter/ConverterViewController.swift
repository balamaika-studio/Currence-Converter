//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import GoogleMobileAds

protocol ConverterDisplayLogic: class {
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData)
}

class ConverterViewController: UIViewController, ConverterDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var converterView: ConverterView!
    
    var interactor: ConverterBusinessLogic?
    var router: (ConverterRoutingLogic & ChoiceDataPassing)?
    
    private var horizontalConstraint: NSLayoutConstraint!
    private var verticalConstraint: NSLayoutConstraint!
    
    private var actionButton: JJFloatingActionButton!
    private var longPressGesture: UILongPressGestureRecognizer!
    private var gestureRecognizer: UITapGestureRecognizer!
    private var favoriteCurrencies: [FavoriteConverterViewModel]! {
        didSet {
            interactor?.makeRequest(request: .saveFavoriteOrder(currencies: favoriteCurrencies))
        }
    }
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
        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.makeRequest(request: .saveFavoriteOrder(currencies: favoriteCurrencies))
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.contentInset = AdBannerInsetService.shared.tableInset
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self,
                                 action: #selector(refreshCurrencies),
                                 for: .valueChanged)

        favoriteCurrencies = []
        converterView.changeCurrencyTapped = self.changeCurrencyTapped
        converterView.swapCurrencyTapped = self.swapCurrencyTapped
        converterView.topCurrencyTotal = self.updateFavoriteWith
        
        setupGestureRecognizer()
        addFAB()
    }
    
    private func addFAB() {
        actionButton = JJFloatingActionButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        horizontalConstraint = safeArea.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: 31)
        let bottomInset = AdBannerInsetService.shared.bannerHeight + 8
        verticalConstraint = safeBottomAnchor.constraint(equalTo: actionButton.bottomAnchor,
                                                         constant: bottomInset)
        
        horizontalConstraint.isActive = true
        verticalConstraint.isActive = true
        
        actionButton.handleSingleActionDirectly = true
        actionButton.buttonDiameter = 56
        actionButton.buttonColor = #colorLiteral(red: 0.3882352941, green: 0.5450980392, blue: 0.9882352941, alpha: 1)

        // shadow
        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: actionButton.buttonDiameter / 10)
        actionButton.layer.shadowOpacity = 0.3
        actionButton.layer.shadowRadius = 8
        
        // action handler
        actionButton.addItem(title: nil, image: nil) { [weak self] _ in
            guard let self = self else { return }
            self.router?.showFavoriteViewController()
        }
    }
    
    private func setupGestureRecognizer() {
        let longpress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longpress)
    }

    // MARK: Handlers
    @objc private func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: locationInView),
            let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            Path.initialIndexPath = indexPath
            CellInfo.cellSnapshot = CellInfo.snapshotOfCell(cell)
            var center = cell.center
            CellInfo.cellSnapshot!.center = center
            CellInfo.cellSnapshot!.alpha = 0.0
            tableView.addSubview(CellInfo.cellSnapshot!)
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center.y = locationInView.y
                CellInfo.cellIsAnimating = true
                CellInfo.cellSnapshot!.center = center
                CellInfo.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                CellInfo.cellSnapshot!.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { finished in
                if finished {
                    CellInfo.cellIsAnimating = false
                    if CellInfo.cellNeedToShow {
                        CellInfo.cellNeedToShow = false
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            cell.alpha = 1
                        })
                    } else {
                        cell.isHidden = true
                    }
                }
            })
            
        case UIGestureRecognizerState.changed:
            if CellInfo.cellSnapshot != nil {
                var center = CellInfo.cellSnapshot!.center
                center.y = locationInView.y
                CellInfo.cellSnapshot!.center = center
                if indexPath != Path.initialIndexPath {
                    let a = favoriteCurrencies.remove(at: Path.initialIndexPath!.row)
                    favoriteCurrencies.insert(a, at: indexPath.row)
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!)
                if CellInfo.cellIsAnimating {
                    CellInfo.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    CellInfo.cellSnapshot!.center = (cell?.center)!
                    CellInfo.cellSnapshot!.transform = CGAffineTransform.identity
                    CellInfo.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        CellInfo.cellSnapshot!.removeFromSuperview()
                        CellInfo.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func refreshCurrencies(_ sender: Any) {
        interactor?.makeRequest(request: .updateCurrencies)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = favoriteCurrencies[indexPath.row]
        interactor?.makeRequest(request: .changeBottomCurrency(with: currency))
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ConverterViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
