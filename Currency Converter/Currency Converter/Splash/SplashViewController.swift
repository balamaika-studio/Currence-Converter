//
//  FavoriteViewController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 3/26/20.
//  Copyright (c) 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

protocol SplashDisplayLogic: class {
    func displayData(viewModel: Splash.Model.ViewModel.ViewModelData)
}

class SplashViewController: UIViewController, SplashDisplayLogic {
    @IBOutlet weak var animatedImageView: UIImageView!
    @IBOutlet weak var loadTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var interactor: SplashBusinessLogic?
    var router: (NSObjectProtocol & SplashRoutingLogic)?
    
    
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
        let interactor            = SplashInteractor()
        let presenter             = SplashPresenter()
        let router                = SplashRouter()
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
        interactor?.makeRequest(request: .loadCurrencies())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func displayData(viewModel: Splash.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .stopLoading():
//            stopRotation()
            animatedImageView.stopAnimating()
            router?.dismiss()
        }
    }
    
    private func setupView() {
//        rotate360Degrees()
        loadTitle.text = R.string.localizable.pleaseWait()
        animate(imageView: animatedImageView, images: [
            R.image.load1()!,
            R.image.load2()!,
            R.image.load3()!,
            R.image.load4()!,
            R.image.load5()!
        ], duration: 0.7)
//        animateTopImageView()
        animate(imageView: imageView, images: [
            R.image.splash()!,
            R.image.splash1()!
        ], duration: 0.4)
    }
    
    func animate(imageView: UIImageView, images: [UIImage], duration: CGFloat) {
        imageView.animationImages = images
        imageView.animationDuration = duration
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    func animateTopImageView() {
        var imageArray = [R.image.splash()!.cgImage!, R.image.splash1()!.cgImage!,R.image.splash()!.cgImage!]
        let animation = CAKeyframeAnimation(keyPath: "contents")
        animation.calculationMode = CAAnimationCalculationMode.linear
        // Make sure this is kCAAnimationLinear or kCAAnimationCubic other mode doesnt consider the timing function
        animation.duration = CFTimeInterval(floatLiteral: 0.8)
        animation.values = imageArray
        animation.repeatCount = .infinity
        // Change it for repetition
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        // To keep the last frame when animation ends
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        imageView.layer.add(animation, forKey: "animation")
    }
    
//    func rotate360Degrees(duration: CFTimeInterval = 1, repeatCount: Float = .infinity) {
//        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotateAnimation.fromValue = 0.0
//        rotateAnimation.toValue = CGFloat(Double.pi * 2)
//        rotateAnimation.isRemovedOnCompletion = false
//        rotateAnimation.duration = duration
//        rotateAnimation.repeatCount = repeatCount
//        imageView.layer.add(rotateAnimation, forKey: nil)
//    }
//
//    // Call this if using infinity animation
//    func stopRotation () {
//        imageView.layer.removeAllAnimations()
//    }
    
    // MARK: - Actions
}

// MARK: - Themed
extension SplashViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        
    }
}
