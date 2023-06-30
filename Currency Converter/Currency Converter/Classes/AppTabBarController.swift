//
//  AppTabBarController.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/25/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
    private var swipeTransition: SwipeTabBarTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupSwipeGesture()
        setUpTheming()
    }
    
    private func setupSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func swiped(_ gesture: UISwipeGestureRecognizer) {
        guard let controllers = viewControllers else {
            return
        }
        var offset = 0
        var newIndex = selectedIndex
        let maxIndex = controllers.count - 1
        
        switch gesture.direction {
        case .left:
            offset = selectedIndex < maxIndex ? 1 : 0
        case .right:
            offset = selectedIndex > 0 ? -1 : 0
        default: break
        }
        
        newIndex += offset
        let newViewController = controllers[newIndex]
        if tabBarController(self, shouldSelect: newViewController) {
            selectedIndex = newIndex
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension AppTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        swipeTransition = SwipeTabBarTransition(viewControllers: tabBarController.viewControllers)
        return swipeTransition
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return swipeTransition?.isTransitionFinished ?? true
    }
}

// MARK: - UITabBarControllerDelegate
extension AppTabBarController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tabBar.tintColor = theme.barTintColor
        tabBar.unselectedItemTintColor = theme.barUnselectedTintColor
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = theme.barBackgroundColor
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
}
