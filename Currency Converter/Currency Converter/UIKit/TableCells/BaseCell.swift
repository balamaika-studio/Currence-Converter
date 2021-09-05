//
//  BaseCell.swift
//
//  Created by Александр Томашевский on 06.08.2021.
//

import UIKit

class BaseCell: UITableViewCell {
    
    private(set) weak var cellContentView: UIView!
    
    func makeCellContentView() -> UIView {
        let view = UIView()
        view.layer.roundCorners(with: .allCorners, radius: 10)
        view.backgroundColor = .clear
        return view
    }
    
    var cellContentViewInsets: UIEdgeInsets {
        UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
    }
    
    var cellContentViewSize: CGSize? {
        nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        let view = makeCellContentView()
        cellContentView = view
        contentView.addSubview(view)
        backgroundColor = .clear
        cellContentView.ec.edges.constraintsToSuperview(with: cellContentViewInsets)
        if let size = cellContentViewSize {
            cellContentView.ec.size.constraint(size: size)
        }
    }
}
