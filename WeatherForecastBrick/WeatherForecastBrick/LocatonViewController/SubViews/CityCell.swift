import SnapKit
import UIKit

//MARK: - CityCell
class CityCell: UITableViewCell {
    private let cellLabel = UILabel()
    private let backgroundCell = UIView()
    private let cheсkmark = UIImageView()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Subviews
    func setupSubviews() {
        cellLabel.font = .systemFont(ofSize: 25, weight: .medium)
        cellLabel.textColor = .black
        cellLabel.numberOfLines = 0
        addSubview(cellLabel)

        cellLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.verticalEdges.equalToSuperview().inset(8)
        }

        cheсkmark.image = UIImage(systemName: "circle")
        cheсkmark.tintColor = .black
        cheсkmark.contentMode = .scaleAspectFit
        addSubview(cheсkmark)

        cheсkmark.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configuration
    func configure(with cityName: String) {
        cellLabel.text = cityName
    }
    
    func applyCheckedLook() {
        cheсkmark.image = UIImage(systemName: "checkmark.circle.fill")
        cheсkmark.tintColor = .systemGreen
    }

    func applyUncheckedLook() {
        cheсkmark.image = UIImage(systemName: "circle")
        cheсkmark.tintColor = .black
    }
}

