

import UIKit

public class Type2SectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!

// MARK: - Methods

    public func updateTitle(_ string: String) {
        titleLabel.text = string
    }
}
