//
//  ConverterViewController.swift
//  Currency Converter
//
//  Created by Kiryl Klimiankou on 3/16/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol ConverterDisplayLogic: class {
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData)
}

class ConverterViewController: UIViewController, ConverterDisplayLogic {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var converterView: ConverterView!
    
    
    var interactor: ConverterBusinessLogic?
    var router: ConverterRoutingLogic?
    
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
        let interactor            = ConverterInteractor()
        let presenter             = ConverterPresenter()
        let router                = ConverterRouter()
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
        tableView.register(R.nib.converterCurrencyTableViewCell)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        converterView.didTap = self.didTap
        
//        let network: Networking = NetworkService()
//        network.fetchData { (data) in
//            let logic = ECBParser()
//            let parser: CurrencyParsing = ParsingService(parseLogic: logic)
//            guard let data = data else {
//                print("Internet error")
//                return
//            }
//            let cube = parser.parse(data: data)
//            print(cube)
//        }
    }
    
    func displayData(viewModel: Converter.Model.ViewModel.ViewModelData) {
        
    }
    
    // MARK: Private Methods
    func didTap() {
        print("In ConverterVC")
        router?.showChoiceViewController()
    }
}

extension ConverterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.converterCurrencyTableViewCell,
                                                           for: indexPath) else { fatalError() }
        return cell
    }
    
}


extension ConverterViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class HalfSizePresentationController : UIPresentationController {
    var shadowView: UIView?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2,
                      width: containerView.bounds.width,
                      height: containerView.bounds.height / 2)
    }
    
    override func presentationTransitionWillBegin() {
        shadowView = UIView(frame: presentingViewController.view.frame)
        shadowView?.backgroundColor = .black
        shadowView?.layer.opacity = 0.3
        presentingViewController.view.addSubview(shadowView!)
    }
    
    override func dismissalTransitionWillBegin() {
        shadowView?.removeFromSuperview()
    }
}
