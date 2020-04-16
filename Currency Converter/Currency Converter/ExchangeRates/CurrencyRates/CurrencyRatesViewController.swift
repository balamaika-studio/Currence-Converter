//
//  CurrencyRatesViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencyRatesDisplayLogic: class {
    func displayData(viewModel: CurrencyRates.Model.ViewModel.ViewModelData)
}

class CurrencyRatesViewController: UIViewController, CurrencyRatesDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: CurrencyRatesBusinessLogic?
    var router: (NSObjectProtocol & CurrencyRatesRoutingLogic)?
    
    var relatives: [CurrencyPairViewModel]!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.makeRequest(request: .loadCurrencyRateChanges)
    }
    
    func displayData(viewModel: CurrencyRates.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showCurrencyRatesViewModel(let relatives):
            self.relatives = relatives
            tableView.reloadData()
        }
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.register(R.nib.currencyPairTableViewCell)
        tableView.register(ExchangeRatesHeader.self,
                           forHeaderFooterViewReuseIdentifier: ExchangeRatesHeader.reuseId)
        
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 50
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        relatives = []
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
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let id = ExchangeRatesHeader.reuseId
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: id)
    }
}
