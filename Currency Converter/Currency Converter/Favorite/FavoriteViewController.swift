//
//  FavoriteViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol FavoriteDisplayLogic: class {
}

class FavoriteViewController: UIViewController, FavoriteDisplayLogic {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var navbarView: UIView!
    @IBOutlet weak var navbarTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    private lazy var favouriteCurrencyVC: FavoriteCurrencyViewController = {
        var viewController = FavoriteCurrencyViewController(nib: R.nib.favoriteCurrencyViewController)
        add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var favouriteCryptocurrencyVC: FavoriteCryptocurrencyViewController = {
        var viewController = FavoriteCryptocurrencyViewController(nib: R.nib.favoriteCryptocurrencyViewController)
        add(asChildViewController: viewController)
        return viewController
    }()
    
    var interactor: FavoriteBusinessLogic?
    var router: (NSObjectProtocol & FavoriteRoutingLogic)?
    weak var delegate: ConverterUpdateViewDelegate?
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupMainView()
    }
    
    // MARK: - Private Methods
    
    private func setupMainView() {
        mainView.layer.cornerRadius = 14
        mainView.clipsToBounds = true
    }
    
    private func setNavbarLabelTitle() {
        navbarTitleLabel.text = R.string.localizable.favouriteAddCurrencyTitle()
    }
    
    private func setupView() {
        setNavbarLabelTitle()
        DispatchQueue.main.async {
            self.setupSegmentedControl()
            self.updateView(selectedIndex: self.segmentedControl.selectedSegmentIndex)
        }
    }
    
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
        segmentedControl.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)],
                                                for: .normal)
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
            remove(asChildViewController: favouriteCryptocurrencyVC)
            add(asChildViewController: favouriteCurrencyVC)
        case 1:
            remove(asChildViewController: favouriteCurrencyVC)
            add(asChildViewController: favouriteCryptocurrencyVC)
        default:
            break
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}

// MARK: - Themed
extension FavoriteViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        navbarTitleLabel.textColor = .white
    }
}
