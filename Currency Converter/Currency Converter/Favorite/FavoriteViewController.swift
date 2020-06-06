//
//  FavoriteViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteDisplayLogic: class {
    func displayData(viewModel: Favorite.Model.ViewModel.ViewModelData)
}

class FavoriteViewController: UIViewController, FavoriteDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var quotes = [FavoriteViewModel]()
    
    var interactor: FavoriteBusinessLogic?
    var router: (NSObjectProtocol & FavoriteRoutingLogic)?
    
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
        let interactor            = FavoriteInteractor()
        let presenter             = FavoritePresenter()
        let router                = FavoriteRouter()
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
        interactor?.makeRequest(request: .loadCurrencies)
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
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 62
        tableView.contentInset = AdBannerInsetService.shared.tableInset
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
}

// MARK: - Themed
extension FavoriteViewController: Themed {
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
    }
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = quotes[indexPath.row]
        interactor?.makeRequest(request: .addFavorite(viewModel))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let viewModel = quotes[indexPath.row]
        interactor?.makeRequest(request: .removeFavorite(viewModel))
    }
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
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
extension FavoriteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.makeRequest(request: .filter(title: searchText))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
