//
//  AppNavigationController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/25/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

//import UIKit
//
//class AppNavigationController: UINavigationController {
//    private var themedStatusBarStyle: UIStatusBarStyle?
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return themedStatusBarStyle ?? super.preferredStatusBarStyle
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setUpTheming()
//    }
//
//    func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage {
//        UIGraphicsImageRenderer(size: gradientLayer.frame.size).image { context in
//            let cgCxt = context.cgContext
//            cgCxt.concatenate(CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -gradientLayer.bounds.height))
//            gradientLayer.render(in: cgCxt)
//        }
//    }
//}
//
//extension AppNavigationController: Themed {
//    func applyTheme(_ theme: AppTheme) {
//        navigationBar.tintColor = .white
//        // gradient
//        var startColor: UIColor!
//        var endColor: UIColor!
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//
//        switch theme {
//        case .light:
//            startColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
//            endColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
//        case .dark:
//            startColor = theme.backgroundColor
//            endColor = theme.backgroundColor
//        default: break
//        }
//
//        let gradient = CAGradientLayer()
//        var bounds = navigationBar.bounds
//        bounds.size.height += statusBarHeight
//        gradient.frame = bounds
//        gradient.colors = [startColor.cgColor, endColor.cgColor]
//        gradient.startPoint = CGPoint(x: 0, y: 0)
//        gradient.endPoint = CGPoint(x: 0, y: 1)
//        let titleTextAttrs = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        let image = getImageFrom(gradientLayer: gradient)
//        if #available(iOS 13.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.titleTextAttributes = titleTextAttrs
//            appearance.backgroundImage = image
//            //appearance.backgroundEffect = nil
//            //appearance.backgroundColor = .blue
//            navigationBar.standardAppearance = appearance
//            navigationBar.scrollEdgeAppearance = appearance
//        } else {
//            navigationBar.setBackgroundImage(image, for: .default)
//            navigationBar.titleTextAttributes = titleTextAttrs
//        }
//        themedStatusBarStyle = .lightContent
//    }
//}
