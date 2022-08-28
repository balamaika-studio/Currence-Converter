
import UIKit

protocol ExchangeCurrenciesViewsDelegate {

}


class ExchangeCurrenciesViews: UIView {
    // MARK: - UI

    @IBOutlet weak var currencyLeftView: UIView!
    @IBOutlet weak var leftCurrencyImageView: UIImageView!
    @IBOutlet weak var leftCurrencyCodeLabel: UILabel!
    @IBOutlet weak var leftCurrencyNameLabel: UILabel!

    @IBOutlet weak var currencyRightView: UIView!
    @IBOutlet weak var rightCurrencyImageView: UIImageView!
    @IBOutlet weak var rightCurrencyCodeLabel: UILabel!
    @IBOutlet weak var rightCurrencyNameLabel: UILabel!

    // MARK: - Properties
    private var contentView: UIView!
    private var isLeftSelected: Bool = true {
        didSet {
            if isLeftSelected {
                configureLeftViewSelected()
            } else {
                configureRightViewSelected()
            }
        }
    }
    private var leftCurrency: FavoriteViewModel? = FavoriteViewModel(
        currency: "USD",
        title: "US Dollar",
        isSelected: true
    )
    private var rightCurrency: FavoriteViewModel? = FavoriteViewModel(
        currency: "EUR",
        title: "European Euro",
        isSelected: true
    )
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setUpTheming()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
        setUpTheming()
    }

    public func configureView() {
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(self.handleTapLeft(_:)))
        currencyLeftView.addGestureRecognizer(tapLeft)

        let tapRight = UITapGestureRecognizer(target: self, action: #selector(self.handleTapRight(_:)))
        currencyRightView.addGestureRecognizer(tapRight)

        let emptyFlag = R.image.emptyFlag()
        let leftImage = UIImage(named: leftCurrency?.currency.lowercased() ?? "") ?? emptyFlag
        currencyLeftView.layer.cornerRadius = 10
        currencyLeftView.layer.borderColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        currencyLeftView.layer.borderWidth = 1
        leftCurrencyCodeLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        leftCurrencyNameLabel.textColor = #colorLiteral(red: 0.662745098, green: 0.6705882353, blue: 0.7019607843, alpha: 1)
        leftCurrencyImageView.image = leftImage
        leftCurrencyCodeLabel.text = leftCurrency?.currency
        leftCurrencyNameLabel.text = leftCurrency?.title

        let rightImage = UIImage(named: rightCurrency?.currency.lowercased() ?? "") ?? emptyFlag
        currencyRightView.layer.cornerRadius = 10
        currencyRightView.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        currencyRightView.layer.borderWidth = 1
        rightCurrencyCodeLabel.textColor = #colorLiteral(red: 0.662745098, green: 0.6705882353, blue: 0.7019607843, alpha: 1)
        rightCurrencyNameLabel.textColor = #colorLiteral(red: 0.662745098, green: 0.6705882353, blue: 0.7019607843, alpha: 1)
        rightCurrencyImageView.image = rightImage
        rightCurrencyCodeLabel.text = rightCurrency?.currency
        rightCurrencyNameLabel.text = rightCurrency?.title
    }

    public func setCurrency(viewModel: FavoriteViewModel) {
        let emptyFlag = R.image.emptyFlag()
        let image = UIImage(named: viewModel.currency.lowercased()) ?? emptyFlag

        if isLeftSelected {
            leftCurrencyNameLabel.text = viewModel.title
            leftCurrencyCodeLabel.text = viewModel.currency
            leftCurrencyImageView.image = image
            leftCurrency = viewModel
        } else {
            rightCurrencyNameLabel.text = viewModel.title
            rightCurrencyCodeLabel.text = viewModel.currency
            rightCurrencyImageView.image = image
            rightCurrency = viewModel
        }
    }

    public func getCurrencies() -> Relative? {
        guard let leftCurrency = leftCurrency,
              let rightCurrency = rightCurrency else {
                  return nil
              }

        return Relative(
            base: leftCurrency.currency,
            relative: rightCurrency.currency,
            isSelected: true
        )
    }
    
    // MARK: - Actions
    @objc func handleTapLeft(_ sender: UITapGestureRecognizer? = nil) {
        isLeftSelected = true
    }

    @objc func handleTapRight(_ sender: UITapGestureRecognizer? = nil) {
        isLeftSelected = false
    }

    // MARK: - Private Methods
    private func loadViewFromNib() {
        let view = R.nib.exchangeCurrenciesViews(owner: self)!
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

    private func configureLeftViewSelected() {
        currencyRightView.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        currencyLeftView.layer.borderColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)

        leftCurrencyCodeLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        rightCurrencyCodeLabel.textColor = #colorLiteral(red: 0.662745098, green: 0.6705882353, blue: 0.7019607843, alpha: 1)
    }

    private func configureRightViewSelected() {
        currencyLeftView.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        currencyRightView.layer.borderColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)

        rightCurrencyCodeLabel.textColor = #colorLiteral(red: 0.1921568627, green: 0.3960784314, blue: 0.9843137255, alpha: 1)
        leftCurrencyCodeLabel.textColor = #colorLiteral(red: 0.662745098, green: 0.6705882353, blue: 0.7019607843, alpha: 1)
    }
}

extension ExchangeCurrenciesViews: ExchangeCurrenciesViewsDelegate {

}


extension ExchangeCurrenciesViews: Themed {
    func applyTheme(_ theme: AppTheme) {
    }
}
