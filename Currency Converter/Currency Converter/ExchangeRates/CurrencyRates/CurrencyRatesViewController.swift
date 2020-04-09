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
    
    var interactor: CurrencyRatesBusinessLogic?
    var router: (NSObjectProtocol & CurrencyRatesRoutingLogic)?
    
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
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayData(viewModel: CurrencyRates.Model.ViewModel.ViewModelData) {
        
    }
    
}
