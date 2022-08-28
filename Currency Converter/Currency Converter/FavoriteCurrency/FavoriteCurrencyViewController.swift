//
//  FavoriteViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteCurrencyDisplayLogic: class {
    func displayData(viewModel: Favorite.Model.ViewModel.ViewModelData)
}

class FavoriteCurrencyViewController: UIViewController, FavoriteCurrencyDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var buttonsContainerView: UIView!
    
    private var quotes = [FavoriteViewModel]()
    
    var interactor: FavoriteCurrencyBusinessLogic?
    var router: (NSObjectProtocol & FavoriteCurrencyRoutingLogic)?
    weak var delegate: ExchangeRatesDelegate?
    
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
        let interactor            = FavoriteCurrencyInteractor()
        let presenter             = FavoriteCurrencyPresenter()
        let router                = FavoriteCurrencyRouter()
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
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if delegate == nil {
            interactor?.makeRequest(request: .loadCurrenciesConverter)
        } else {
            interactor?.makeRequest(request: .loadCurrenciesExchange)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = String()
        searchBar(self.searchBar, textDidChange: String())
    }
    
    func displayData(viewModel: Favorite.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .showCurrencies(let quotes):
            self.quotes = quotes
            self.tableView.reloadData()
        }
    }
    
    private func setupView() {
        title = R.string.localizable.favoriteTitle()
        let rootViewControoler = navigationController?.viewControllers.first
        let rootVCTitle = rootViewControoler?.navigationController?.navigationBar.topItem?.title
        navigationController?.navigationBar.topItem?.title = rootVCTitle
        
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = setPlaceHolder(placeholder: R.string.localizable.searchPlaceholder())
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(R.nib.favoriteTableViewCell)
        tableView.separatorStyle = .none
        if delegate == nil {
            tableView.allowsMultipleSelection = true
        } else {
            tableView.allowsMultipleSelection = false
        }

        tableView.rowHeight = 62
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
    
    // MARK: - Actions
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        router?.dismiss()
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        if delegate == nil {
            quotes.forEach {
                if $0.isSelected {
                    interactor?.makeRequest(request: .addFavorite($0))
                } else {
                    interactor?.makeRequest(request: .removeFavorite($0))
                }
            }
            router?.dismiss()
        } else {
            delegate?.applySelectedCurrencies()
            router?.dismiss()
        }
    }
}

// MARK: - Themed
extension FavoriteCurrencyViewController: Themed {
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
        view.backgroundColor = theme.specificBackgroundColor
        tableView.backgroundColor = .clear
        tableView.reloadData()
        cancelButton.backgroundColor = .white
        confirmButton.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        cancelButton.setTitleColor(.gray , for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        buttonsContainerView.backgroundColor = theme.backgroundColor
    }
}

// MARK: - UITableViewDelegate
extension FavoriteCurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate == nil {
            quotes[indexPath.row].isSelected = true
        } else {
            var currencyQuotes: [FavoriteViewModel] = []
            quotes.forEach {
                var q = $0
                q.isSelected = false
                currencyQuotes.append(q)
            }
            currencyQuotes[indexPath.row].isSelected = true
            quotes = currencyQuotes
            delegate?.setSelectedCurrency(model: currencyQuotes[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if delegate == nil {
            quotes[indexPath.row].isSelected = false
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteCurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = R.reuseIdentifier.favoriteTableViewCell
        guard let
            cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) else {
                fatalError()
        }
        
        let quote = quotes[indexPath.row]
        cell.configure(with: quote)
        if quote.isSelected {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension FavoriteCurrencyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.makeRequest(request: .filter(title: searchText))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
