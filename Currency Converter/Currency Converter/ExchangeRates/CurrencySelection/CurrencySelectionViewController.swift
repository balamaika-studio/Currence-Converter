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
    
    var interactor: CurrencySelectionBusinessLogic?
    var router: (NSObjectProtocol & CurrencySelectionRoutingLogic)?
    
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
    }
    
    func displayData(viewModel: CurrencySelection.Model.ViewModel.ViewModelData) {
        
    }
    
}
