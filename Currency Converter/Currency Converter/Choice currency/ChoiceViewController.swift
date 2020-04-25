//
//  ChoiceViewController.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ChoiceDisplayLogic: class {
    func displayData(viewModel: Choice.Model.ViewModel.ViewModelData)
}

class ChoiceViewController: UIViewController, ChoiceDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var interactor: ChoiceBusinessLogic?
    var router: ChoiceRoutingLogic?
    
    var isShowGraphCurrencies = false
    private var currencies: [ChoiceCurrencyViewModel]!
    
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
        let interactor            = ChoiceInteractor()
        let presenter             = ChoicePresenter()
        let router                = ChoiceRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore          = interactor
    }
    
    // MARK: Routing
    @IBAction func doneTapped(_ sender: UIButton) {
        router?.closeChoiceViewController()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .loadCurrencies(forGraph: isShowGraphCurrencies))
    }
    
    func displayData(viewModel: Choice.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayCurrencies(let currencies):
            self.currencies = currencies
            self.tableView.reloadData()
        }
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(R.nib.choiceCurrencyTableViewCell)
        tableView.separatorStyle = .none
        currencies = []
    }
    
}

extension ChoiceViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.specificBackgroundColor
        tableView.reloadData()
    }
}

extension ChoiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.choiceCurrencyTableViewCell,
                                                       for: indexPath) else { fatalError() }
        
        let viewModel = currencies[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
}

extension ChoiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedViewModel = currencies[indexPath.row]
        interactor?.makeRequest(request: .chooseCurrency(viewModel: selectedViewModel))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
