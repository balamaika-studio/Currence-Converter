//
//  CurrencyRatesViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import LongPressReorder

protocol CurrencyRatesDisplayLogic: class {
    func displayData(viewModel: CurrencyRates.Model.ViewModel.ViewModelData)
}

protocol CurrencyRatesDelegate: AnyObject {
    func reloadData()
}

class CurrencyRatesViewController: UIViewController, CurrencyRatesDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: CurrencyRatesBusinessLogic?
    var router: (NSObjectProtocol & CurrencyRatesRoutingLogic)?

    private var reorderTableView: LongPressReorderTableView!
    private var longPressGesture: UILongPressGestureRecognizer!
    private var gestureRecognizer: UITapGestureRecognizer!
    var relatives: [CurrencyPairViewModel]!
    private let refreshControl = UIRefreshControl()
    
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
        let interactor            = CurrencyRatesInteractor()
        let presenter             = CurrencyRatesPresenter()
        let router                = CurrencyRatesRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.makeRequest(request: .loadCurrencyRateChanges)
    }
    
    func displayData(viewModel: CurrencyRates.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showCurrencyRatesViewModel(let relatives):
            self.relatives = relatives
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.currencyPairTableViewCell)
        tableView.register(UINib(nibName: R.nib.type2SectionHeaderView.name, bundle: nil), forHeaderFooterViewReuseIdentifier: R.nib.type2SectionHeaderView.name)

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
        
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 50
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInset = AdBannerInsetService.shared.tableInset
        relatives = []
    }

    private func setupNavBar() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        navigationItem.rightBarButtonItems = [add]
    }

    @objc private func refreshCurrencies(_ sender: Any) {
        interactor?.makeRequest(request: .loadCurrencyRateChanges)
    }

    @objc private func addTapped() {
        router?.showExchangeRatesViewController()
    }
}

extension CurrencyRatesViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tabBarController?.tabBar.backgroundColor = theme.barBackgroundColor
        tableView.backgroundColor = .clear
        view.backgroundColor = theme.backgroundColor
        tableView.reloadData()
    }
}

extension CurrencyRatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = R.reuseIdentifier.currencyPairTableViewCell
        guard let
            cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) else {
                fatalError()
        }
        
        let relative = relatives[indexPath.row]
        cell.configure(with: relative)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: R.string.localizable.delete()) { (_, _, completionHandler) in
            tableView.beginUpdates()
            let relative = self.relatives.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            self.interactor?.makeRequest(request: .removeRelative(relative))
            completionHandler(true)
        }
        deleteAction.backgroundColor = view.backgroundColor
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

extension CurrencyRatesViewController: UITableViewDelegate {}

extension CurrencyRatesViewController: CurrencyRatesDelegate {
    public func reloadData() {
        interactor?.makeRequest(request: .loadCurrencyRateChanges)
    }
}

// MARK: - LongPressReorder Delegate
extension CurrencyRatesViewController {
    override func reorderFinished(initialIndex: IndexPath, finalIndex: IndexPath) {
        let currency = relatives.remove(at: initialIndex.row)
        relatives.insert(currency, at: finalIndex.row)
    }
}
