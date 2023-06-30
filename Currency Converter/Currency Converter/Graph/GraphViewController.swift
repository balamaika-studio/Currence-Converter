//
//  GraphViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import Charts

protocol GraphDisplayLogic: class {
    func displayData(viewModel: Graph.Model.ViewModel.ViewModelData)
}

final class GraphViewController: UIViewController, GraphDisplayLogic {
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var converterView: RelativeExchangeView!
    @IBOutlet weak var currenciesRateLabel: UILabel!
    
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var currencyValue: UILabel!
    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var chartValueLabel: EdgeInsetLabel!
    
    @IBOutlet weak var contenerView: UIView!
    
    @IBOutlet weak var purchaseLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var interactor: GraphBusinessLogic?
    var router: (GraphRoutingLogic & ChoiceDataPassing)?
    
    private var periods: [GraphPeriod]!
    private var labelLeadingMarginInitialConstant: CGFloat!
    private var viewModel: GraphViewModel?
    
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
        setUpTheming()
        interactor?.makeRequest(request: .getGraphPeriods)
        interactor?.makeRequest(request: .getDefaultConverter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let adsProductId = ConverterProducts.SwiftShopping
        guard ConverterProducts.store.isProductPurchased(adsProductId) else {
            return
        }
        purchaseButton.isHidden = true
        converterView.isUserInteractionEnabled = true
        purchaseLabel.isHidden = true
    }
    
    func displayData(viewModel: Graph.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showGraphPeriods(let periods):
            self.periods = periods
            configureSegment()
            
        case .showGraphConverter(let viewModel):
            converterView.configure(with: viewModel)
            segmentedControlValueChanged(segmentControl)
            
        case .updateConverter(let newModel):
            converterView.updateSelectedCurrency(with: newModel)
            
        case .showGraphData(let viewModel):
            setChartData(with: viewModel)
        }
    }
    
    private func setupView() {
        converterView.isUserInteractionEnabled = false
        view.addSubview(contenerView)
        edgesForExtendedLayout = UIRectEdge()
        extendedLayoutIncludesOpaqueBars = false
        NSLayoutConstraint.activate([
            contenerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contenerView.topAnchor.constraint(equalTo: view.topAnchor),
            contenerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contenerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        purchaseLabel.text = R.string.localizable.purchase()
        periods = []
        labelLeadingMarginInitialConstant = labelLeadingMarginConstraint.constant
        chartValueLabel.layer.cornerRadius = 10

        chartView.delegate = self
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.chartDescription.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.legend.enabled = false
        chartView.noDataText = R.string.localizable.noGraphData()

        // YAxis
        let leftYAxis = chartView.getAxis(.left)
        leftYAxis.drawLabelsEnabled = false // no axis labels
        leftYAxis.drawAxisLineEnabled = false // no axis line
        leftYAxis.drawGridLinesEnabled = false // no grid lines
        leftYAxis.drawZeroLineEnabled = true // draw a zero line
        
        let rightYAxis = chartView.getAxis(.right)
        rightYAxis.valueFormatter = ChartYValueFormatter()
        rightYAxis.enabled = false // right axis
        rightYAxis.labelTextColor = .gray
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawAxisLineEnabled = false
        
        // XAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.labelTextColor = .gray
        xAxis.enabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        
        let xAxisRender = NoOverlappingLabelsXAxisRenderer(viewPortHandler: chartView.viewPortHandler,
                                                           axis: xAxis,
                                                           transformer: chartView.xAxisRenderer.transformer)
        chartView.xAxisRenderer = xAxisRender
        
        converterView.changeCurrencyTapped = self.showChoiceViewController
        converterView.updateCurrenciesLabel = self.updateCurrenciesRateLabel
    }
    
    private func configureSegment() {
        let _ = zip(periods.indices, periods).map { (index, period) in
            segmentControl.setTitle(period.period + period.title, forSegmentAt: index)
        }
        segmentControl.addTarget(self, action: #selector(GraphViewController.segmentedControlValueChanged(_:)), for: .valueChanged)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
    }
    
    private func showChoiceViewController(isLeft: Bool, oppositeCurrency: String) {
        router?.showChoiceViewController(isLeft: isLeft, oppositeCurrency: oppositeCurrency)
    }
    
    private func updateCurrenciesRateLabel(_ text: String) {
        currenciesRateLabel.text = text
        segmentedControlValueChanged(segmentControl)
    }
    
    private func setChartData(with graphViewModel: GraphViewModel) {
        chartView.clear()
        chartView.xAxis.valueFormatter = ChartXValueFormatter(dates: graphViewModel.dates)
        viewModel = graphViewModel
        let entries = graphViewModel.data.enumerated().map { index, value in
            return ChartDataEntry(x: Double(index), y: value)
        }
        
        let lineDataSet = LineChartDataSet(entries: entries)
        lineDataSet.axisDependency = .left
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.fillColor = #colorLiteral(red: 0.4196078431, green: 0.5176470588, blue: 0.9764705882, alpha: 1)
        lineDataSet.fillAlpha = 0.3
        lineDataSet.lineWidth = 2
        lineDataSet.drawFilledEnabled = true
        lineDataSet.setColor(#colorLiteral(red: 0.3882352941, green: 0.5450980392, blue: 0.9843137255, alpha: 1))
        lineDataSet.highlightColor = #colorLiteral(red: 0.4196078431, green: 0.5176470588, blue: 0.9764705882, alpha: 1)
        lineDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineDataSet.highlightLineWidth = 1.5
        lineDataSet.drawValuesEnabled = false
        lineDataSet.mode = .linear
        
        let chartData = LineChartData(dataSet: lineDataSet)
        chartView.data = chartData
    }
    
    @IBAction func purchaseButtonAction(_ sender: Any) {
        router?.showPurchaseViewController()
    }
    private func clearChartLabel() {
        chartValueLabel.text = ""
        currencyValue.text = ""
        chartValueLabel.backgroundColor = .clear
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        clearChartLabel()
        let base = converterView.baseCurrency.currency
        let relative = converterView.relativeCurrency.currency
        let graphPeriod = periods[sender.selectedSegmentIndex]
        interactor?.makeRequest(request: .loadGraphData(base: base,
                                                        relative: relative,
                                                        period: graphPeriod))
    }
}

// MARK: - Themed
extension GraphViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tabBarController?.tabBar.backgroundColor = theme.barBackgroundColor
        view.backgroundColor = theme.backgroundColor
        currenciesRateLabel.textColor = theme.textColor
        chartView.noDataTextColor = theme.textColor
        
        if theme == .light {
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            segmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
            segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
            segmentControl.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        } else {
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            segmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
            segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.4, alpha: 1)
            segmentControl.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3450980392, alpha: 0.65)
        }
    }
}

// MARK: - ChoiceBackDataPassing
extension GraphViewController: ChoiceBackDataPassing {
    func getRouter() -> ChoiceDataPassing {
        return router!
    }
    
    func updateControllerWithSelectedCurrency() {
        interactor?.makeRequest(request: .updateConverterCurrency)
    }
}

// MARK: - ChartViewDelegate
extension GraphViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let left = highlight.xPx
        chartValueLabel.backgroundColor = #colorLiteral(red: 0.3882352941, green: 0.5450980392, blue: 0.9843137255, alpha: 1)
        currencyValue.text = "\(AccuracyManager.shared.formatNumber(entry.y))"
        if let date = viewModel?.dates[Int(entry.x)] {
            chartValueLabel.text = "\(date)"
        }
        
        // Align the label to the touch left position, centered
        var constant = labelLeadingMarginInitialConstant + left - (chartValueLabel.frame.width / 2)
        
        // Avoid placing the label on the left of the chart
        if constant < labelLeadingMarginInitialConstant {
            constant = labelLeadingMarginInitialConstant
        }
        
        // Avoid placing the label on the right of the chart
        let rightMargin = chartView.frame.width - chartValueLabel.frame.width
        if constant > rightMargin {
            constant = rightMargin
        }
        labelLeadingMarginConstraint.constant = constant
    }
}
