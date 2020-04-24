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
    
    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var chartValueLabel: EdgeInsetLabel!
    
    var interactor: GraphBusinessLogic?
    var router: (GraphRoutingLogic & ChoiceDataPassing)?
    
    private var periods: [GraphPeriod]!
    private var labelLeadingMarginInitialConstant: CGFloat!
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = collectionView.indexPathsForSelectedItems?.first {
            return
        }
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func displayData(viewModel: Graph.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showGraphPeriods(let periods):
            self.periods = periods
            collectionView.reloadData()
            
        case .showGraphConverter(let viewModel):
            converterView.configure(with: viewModel)
            
        case .updateConverter(let newModel):
            converterView.updateSelectedCurrency(with: newModel)
            
        case .showGraphData(let viewModel):
            setChartData(with: viewModel)
        }
    }
    
    private func setupView() {
        periods = []
        title = "Графики"
        labelLeadingMarginInitialConstant = labelLeadingMarginConstraint.constant
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.periodCollectionViewCell)
        
        // Configure chart layout
        chartView.gridColor = .clear
        chartView.axesColor = .clear
        chartView.labelColor = .black
        chartView.highlightLineColor = #colorLiteral(red: 0.389953196, green: 0.5452895164, blue: 0.9827637076, alpha: 1)
        chartView.highlightLineWidth = 1.5
        chartView.areaAlphaComponent = 0.3
        chartView.delegate = self
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
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    private func setChartData(with graphViewModel: GraphViewModel) {
        // Initialize data series and labels
        chartView.removeAllSeries()
        let serieData: [Double] = graphViewModel.data
        let series = ChartSeries(serieData)
        series.area = true
        
        // Add some padding above the x-axis
        let midValue = (serieData.min()! + serieData.max()!) / 2
        let padding = (serieData.min()! - midValue) / 2
        chartView.minY = serieData.min()! + padding
        
        chartView.xLabels = []
        chartView.yLabelsFormatter = { "\(AccuracyManager.shared.formatNumber($1))" }
        chartView.add(series)
    }
    
    private func clearChartLabel() {
        chartValueLabel.text = ""
        chartValueLabel.backgroundColor = .clear
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
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

// MARK: - ChartDelegate
extension GraphViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        if let value = chart.valueForSeries(0, atIndex: indexes[0]) {
            chartValueLabel.backgroundColor = #colorLiteral(red: 0.3882352941, green: 0.5450980392, blue: 0.9843137255, alpha: 1)
            chartValueLabel.text = "\(AccuracyManager.shared.formatNumber(value))"
            
            // Align the label to the touch left position, centered
            var constant = labelLeadingMarginInitialConstant + left - (chartValueLabel.frame.width / 2)
            
            // Avoid placing the label on the left of the chart
            if constant < labelLeadingMarginInitialConstant {
                constant = labelLeadingMarginInitialConstant
            }
            
            // Avoid placing the label on the right of the chart
            let rightMargin = chart.frame.width - chartValueLabel.frame.width
            if constant > rightMargin {
                constant = rightMargin
            }
            
            labelLeadingMarginConstraint.constant = constant
            
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        clearChartLabel()
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        //
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
        clearChartLabel()
        cell.isSelected = true
        let base = converterView.baseCurrency.currency
        let relative = converterView.relativeCurrency.currency
        let startInterval = periods[indexPath.row].interval
        interactor?.makeRequest(request: .loadGraphData(base: base,
                                                        relative: relative,
                                                        start: startInterval))
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
