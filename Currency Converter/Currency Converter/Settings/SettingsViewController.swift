//
//  SettingsViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/20/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SettingsDisplayLogic: class {
    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic)?
    
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
        let interactor            = SettingsInteractor()
        let presenter             = SettingsPresenter()
        let router                = SettingsRouter()
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
        title = "Настройки"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 40
        tableView.rowHeight = 60
        tableView.sectionFooterHeight = 0.5
        tableView.tableFooterView = UIView()
        tableView.register(SettingsTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: SettingsTableViewHeader.reuseId)
        tableView.register(SettingsTableViewCell.self,
                           forCellReuseIdentifier: SettingsTableViewCell.cellId)
    }
    
    func displayData(viewModel: Settings.Model.ViewModel.ViewModelData) {
        
    }
    
    // MARK: - Private Methods
    private func autoUpdate(_ state: Bool) {
        print("\(#function) = \(state)")
    }
    
    private func clearField(_ state: Bool) {
        print("\(#function) = \(state)")
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
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let reuseId = SettingsTableViewHeader.reuseId
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId)
                as? SettingsTableViewHeader,
            let section = SettingsSection(rawValue: section) else { return nil }
        header.configure(with: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = SettingsTableViewCell.cellId
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                     for: indexPath) as? SettingsTableViewCell,
            let section = SettingsSection(rawValue: indexPath.section) else {
                return UITableViewCell()
        }
        
        switch section {
        case .network:
            let network = NetworkOptions(rawValue: indexPath.row)
            cell.sectionType = network
            cell.autoUpdateChanged = self.autoUpdate
            cell.selectionStyle = .none
            
        case .appearance:
            guard let appearance = AppearanceOptions(rawValue: indexPath.row) else { break }
            switch appearance {
            case .clearField:
                cell.selectionStyle = .none
                cell.clearFieldChnaged = self.clearField
            default: break
            }
            cell.sectionType = appearance
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorFrame = CGRect(x: 0, y: 0,
                                    width: tableView.frame.width,
                                    height: 0.5)
        let separator = UIView(frame: separatorFrame)
        separator.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return separator
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        switch section {
        case .appearance:
            guard let appearance = AppearanceOptions(rawValue: indexPath.row) else { break }
            switch appearance {
            case .accuracy: print("Open accuracy")
            case .theme: print("Open theme")
            default: break
            }
            
        default: break
        }
    }
}
