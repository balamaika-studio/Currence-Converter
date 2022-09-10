//
//  GraphCryptoCryptoViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/17/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import Charts

protocol GraphCryptoDisplayLogic: class {
    func displayData(viewModel: GraphCrypto.Model.ViewModel.ViewModelData)
}

final class GraphCryptoViewController: UIViewController, GraphCryptoDisplayLogic {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var converterView: RelativeExchangeView!
    @IBOutlet weak var currenciesRateLabel: UILabel!
    
    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var chartValueLabel: EdgeInsetLabel!
    
    @IBOutlet weak var contenerView: UIView!
    @IBOutlet weak var leadingCollectionViewConstraint: NSLayoutConstraint!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.preservesSuperviewLayoutMargins = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contenerView)
        return scrollView
    }()
    
    var interactor: GraphCryptoBusinessLogic?
    var router: (GraphCryptoRoutingLogic & ChoiceDataPassing)?
    
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
        let interactor            = GraphCryptoInteractor()
        let presenter             = GraphCryptoPresenter()
        let router                = GraphCryptoRouter()
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
        interactor?.makeRequest(request: .getGraphCryptoPeriods)
        interactor?.makeRequest(request: .getDefaultConverter)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var indexPath = IndexPath(item: 0, section: 0)
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            indexPath = selectedIndexPath
        }
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func displayData(viewModel: GraphCrypto.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showGraphCryptoPeriods(let periods):
            self.periods = periods
            let padding = leadingCollectionViewConstraint.constant
            let sizeClass = traitCollection.horizontalSizeClass
            let layout = PeriodCollectionViewHelper.shared.getLayout(for: sizeClass,
                                                                     itemsCount: periods.count,
                                                                     padding: padding)
            collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.reloadData()
            
        case .showGraphCryptoConverter(let viewModel):
            converterView.configure(with: viewModel)
            
        case .updateConverter(let newModel):
            converterView.updateSelectedCurrency(with: newModel)
            
        case .showGraphCryptoData(let viewModel):
            setChartData(with: viewModel)
        }
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        edgesForExtendedLayout = UIRectEdge()
        extendedLayoutIncludesOpaqueBars = false
        NSLayoutConstraint.activate([
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.topAnchor.constraint(equalTo: converterView.bottomAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        scrollView.leadingAnchor.constraint(equalTo: contenerView.leadingAnchor),
        scrollView.topAnchor.constraint(equalTo: contenerView.topAnchor),
        scrollView.trailingAnchor.constraint(equalTo: contenerView.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: contenerView.bottomAnchor),
        
        contenerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        periods = []
        labelLeadingMarginInitialConstant = labelLeadingMarginConstraint.constant
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.periodCollectionViewCell)

        chartView.delegate = self
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.chartDescription?.enabled = false
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
        rightYAxis.enabled = true // right axis
        rightYAxis.labelTextColor = .gray
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawAxisLineEnabled = false
        
        // XAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.labelTextColor = .gray
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        chartView.setExtraOffsets(left: 20, top: 0, right: 0, bottom: 0)
        
        let xAxisRender = NoOverlappingLabelsXAxisRenderer(viewPortHandler: chartView.viewPortHandler,
                                                           xAxis: xAxis,
                                                           transformer: chartView.xAxisRenderer.transformer)
        chartView.xAxisRenderer = xAxisRender
        
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
    
    private func setChartData(with GraphCryptoCryptoViewModel: GraphViewModel) {
        chartView.clear()
        chartView.xAxis.valueFormatter = ChartXValueFormatter(dates: GraphCryptoCryptoViewModel.dates)
        let entries = GraphCryptoCryptoViewModel.data.enumerated().map { index, value in
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
        lineDataSet.mode = .cubicBezier
        
        let chartData = LineChartData(dataSet: lineDataSet)
        chartView.data = chartData
    }
    
    private func clearChartLabel() {
        chartValueLabel.text = ""
        chartValueLabel.backgroundColor = .clear
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
}

// MARK: - Themed
extension GraphCryptoViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.specificBackgroundColor
        currenciesRateLabel.textColor = theme.textColor
        chartView.noDataTextColor = theme.textColor
    }
}

// MARK: - ChoiceBackDataPassing
extension GraphCryptoViewController: ChoiceBackDataPassing {
    func getRouter() -> ChoiceDataPassing {
        return router!
    }

    func updateControllerWithSelectedCurrency() {
        interactor?.makeRequest(request: .updateConverterCurrency)
    }
}

// MARK: - ChartViewDelegate
extension GraphCryptoViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let left = highlight.xPx
        scrollView.isScrollEnabled = false
        scrollView.touchesShouldCancel(in: chartView)        
        chartValueLabel.backgroundColor = #colorLiteral(red: 0.3882352941, green: 0.5450980392, blue: 0.9843137255, alpha: 1)
        chartValueLabel.text = "\(AccuracyManager.shared.formatNumber(entry.y))"
        
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
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        scrollView.isScrollEnabled = true
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        scrollView.isScrollEnabled = true
    }
}

// MARK: - UICollectionViewDataSource
extension GraphCryptoViewController: UICollectionViewDataSource {
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

// MARK: - UICollectionViewDelegate
extension GraphCryptoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PeriodCollectionViewCell else { return }
        clearChartLabel()
        cell.isSelected = true
        let base = converterView.baseCurrency.currency
        let relative = converterView.relativeCurrency.currency
        let GraphCryptoCryptoPeriod = periods[indexPath.row]
        interactor?.makeRequest(request: .loadGraphCryptoData(base: base,
                                                        relative: relative,
                                                        period: GraphCryptoCryptoPeriod))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PeriodCollectionViewCell else { return }
        cell.isSelected = false
    }
}

//// MARK: - UIViewControllerTransitioningDelegate
//extension GraphCryptoViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
