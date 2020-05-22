//
//  OfflineViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 5/22/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol OfflineDisplayLogic: class {
    func displayData(viewModel: Offline.Model.ViewModel.ViewModelData)
}

class OfflineViewController: UIViewController, OfflineDisplayLogic {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var didConnect: (() -> Void)?
    
    var interactor: OfflineBusinessLogic?
    var router: (NSObjectProtocol & OfflineRoutingLogic)?
    
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
        let interactor            = OfflineInteractor()
        let presenter             = OfflinePresenter()
        let router                = OfflineRouter()
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
        setUpTheming()
        
        ConnectionManager.shared.reachability.whenReachable = { [weak self] _ in
            guard let self = self else { return }
            self.didConnect?()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        ConnectionManager.shared.reachability.stopNotifier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let size = view.bounds.width / 20
        titleLabel.font = UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    func displayData(viewModel: Offline.Model.ViewModel.ViewModelData) {
        
    }
    
}

extension OfflineViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.textColor
        descriptionLabel.textColor = theme.textColor
    }
}
