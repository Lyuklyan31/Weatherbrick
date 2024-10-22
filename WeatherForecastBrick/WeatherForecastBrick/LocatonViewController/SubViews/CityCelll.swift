import SnapKit
import UIKit

class CityCell: UITableViewCell {
    private let cellLabel = UILabel()
    private let backgroundCell = UIView()
    private let chekmark = UIImageView()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubview() {
        cellLabel.font = .systemFont(ofSize: 25, weight: .medium)
        cellLabel.textColor = .black
        cellLabel.numberOfLines = 0
        addSubview(cellLabel)

        cellLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.lessThanOrEqualToSuperview()
            $0.verticalEdges.equalToSuperview().inset(8)
        }

        chekmark.image = UIImage(systemName: "circle")
        chekmark.tintColor = .black
        chekmark.contentMode = .scaleAspectFit
        addSubview(chekmark)

        chekmark.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configuration
    func configure(with cityName: String) {
        cellLabel.text = cityName
    }
    
    func select() {
        chekmark.image = UIImage(systemName: "checkmark.circle.fill")
        chekmark.tintColor = .systemGreen
    }

    func deselect() {
        chekmark.image = UIImage(systemName: "circle")
        chekmark.tintColor = .black
    }
}

