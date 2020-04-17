//
//  GraphViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol GraphDisplayLogic: class {
    func displayData(viewModel: Graph.Model.ViewModel.ViewModelData)
}

class GraphViewController: UIViewController, GraphDisplayLogic {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var interactor: GraphBusinessLogic?
    var router: (NSObjectProtocol & GraphRoutingLogic)?
    
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
        let interactor            = GraphInteractor()
        let presenter             = GraphPresenter()
        let router                = GraphRouter()
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
        setupView()
    }
    
    func displayData(viewModel: Graph.Model.ViewModel.ViewModelData) {
        
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.periodCollectionViewCell)
    }
}

extension GraphViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = R.reuseIdentifier.periodCollectionViewCell
        guard let
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: id,
                                                      for: indexPath)
            else {
            fatalError()
        }
        return cell
    }
    
}

extension GraphViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PeriodCollectionViewCell else { return }
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PeriodCollectionViewCell else { return }
        cell.isSelected = false
    }
}
