//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import LongPressReorder
import RxDataSources
import RxCocoa
import RxSwift

//protocol ConverterDisplayLogic: class {
//    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData)
//}


final class ConverterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var converterView: ConverterView!
    
    //var interactor: ConverterBusinessLogic?
    //var router: (ConverterRoutingLogic & ChoiceDataPassing)?
    
    //private var horizontalConstraint: NSLayoutConstraint!
    //private var verticalConstraint: NSLayoutConstraint!
    
    //private var reorderTableView: LongPressReorderTableView!
    private var actionButton: JJFloatingActionButton!
    //private var longPressGesture: UILongPressGestureRecognizer!
    //private var gestureRecognizer: UITapGestureRecognizer!
    private let viewModel = ConverterViewModel()
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, AnyConverterCellModel>>(configureCell: { _, table, indexPath, item in
        let cell = table.dequeueReusableCell(withIdentifier: "converterCurrencyTableViewCell", for: indexPath)
        if let cell = cell as? ConverterCurrencyTableViewCell {
            cell.configure(with: item)
        }
        return cell
    }, titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model
    }, canEditRowAtIndexPath: { _, _ in true }
    )
    private let refreshControl = UIRefreshControl()
    private lazy var emptyStateView: UIView = {
        let frame = CGRect(x: tableView.center.x,
                           y: tableView.center.y,
                           width: tableView.bounds.size.width,
                           height: tableView.bounds.size.height)
        return EmptyState(frame: frame)
    }()
    private let disposeBag = DisposeBag()
//    var safeBottomAnchor: NSLayoutYAxisAnchor {
//        view.safeAreaLayoutGuide.bottomAnchor
//    }
//
//    var safeArea: UILayoutGuide {
//        view.safeAreaLayoutGuide
//    }
//
//    // MARK: Object lifecycle
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        //setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        //setup()
//    }
    
//    // MARK: Setup
//
//    private func setup() {
//        let viewController        = self
//        let interactor            = ConverterInteractor()
//        let presenter             = ConverterPresenter()
//        let router                = ConverterRouter()
//        viewController.interactor = interactor
//        viewController.router     = router
//        interactor.presenter      = presenter
//        presenter.viewController  = viewController
//        router.viewController     = viewController
//        router.dataStore          = interactor
//    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpTheming()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //interactor?.makeRequest(request: .loadConverterCurrencies)
//        interactor?.makeRequest(request: .loadFavoriteCurrencies)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        //interactor?.makeRequest(request: .saveFavoriteOrder(currencies: favoriteCurrencies))
//    }
//
//    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData) {
//        switch viewModel {
//        case .updateLocalFavoriteCurrencies(let baseCount):
//            (0 ..< favoriteCurrencies.count).forEach {
//                let total = favoriteCurrencies[$0].rate * baseCount
//                favoriteCurrencies[$0].total = AccuracyManager.shared.formatNumber(total)
//            }
//            tableView.reloadData()
//        case .showConverterViewModel://(let converterViewModel):
//            //converterView.updateWith(converterViewModel)
//            refreshControl.endRefreshing()
//            // request updated favorite after changing of main currencies
//            interactor?.makeRequest(request: .loadFavoriteCurrencies)
//
//        case .showFavoriteViewModel(let favoriteViewModel):
//            refreshControl.endRefreshing()
//            self.favoriteCurrencies = favoriteViewModel
//            interactor?.makeRequest(request: .saveFavoriteOrder(currencies: favoriteCurrencies))
//            tableView.backgroundView = favoriteCurrencies.isEmpty ? emptyStateView : nil
//            tableView.reloadData()
//
//        case .showError(let message):
//            refreshControl.endRefreshing()
//            // dont show alert over top controller
//            if let _ = presentedViewController { break }
//            showAlert(with: message, title: R.string.localizable.error())
//        }
//    }
    
    // MARK: Private Methods
    // MARK: Router
//    private func changeCurrencyTapped(exchangeView: ExchangeView) {
//        router?.showChoiceViewController()
//    }
//
//    private func swapCurrencyTapped(converter model: ConverterViewModel) {
//        interactor?.makeRequest(request: .updateBaseCurrency(base: model.firstExchange))
//        interactor?.makeRequest(request: .changeBottomCurrency(with: model.secondExchange))
//        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: nil))
//    }
//
//    private func updateFavoriteWith(total: Double) {
//        interactor?.makeRequest(request: .loadFavoriteCurrencies(total: total))
//    }

    private func addUpdateTimeLabel(_ attrString: NSAttributedString?) -> UILabel {
        let fullString = NSMutableAttributedString(attributedString: attrString ?? NSAttributedString())

        let whiteSpace = NSAttributedString(string: "  ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "ic_update.pdf")
        if let image = image1Attachment.image {
            image1Attachment.bounds = CGRect(x: 0, y: -2, width: image.size.width, height: image.size.height).integral
        }
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(whiteSpace)
        fullString.append(image1String)

        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 170, height: 20))
        label.backgroundColor = .clear
        label.attributedText = fullString
        label.textColor = #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)
        label.font = R.font.poppinsRegular(size: 15)

        return label
    }

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let _ = tableView.indexPathForRow(at: touchPoint) {
                tableView.isEditing = !tableView.isEditing
            }
        }
    }
    
    // MARK: Alert
    private func showAlert(with message: String, title: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localizable.oK(),
                                     style: .default) { _ in }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Setup
    private func setupView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        tableView.register(ConverterCurrencyTableViewCell.self, forCellReuseIdentifier: "converterCurrencyTableViewCell")
        viewModel.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
//        viewModel.items.drive(tableView.rx.items(cellIdentifier: "converterCurrencyTableViewCell", cellType: ConverterCurrencyTableViewCell.self)) { index, model, cell in
//            cell.configure(with: model)
//        }
        _ = tableView.rx.delegate.methodInvoked(#selector(tableView.delegate?.tableView(_:willDisplayHeaderView:forSection:)))
            .take(until:tableView.rx.deallocated)
            .subscribe(onNext: { [weak self] event in
                guard let headerView = event[1] as? UITableViewHeaderFooterView else { return }

                for view in headerView.subviews {
                    view.backgroundColor = .clear
                }

                let label = self?.addUpdateTimeLabel(headerView.textLabel?.attributedText)
                if let subviews = headerView.textLabel?.subviews {
                    for labelView in subviews {
                        labelView.removeFromSuperview()
                    }
                }
                headerView.textLabel?.attributedText = NSAttributedString()
                if let label = label {
                    headerView.textLabel?.addSubview(label)
                }
            })
        _ = tableView.rx.delegate.methodInvoked(#selector(tableView.delegate?.tableView(_:willBeginEditingRowAt:)))
            .take(until:tableView.rx.deallocated)
            .subscribe(onNext: { [weak self] event in
                self?.tableView.setSwipeActionFont(R.font.poppinsRegular(size: 15)!, withTintColor: .red)
            })
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.separatorStyle = .none
//        tableView.delegate = self
        tableView.refreshControl = refreshControl

        tableView.rx.itemMoved
            .subscribe(onNext: { indexPaths in
                print(indexPaths)
                self.viewModel.service.set(
                    position: indexPaths.destinationIndex.row,
                    ofCurrency: self.viewModel.service.getFavouriteCurrency()[indexPaths.sourceIndex.row]
                )
            }).disposed(by:disposeBag)
//        reorderTableView = LongPressReorderTableView(tableView,
//                                                     scrollBehaviour: .late,
//                                                     selectedRowScale: .big)
//        reorderTableView.delegate = self
//        reorderTableView.enableLongPressReorder()
        
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.onFetcheFavoriteCurrencies)
            .disposed(by: disposeBag)
        viewModel.activityIndicator
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        //favoriteCurrencies = []
        //converterView.changeCurrencyTapped = self.changeCurrencyTapped
        //converterView.swapCurrencyTapped = self.swapCurrencyTapped
        //converterView.topCurrencyTotal = self.updateFavoriteWith
        
        addFAB()
    }

    private func addFAB() {
        actionButton = JJFloatingActionButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: 31).isActive = true
        let bottomInset = AdBannerInsetService.shared.bannerHeight + 8
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor,
                                            constant: bottomInset).isActive = true
        
        //horizontalConstraint.isActive = true
        //verticalConstraint.isActive = true
        
        actionButton.handleSingleActionDirectly = true
        actionButton.buttonDiameter = 56
        actionButton.buttonColor = #colorLiteral(red: 0.3882352941, green: 0.5450980392, blue: 0.9882352941, alpha: 1)

        // shadow
        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: actionButton.buttonDiameter / 10)
        actionButton.layer.shadowOpacity = 0.3
        actionButton.layer.shadowRadius = 8
        
        // action handler
//        actionButton.addItem(title: nil, image: nil) { [weak self] _ in
//            guard let self = self else { return }
//            self.router?.showFavoriteViewController()
//        }
    }
  
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
//    @objc private func refreshCurrencies(_ sender: Any) {
//        interactor?.makeRequest(request: .updateCurrencies)
//        interactor?.makeRequest(request: .loadFavoriteCurrencies)
//    }
    
//    // MARK: - LongPressReorder Delegate
//    override func reorderFinished(initialIndex: IndexPath, finalIndex: IndexPath) {
//        let currency = favoriteCurrencies.remove(at: initialIndex.row)
//        favoriteCurrencies.insert(currency, at: finalIndex.row)
//    }
}

// MARK: - Themed
extension ConverterViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = .clear
        view.backgroundColor = theme.backgroundColor
        tableView.reloadData()
    }
}

//// MARK: - ChoiceBackDataPassing
//extension ConverterViewController: ChoiceBackDataPassing {
//    func getRouter() -> ChoiceDataPassing {
//        return router!
//    }
//
//    func updateControllerWithSelectedCurrency() {
//        //let currencyName = converterView.replacingView.currencyName
//        //interactor?.makeRequest(request: .changeCurrency(name: currencyName))
//    }
//}

// MARK: - UITableViewDataSource
//extension ConverterViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return favoriteCurrencies.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "converterCurrencyTableViewCell", for: indexPath) as? ConverterCurrencyTableViewCell else { fatalError() }
//        let viewModel = favoriteCurrencies[indexPath.row]
//        cell.configure(with: viewModel)
//        return cell
//    }
//
//    // Deleting
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete:
//            tableView.beginUpdates()
//            let currency = favoriteCurrencies.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .left)
//            tableView.endUpdates()
//            interactor?.makeRequest(request: .remove(favorite: currency))
//        default: return
//        }
//    }
//}

// MARK: - UITableViewDelegate
extension ConverterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let currency = favoriteCurrencies[indexPath.row]
        //interactor?.makeRequest(request: .changeBottomCurrency(with: currency))
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: R.string.localizable.delete()) { (_, _, completionHandler) in
            self.viewModel.service.remove(position: indexPath.row)
            self.viewModel.service.fetcheFavoriteCurrencies()
            completionHandler(true)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9803921569, blue: 1, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ConverterViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
