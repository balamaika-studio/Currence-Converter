//
//  SettingsViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit
import StoreKit

protocol SettingsDisplayLogic: class {
    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hiddenTextField: UITextField!
    
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic)?
    
    var accuracyPicker: UIPickerView!
    var blurView: UIVisualEffectView!
    var vibrancyView: UIVisualEffectView!
    var tableViewDataSource: SettingsTableViewDataSource!
    
    var selectedCell: UITableViewCell?
    var selectedAccuracy: Accuracy?
    var products: [SKProduct] {
        didSet {
            tableViewDataSource.products = products
            tableView.reloadData()
        }
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        products = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        products = []
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SettingsInteractor()
        let presenter             = SettingsPresenter()
        let router                = SettingsRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.makeRequest(request: .purchases)
        createPickerView()
        setupTableView()
        setUpTheming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createVisualEffects()
    }
    
    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .products(let products):
            self.products = products
        }
    }
    
    // MARK: - Private Methods
    private func createPickerView() {
        accuracyPicker = UIPickerView()
        accuracyPicker.delegate = self
        accuracyPicker.dataSource = self

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = .systemBlue
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: R.string.localizable.done(),
                                         style: .done,
                                         target: self,
                                         action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(title: R.string.localizable.close(),
                                         style: .done,
                                         target: self,
                                         action: #selector(self.closePicker))
        toolBar.setItems([closeButton, spaceButton, doneButton], animated: true)

        hiddenTextField.inputView = accuracyPicker
        hiddenTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        let selectedRow = accuracyPicker.selectedRow(inComponent: 0)
        selectedAccuracy = Accuracy(rawValue: selectedRow + 1)
        selectedCell?.detailTextLabel?.text = selectedAccuracy?.description
        
        let newAccuracy = selectedAccuracy != nil ? selectedAccuracy! : Accuracy.defaultAccurancy
        AccuracyManager.shared.accuracy = newAccuracy.rawValue
        
        hiddenTextField.resignFirstResponder()
        deselectDecimaPlacesCell()
        removeBlure()
    }
    
    @objc func closePicker() {
        hiddenTextField.resignFirstResponder()
        deselectDecimaPlacesCell()
        removeBlure()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            products.contains(where: { $0.productIdentifier == productID }) == true
            else { return }
        
        tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
    
    private func setupTableView() {
        let footerFrame = CGRect(x: 0, y: 0,
                                 width: tableView.frame.width,
                                 height: 75)
        tableViewDataSource = SettingsTableViewDataSource()
        tableView.delegate = self
        tableView.dataSource = tableViewDataSource
        tableView.sectionFooterHeight = 0.5
        tableView.contentInset = AdBannerInsetService.shared.tableInset
        
        tableView.tableFooterView = RestorePurchasesFooterView(frame: footerFrame)
        tableView.register(SettingsTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: SettingsTableViewHeader.reuseId)
        tableView.register(R.nib.settingsPurchaseCell)
        tableView.register(SettingsTableViewCell.self,
                           forCellReuseIdentifier: SettingsTableViewCell.cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
    }
    
    private func deselectDecimaPlacesCell() {
        if let decimalPlacesPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: decimalPlacesPath, animated: true)
        }
    }
    
    private func createVisualEffects() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.8
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        vibrancyView.frame = blurView.frame
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func addBlure() {
        UIView.animate(withDuration: 0.5) {
            self.view.addSubview(self.blurView)
            self.blurView.contentView.addSubview(self.vibrancyView)
        }
    }
    
    private func removeBlure() {
        UIView.animate(withDuration: 0.5) {
            self.vibrancyView.removeFromSuperview()
            self.blurView.removeFromSuperview()
        }
    }
    
    private func chooseAccuracyTapped(cell: UITableViewCell) {
        selectedCell = cell
        addBlure()
        hiddenTextField.becomeFirstResponder()
    }
}

extension SettingsViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        _ = navigationController?.view.snapshotView(afterScreenUpdates: true)
        if let toolBar = hiddenTextField.inputAccessoryView as? UIToolbar {
            toolBar.barStyle = theme == .light ? .default : .black
        } else {
            hiddenTextField.inputAccessoryView?.backgroundColor = theme.specificBackgroundColor
        }
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        hiddenTextField.inputView?.backgroundColor = theme.backgroundColor
        tabBarController?.tabBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.update(backroundColor: theme.barBackgroundColor, titleColor: .white)
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let reuseId = SettingsTableViewHeader.reuseId
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId)
                as? SettingsTableViewHeader,
            let section = SettingsSection(rawValue: section) else { return nil }
        header.configure(with: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        guard let section = SettingsSection(rawValue: section) else {
            return height
        }
        switch section {
        case .purchases:
            height = 0
        default:
            height = 40
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        guard let section = SettingsSection(rawValue: indexPath.section) else {
            return height
        }
        switch section {
        case .purchases:
            height = 100
        default:
            height = 60
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorFrame = CGRect(x: 0, y: 0,
                                    width: tableView.frame.width,
                                    height: 0.5)
        let separator = UIView(frame: separatorFrame)
        separator.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return separator
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let section = SettingsSection(rawValue: indexPath.section),
            let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        switch section {
        case .appearance:
            guard let appearance = AppearanceOptions(rawValue: indexPath.row) else { break }
            switch appearance {
            case .accuracy: chooseAccuracyTapped(cell: selectedCell)
            default: break
            }
            
        default: break
        }
    }
}

// MARK: - UIPickerViewDataSource
extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Accuracy.allCases.count
    }
}

// MARK: - UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let accuracyText = Accuracy(rawValue: row + 1)?.description else {
            return nil
        }
        let color = themeProvider.currentTheme.textColor
        return NSAttributedString(string: accuracyText,
                                  attributes: [.foregroundColor: color])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Accuracy(rawValue: row + 1)?.description
    }
}
