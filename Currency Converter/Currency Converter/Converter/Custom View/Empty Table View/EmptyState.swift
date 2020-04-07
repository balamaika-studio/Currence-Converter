//
//  EmptyState.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/7/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class EmptyState: UIView {

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    // MARK: - Private Methods
    private func loadViewFromNib() {
        let view = R.nib.emptyState(owner: self)!
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
