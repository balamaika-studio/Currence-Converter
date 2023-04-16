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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navbarView: UIView!

    var interactor: ChoiceBusinessLogic?
    var router: ChoiceRoutingLogic?
    
    var isShowGraphCurrencies = false
    var isCrypto = false
    var oppositeCurrency: String = ""
    var isLeft: Bool = true
    private var currencies: [ChoiceCurrencyViewModel]!
    var userHasPurchase: Bool = false
    
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
        router.dataStore          = interactor
    }
    
    // MARK: Routing
    @IBAction func doneTapped(_ sender: UIButton) {
        router?.closeChoiceViewController()
    }

    @IBAction func cancelTapped(_ sender: UIButton) {
        router?.dismissViewController()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpTheming()
        setupMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let adsProductId = ConverterProducts.SwiftShopping
        if ConverterProducts.store.isProductPurchased(adsProductId) {
            userHasPurchase = true
        }
        interactor?.makeRequest(request: .loadCurrencies(forGraph: isShowGraphCurrencies, isCrypto: isCrypto, oppositeCurrency: oppositeCurrency))
        showActivityIndicator()
    }
    
    func displayData(viewModel: Choice.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayCurrencies(let currencies):
            self.hideActivityIndicator()
            self.currencies = currencies
            self.tableView.reloadData()
        }
    }

    // MARK: - Private Methods

    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: R.string.localizable.favouriteCurrencySegmentTitle(),
                                       at: 0, animated: false)

        segmentedControl.insertSegment(withTitle: R.string.localizable.favouriteCryptocurrencySegmentTitle(),
                                       at: 1, animated: false)
        segmentedControl.addTarget(self,
                                   action: #selector(selectionDidChange(_:)),
                                   for: .valueChanged)

        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white],
                                                for: .selected)
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        segmentedControl.setClearBackgroundSegmentControl()
    }

    @objc private func selectionDidChange(_ sender: UISegmentedControl) {
        updateView(selectedIndex: sender.selectedSegmentIndex)
    }

    private func updateView(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            isCrypto = false
            titleLabel.text = R.string.localizable.favouriteCurrencySegmentTitle()
            interactor?.makeRequest(request: .loadCurrencies(forGraph: isShowGraphCurrencies, isCrypto: isCrypto, oppositeCurrency: oppositeCurrency))
            showActivityIndicator()
        case 1:
            isCrypto = true
            titleLabel.text = R.string.localizable.favouriteCryptocurrencySegmentTitle()
            interactor?.makeRequest(request: .loadCurrencies(forGraph: isShowGraphCurrencies, isCrypto: isCrypto, oppositeCurrency: oppositeCurrency))
            showActivityIndicator()
        default:
            break
        }
    }

    private func setupMainView() {
        mainView.layer.cornerRadius = 14
        mainView.clipsToBounds = true
    }
    
    private func setupView() {
        DispatchQueue.main.async {
            self.setupSegmentedControl()
            self.updateView(selectedIndex: self.segmentedControl.selectedSegmentIndex)
        }

        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = setPlaceHolder(placeholder: R.string.localizable.searchPlaceholder())
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(R.nib.choiceCurrencyTableViewCell)
        tableView.separatorStyle = .none
        currencies = []
        configureButton()
    }

    private func configureButton() {
        cancelButton.setTitle(R.string.localizable.cancel(), for: .normal)
        confirmButton.setTitle(R.string.localizable.add(), for: .normal)
        confirmButton.layer.cornerRadius = 7
        cancelButton.layer.cornerRadius = 7
    }

    private func setPlaceHolder(placeholder: String) -> String {
        let text = placeholder
        if text.last! != " " {
            let maxSize = CGSize(width: UIScreen.main.bounds.size.width - 97, height: 40)
            // get the size of the text
            let widthText = text.boundingRect(with: maxSize,
                                              options: .usesLineFragmentOrigin,
                                              attributes: nil,
                                              context: nil).size.width
            // get the size of one space
            let widthSpace = " ".boundingRect(with: maxSize,
                                              options: .usesLineFragmentOrigin,
                                              attributes: nil,
                                              context: nil).size.width
            let spaces = floor((maxSize.width - widthText) / widthSpace)
            // add the spaces
            let newText = text + ((Array(repeating: " ",
                                         count: Int(spaces)).joined(separator: "")))
            // apply the new text if nescessary
            if newText != text {
                return newText
            }
        }
        return placeholder;
    }

    private func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
}

extension ChoiceViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        var searchTextField: UITextField?
        let searchIcon = theme == .light ?
            R.image.searchLight() :
            R.image.searchDark()

        if #available(iOS 13.0, *) {
            searchTextField = searchBar.searchTextField
        } else {
            searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        }

        searchBar.barTintColor = theme.specificBackgroundColor
        searchBar.setImage(searchIcon, for: .search, state: .normal)
        searchTextField?.textColor = theme.searchTextColor
        searchTextField?.backgroundColor = theme.searchTextFieldColor
        titleLabel.textColor = .white
        tableView.backgroundColor = theme.backgroundColor
        tableView.reloadData()
        cancelButton.backgroundColor = theme.backgroundConverterColor
        confirmButton.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        cancelButton.setTitleColor(theme.cancelTitleColor , for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        buttonsContainerView.backgroundColor = theme.backgroundColor
        mainView.backgroundColor = theme.backgroundColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: theme.textColor],
                                                for: .normal)
        navbarView.backgroundColor = theme.barBackgroundColor
    }
}

extension ChoiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.choiceCurrencyTableViewCell,
                                                       for: indexPath) else { fatalError() }
        
        let viewModel = currencies[indexPath.row]
        if !userHasPurchase && !viewModel.isFree {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        cell.configure(with: viewModel)
        return cell
    }
}

extension ChoiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedViewModel = currencies[indexPath.row]
        interactor?.makeRequest(request: .chooseCurrency(viewModel: selectedViewModel))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}

// MARK: - UISearchBarDelegate
extension ChoiceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.makeRequest(request: .filter(title: searchText))
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
