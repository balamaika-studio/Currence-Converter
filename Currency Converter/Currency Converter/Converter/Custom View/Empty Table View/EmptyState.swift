//
//  EmptyState.swift
//  Currency Converter
//
//  Created by Кирилл Клименков on 4/7/20.
//  Copyright © 2020 Kiryl Klimiankou. All rights reserved.
//

import UIKit

class EmptyState: UIView {
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var contentView: UIView!
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupView()
        setUpTheming()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        setupView()
        setUpTheming()
    }
    
    // MARK: - Private Methods
    private func loadViewFromNib() {
        let view = R.nib.emptyState(owner: self)!
        contentView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupView() {
        titleLabel.text = R.string.localizable.emptyStateTitle()
    }

}

extension EmptyState: Themed {
    func applyTheme(_ theme: AppTheme) {
        let emptyImage = theme == .light ?
            R.image.emptyTableViewLight() :
            R.image.emptyTableViewDark()
        titleLabel.textColor = theme.textColor
        contentView.backgroundColor = theme.backgroundColor
        emptyImageView.image = emptyImage
    }
}
