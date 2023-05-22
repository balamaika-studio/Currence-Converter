//
//  AppNavigationController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/25/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    private var themedStatusBarStyle: UIStatusBarStyle?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? super.preferredStatusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpTheming()
    }
    
    func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

extension AppNavigationController: Themed {
    func applyTheme(_ theme: AppTheme) {
//        navigationBar.tintColor = .white
        // gradient
//        var startColor: UIColor!
//        var endColor: UIColor!
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//
//        switch theme {
//        case .light:
//            startColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
//            endColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
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
//        if let image = getImageFrom(gradientLayer: gradient) {
//            navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
//        }
//        themedStatusBarStyle = .lightContent
//        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
