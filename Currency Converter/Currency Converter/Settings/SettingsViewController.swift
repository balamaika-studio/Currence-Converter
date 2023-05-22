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
    var selectedCell: UITableViewCell?
    var selectedAccuracy: Accuracy?
    var products: [SKProduct] = [] {
        didSet {
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
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        tableView.reloadData()
    }
    
    private func autoUpdate(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: "autoUpdate")
    }
    
    private func clearField(_ state: Bool) {
        AppFieldClearManager.shared.isClear = state
        UserDefaults.standard.set(state, forKey: "clearField")
    }
    
    private func updateTheme(_ state: Bool) {
        let newTheme = state == true ? AppTheme.dark : AppTheme.light
        AppThemeManager.shared.currentTheme = newTheme
    }
    
    private func setupTableView() {
        let footerFrame = CGRect(x: 0, y: 0,
                                 width: tableView.frame.width,
                                 height: 75)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0.5
        tableView.contentInset = AdBannerInsetService.shared.tableInset
        tableView.tableFooterView = RestorePurchasesFooterView(frame: footerFrame)
        tableView.register(SettingsTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: SettingsTableViewHeader.reuseId)
        tableView.register(R.nib.settingsPurchaseCell)
        tableView.register(R.nib.settingsTableViewCell)
        
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
        view.backgroundColor = theme.settingsBackgroundColor
//        tableView.backgroundColor = theme.backgroundColor
        hiddenTextField.inputView?.backgroundColor = theme.backgroundColor
        tabBarController?.tabBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.update(backroundColor: theme.settingsBackgroundColor, titleColor: theme.barTintColor)
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
            height = 240
        default:
            height = 44
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let section = SettingsSection(rawValue: indexPath.section),
            let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        switch section {
        case .symbolCount:
            chooseAccuracyTapped(cell: selectedCell)
        case .network:
            break
        case .purchases:
            break
        case .appearance:
            break
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

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        switch section {
        case .network: return NetworkOptions.allCases.count
        case .appearance: return AppearanceOptions.allCases.count
        case .purchases:
            let availableProducts = products.filter { !ConverterProducts.store.isProductPurchased($0.productIdentifier) }
            if !availableProducts.isEmpty {
                return PurchaseOptions.allCases.count
            } else {
                return 0
            }
            
        case .symbolCount: return SymbolCountOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard let section = SettingsSection(rawValue: indexPath.section) else {
            return cell
        }
        
        switch section {
        case .network:
            guard let settingCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsTableViewCell,
                                                               for: indexPath) else { fatalError() }
            let network = NetworkOptions(rawValue: indexPath.row)
            settingCell.autoUpdateChanged = self.autoUpdate
            settingCell.selectionStyle = .none
            let isAutoUpdateEnable = UserDefaults.standard.bool(forKey: "autoUpdate")
            settingCell.configure(with: network, state: SwitchState(rawValue: isAutoUpdateEnable), position: .all)
            cell = settingCell
            
        case .purchases:
            let purchaseCellId = R.reuseIdentifier.settingsPurchaseCell
            guard let purchaseCell = tableView.dequeueReusableCell(withIdentifier: purchaseCellId,
                                                                   for: indexPath) else { break }
            purchaseCell.product = products[indexPath.row]
            purchaseCell.buyButtonHandler = { product in
                ConverterProducts.store.buyProduct(product)
            }
            cell = purchaseCell
            
        case .appearance:
            guard
                let settingCell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell,
                                                                for: indexPath) ,
                let appearance = AppearanceOptions(rawValue: indexPath.row) else { break }
            switch appearance {
            case .clearField:
                settingCell.clearFieldChnaged = self.clearField
                settingCell.selectionStyle = .none
                let isFieldClearEnable = AppFieldClearManager.shared.isClear
                settingCell.configure(with: appearance, state: SwitchState(rawValue: isFieldClearEnable), position: .first)
                
            case .theme:
                let switchState = AppThemeManager.shared.currentTheme == .dark ? true : false
                settingCell.themeChanged = self.updateTheme
                settingCell.selectionStyle = .none
                settingCell.configure(with: appearance, state: SwitchState(rawValue: switchState), position: .last)
            }
            cell = settingCell
        case .symbolCount:
            guard
                let settingCell = tableView.dequeueReusableCell(withIdentifier: R.nib.settingsTableViewCell,
                                                                for: indexPath) else { break }
            let symbolCountOptions = SymbolCountOptions(rawValue: indexPath.row)
            settingCell.selectionStyle = .none
            settingCell.configure(with: symbolCountOptions, state: nil, position: .all)
            cell = settingCell
        }
        
        return cell
    }
}
