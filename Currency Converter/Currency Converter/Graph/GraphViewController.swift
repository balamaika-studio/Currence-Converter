//
//  GraphViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import SwiftChart

protocol GraphDisplayLogic: class {
    func displayData(viewModel: Graph.Model.ViewModel.ViewModelData)
}

class GraphViewController: UIViewController, GraphDisplayLogic {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var converterView: RelativeExchangeView!
    @IBOutlet weak var currenciesRateLabel: UILabel!
    
    var interactor: GraphBusinessLogic?
    var router: (GraphRoutingLogic & ChoiceDataPassing)?
    
    private var periods: [GraphPeriod]!
    
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
        router.dataStore          = interactor
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor?.makeRequest(request: .getGraphPeriods)
        interactor?.makeRequest(request: .getDefaultConverter)
    }
    
    func displayData(viewModel: Graph.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showGraphPeriods(let periods):
            self.periods = periods
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
            
        case .showGraphConverter(let viewModel):
            converterView.configure(with: viewModel)
            
        case .updateConverter(let newModel):
            converterView.updateSelectedCurrency(with: newModel)
        }
    }
    
    private func setupView() {
        periods = []
        title = "Графики"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.periodCollectionViewCell)
        
        // Configure chart layout
        chartView.gridColor = .clear
        chartView.axesColor = .clear
        chartView.highlightLineColor = #colorLiteral(red: 0.389953196, green: 0.5452895164, blue: 0.9827637076, alpha: 1)
        chartView.highlightLineWidth = 1.5
        chartView.areaAlphaComponent = 0.3
//        chart.delegate = self
        chartView.lineWidth = 2
        chartView.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.xLabelsTextAlignment = .center
        chartView.yLabelsOnRightSide = true
        
        converterView.changeCurrencyTapped = self.showChoiceViewController
        converterView.updateCurrenciesLabel = self.updateCurrenciesRateLabel
    }
    
    private func showChoiceViewController() {
        router?.showChoiceViewController()
    }
    
    private func updateCurrenciesRateLabel(_ text: String) {
        currenciesRateLabel.text = text
    }
    
    private func setChartData() {
        // Initialize data series and labels
//        let stockValues = getStockValues()
        
        var serieData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: Array<String> = []
        
        let series = ChartSeries(serieData)
        series.area = true
        chartView.xLabels = labels
        // Add some padding above the x-axis
        chartView.minY = serieData.min()! - 5
        chartView.add(series)
    }
}

extension GraphViewController: ChoiceBackDataPassing {
    func getRouter() -> ChoiceDataPassing {
        return router!
    }
    
    func updateControllerWithSelectedCurrency() {
        interactor?.makeRequest(request: .updateConverterCurrency)
    }
}

extension GraphViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return periods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = R.reuseIdentifier.periodCollectionViewCell
        guard let
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: id,
                                                      for: indexPath)
            else {
            fatalError()
        }
        let viewModel = periods[indexPath.item]
        cell.configure(with: viewModel)
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

extension GraphViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
