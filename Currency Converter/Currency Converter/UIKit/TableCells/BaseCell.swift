//
//  BaseCell.swift
//
//  Created by Александр Томашевский on 06.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, arrangedViews: [UIView] = []) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        arrangedViews.forEach { addArrangedSubview($0) }
    }
}

extension UITableViewCell {
    
    enum Position {
        case first, last, some, single
    }
    
    func positionInSection(of tableView: UITableView, forRowAt indexPath: IndexPath) -> Position {
        let isFirst = indexPath.row == 0
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        let isLast = indexPath.row == numberOfRows - 1
        switch (isFirst, isLast) {
        case (true, true): return .single
        case (true, false): return .first
        case (false, true): return .last
        case (false, false): return .some
        }
    }
}

protocol Reusable {
    static var reuseId: String { get }
}

protocol ReusableTableViewCell: UITableViewCell, Reusable {
    var reuseDisposeBag: DisposeBag { get }
}

extension ReusableTableViewCell {
    
    static var reuseId: String { String(describing: self) }
}

protocol DisplayableCell {
    func willDisplay(into tableView: UITableView, at indexPath: IndexPath)
}

class TableView: UITableView {
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let displayableCell = cell as? DisplayableCell {
            displayableCell.willDisplay(into: self, at: indexPath)
        }
        return cell
    }
}



class BaseTableCell: UITableViewCell, DisplayableCell, ReusableTableViewCell {
    
    static let separatorDefaultLeadingInset: CGFloat = 16
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var cellInsets: UIEdgeInsets { UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0) }
    
    var contentInsets: UIEdgeInsets { UIEdgeInsets(top: 10, left: 15.0, bottom: 10, right: 15.0) }
    
    var cellHeight: CGFloat? { nil }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let rootStack = UIStackView(axis: .vertical)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(rootStack)
        selectionStyle = .none
        backgroundColor = .clear
        rootStack.ec.edges.constraintsToSuperview(with: .zero)
        let cellWrapper = UIView()
        cellWrapper.backgroundColor = .clear
        rootStack.addArrangedSubview(cellWrapper)
        cellWrapper.addSubview(bgView)
        bgView.ec.edges.constraintsToSuperview(with: cellInsets)
        bgView.addSubview(containerView)
        containerView.ec.edges.constraintsToSuperview(with: contentInsets)
        if let height = cellHeight {
            containerView.ec.size.constraint(height: height)
        }
        rootStack.addArrangedSubview(separatorHStack)
        //bgView.addSubview(rootStack)
        //rootStack.ec.edges.constraintsToSuperview(with: .zero)
//        rootStack.snp.makeConstraints {
//            $0.top.bottom.leading.trailing.equalToSuperview()
//        }
    }
    
    //MARK: - Corners Rounding Mode
    
    enum CornersRoundingMode {
        case never
        case always(radius: CGFloat)
        case roundedBox(radius: CGFloat)
    }
    
    var backgroundCornersRoundingMode: CornersRoundingMode = .always(radius: 10) {
        didSet {
            guard let pos = position else { return }
            refreshBackgroundCorners(with: backgroundCornersRoundingMode, position: pos)
        }
    }
        
    private func refreshBackgroundCorners(with mode: CornersRoundingMode, position: Position) {
        switch mode {
        case .always(let radius): bgView.layer.roundCorners(with: .allCorners, radius: radius)
        case .never: bgView.layer.roundCorners(with: .allCorners, radius: 0)
        case .roundedBox(let radius):
            switch position {
            case .first: bgView.layer.roundCorners(with: .topCorners, radius: radius)
            case .last: bgView.layer.roundCorners(with: .bottomCorners, radius: radius)
            case .single: bgView.layer.roundCorners(with: .allCorners, radius: radius)
            case .some: bgView.layer.roundCorners(with: .allCorners, radius: 0)
            }
        }
    }
    
    //MARK: - ReusableTableViewCell
    
    private(set) var reuseDisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = DisposeBag() // remove all subscriptions before reusing
    }
    
    //MARK: - DisplayableCell
    
    private var position: Position? {
        didSet {
            guard let pos = position else { return }
            refreshSeparator(withDisplayMode: separatorDisplayMode, cellPosition: pos)
            refreshBackgroundCorners(with: backgroundCornersRoundingMode, position: pos)
        }
    }
    
    func willDisplay(into tableView: UITableView, at indexPath: IndexPath) {
        position = positionInSection(of: tableView, forRowAt: indexPath)
    }
    
//    //MARK: - Right Arrow
//
//    private let rightArrowIcon: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "arrowRight")
//        image.contentMode = .center
//        return image
//    }()
//    var showRightArrow = false {
//        didSet {
//            rightArrowIcon.isHidden = !showRightArrow
//        }
//    }
    
    //MARK: - Separator
    
    enum SeparatorDisplayMode {
        case never, always, alwaysButLast
    }
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = separatorColor
        return view
    }()
    
    var separatorDisplayMode: SeparatorDisplayMode = .alwaysButLast {
        didSet {
            guard let position = self.position else { return }
            refreshSeparator(withDisplayMode: separatorDisplayMode, cellPosition: position)
        }
    }
    
    var separatorColor: UIColor = .gray {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    var separatorHeight: CGFloat = 1 {
        didSet {
            separatorHeightConstraint?.value(separatorHeight)
        }
    }
    
    private var separatorHeightConstraint: EaseConstraints.Constraint?
    
    private lazy var separatorHStack: UIStackView = {
        let leadingView = UIView()
        let stack = UIStackView(axis: .horizontal, arrangedViews: [leadingView, separatorView])
        leadingView.ec.size.constraint(width: 0)
        //leadingView.snp.makeConstraints { $0.width.equalTo(0) }
        stack.setCustomSpacing(separatorLeadingInset, after: leadingView)
        separatorHeightConstraint = stack.ec.size.constraint(height: separatorHeight).priority(.defaultHigh)
        //stack.snp.makeConstraints { $0.height.equalTo(1).priority(.high) }
        return stack
    }()
    
    var separatorLeadingInset: CGFloat = 16 {
        didSet {
            separatorHStack.setCustomSpacing(separatorLeadingInset, after: separatorHStack.arrangedSubviews[0])
        }
    }
    
    private func refreshSeparator(withDisplayMode mode: SeparatorDisplayMode, cellPosition position: Position) {
        switch mode {
        case .never: separatorHStack.isHidden = true
        case .always: separatorHStack.isHidden = false
        case .alwaysButLast:
            let hide: Bool
            switch position {
            case .last, .single: hide = true
            default: hide = false
            }
            separatorHStack.isHidden = hide
        }
    }
}
