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
    
    var interactor: ChoiceBusinessLogic?
    var router: ChoiceRoutingLogic?
    
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
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(R.nib.choiceCurrencyTableViewCell)
        tableView.separatorStyle = .none
    }
    
    func displayData(viewModel: Choice.Model.ViewModel.ViewModelData) {
        
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        router?.closeChoiceViewController()
    }
    
    
}


extension ChoiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.choiceCurrencyTableViewCell,
                                                       for: indexPath) else { fatalError() }
        
        return cell
    }
}

extension ChoiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
