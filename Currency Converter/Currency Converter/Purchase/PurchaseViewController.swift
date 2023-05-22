//
//  FavoriteViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import StoreKit

protocol PurchaseDisplayLogic: class {
    func displayData(viewModel: Purchase.Model.ViewModel.ViewModelData)
}

class PurchaseViewController: UIViewController, PurchaseDisplayLogic {    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var updateDescription: UILabel!
    @IBOutlet weak var updateButton: UIButton!

    var interactor: PurchaseBusinessLogic?
    var router: (NSObjectProtocol & PurchaseRoutingLogic)?
    
    var products: [SKProduct] = []
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        products = []
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        products = []
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = PurchaseInteractor()
        let presenter             = PurchasePresenter()
        let router                = PurchaseRouter()
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
        interactor?.makeRequest(request: .purchases)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func displayData(viewModel: Purchase.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .products(let products):
            self.products = products
        }
    }
    
    private func setupView() {
        setupShadowBottomView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(R.nib.purchaseDescriptionTableViewCell)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        updateButton.layer.cornerRadius = 14
        
    }
    
    private func setupShadowBottomView() {
        bottomBackgroundView.layer.cornerRadius = 14

        bottomBackgroundView.clipsToBounds = true
        bottomBackgroundView.layer.masksToBounds = false
        bottomBackgroundView.layer.shadowRadius = 7
        bottomBackgroundView.layer.shadowOpacity = 1
        bottomBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        bottomBackgroundView.layer.shadowColor = UIColor(red: 0.192, green: 0.396, blue: 0.984, alpha: 0.4).cgColor
    }
    @IBAction func updateButtonAction(_ sender: Any) {
        if !products.isEmpty {
            if let availableProduct = products.filter { !ConverterProducts.store.isProductPurchased($0.productIdentifier)
            }.first {
                ConverterProducts.store.buyProduct(availableProduct)
            }
            
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        router?.dismiss()
        
    }
    // MARK: - Actions
}

// MARK: - Themed
extension PurchaseViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        
    }
}

extension PurchaseViewController: UITableViewDelegate {
    
}

extension PurchaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.purchaseDescriptionTableViewCell,
                                                       for: indexPath) else { fatalError() }
        cell.configure(model: PurchaseDescriptionModel(title: "dfsdfsdf fsdf sdf sdfsdsdf ", subTitle: "sdfs dfdsfsdf sdfsdfsdf sdfsdfsdfs fsdfsdfsdf sdfsdfsdf s"))
        
        return cell
    }
}
