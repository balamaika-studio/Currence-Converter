//
//  HalfSizePresentationController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/25/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

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
        presentingViewController.view.addSubview(shadowView!)
        setUpTheming()
    }
    
    override func dismissalTransitionWillBegin() {
        shadowView?.removeFromSuperview()
    }
}

extension HalfSizePresentationController: Themed {
    func applyTheme(_ theme: AppTheme) {
        shadowView?.layer.opacity = theme.shadowOpacity
    }
}
