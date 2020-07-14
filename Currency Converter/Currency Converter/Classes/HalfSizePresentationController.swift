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
    var gestureRecognizer: UITapGestureRecognizer!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let frameHeight: CGFloat = presentingViewController.view.frame.height * 0.5
        return CGRect(x: 0, y: 0,
                      width: containerView.bounds.width,
                      height: frameHeight)
    }
    
    override func presentationTransitionWillBegin() {
        shadowView = UIView(frame: presentingViewController.view.frame)
        shadowView?.accessibilityIdentifier = "shadow"
        shadowView?.backgroundColor = .black
        presentingViewController.view.addSubview(shadowView!)
        
        let frame = frameOfPresentedViewInContainerView
        containerView?.frame = CGRect(x: frame.origin.x,
                                      y: frame.height,
                                      width: frame.width,
                                      height: frame.height)
        setupCloseGesture()
        setUpTheming()
    }
    
    override func dismissalTransitionWillBegin() {
        shadowView?.removeGestureRecognizer(gestureRecognizer)
        shadowView?.removeFromSuperview()
    }
    
    // MARK: Private Methods
    private func setupCloseGesture() {
        gestureRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(gestureHandler))
        shadowView?.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func gestureHandler() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension HalfSizePresentationController: Themed {
    func applyTheme(_ theme: AppTheme) {
        shadowView?.layer.opacity = theme.shadowOpacity
    }
}
