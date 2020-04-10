//
//  CurrencySelectionViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/9/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol CurrencySelectionDisplayLogic: class {
    func displayData(viewModel: CurrencySelection.Model.ViewModel.ViewModelData)
}

class CurrencySelectionViewController: UIViewController, CurrencySelectionDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: CurrencySelectionBusinessLogic?
    var router: (NSObjectProtocol & CurrencySelectionRoutingLogic)?
    
    var relatives: [RealmExchangeRate]!
    
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
        let interactor            = CurrencySelectionInteractor()
        let presenter             = CurrencySelectionPresenter()
        let router                = CurrencySelectionRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(R.nib.currencyPairTableViewCell)
        tableView.rowHeight = 44
        
        relatives = []
        
        interactor?.makeRequest(request: .loadRelatives)
    }
    
    func displayData(viewModel: CurrencySelection.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showRelatives(let relatives):
            self.relatives = relatives
            tableView.reloadData()
        }
    }
    
}

extension CurrencySelectionViewController: UITableViewDataSource {
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
        if relative.isSelected {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }
    
}

extension CurrencySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let relative = relatives[indexPath.row]
        interactor?.makeRequest(request: .addRelative(relative))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let relative = relatives[indexPath.row]
        interactor?.makeRequest(request: .removeRelative(relative))
    }
}
