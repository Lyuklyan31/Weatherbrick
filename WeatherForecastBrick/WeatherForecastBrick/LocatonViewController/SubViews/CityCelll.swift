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
        backgroundCell.layer.cornerRadius = 12
        backgroundCell.layer.borderWidth = 1.0
        addSubview(backgroundCell)

        backgroundCell.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(60)
        }

        cellLabel.font = .systemFont(ofSize: 20, weight: .medium)
        cellLabel.textColor = .black
        backgroundCell.addSubview(cellLabel)

        cellLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8)
            $0.right.lessThanOrEqualToSuperview()
            $0.verticalEdges.equalToSuperview().inset(8)
        }

        chekmark.image = UIImage(systemName: "circle")
        chekmark.tintColor = .black
        chekmark.contentMode = .scaleAspectFit
        backgroundCell.addSubview(chekmark)

        chekmark.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
    }

    // MARK: - Configuration
    func configure(with cityName: String) {
        cellLabel.text = cityName
    }

    // Функція для вибору комірки
    func select() {
        chekmark.image = UIImage(systemName: "checkmark.circle.fill")
        chekmark.tintColor = .systemGreen
    }

    // Функція для скидання вибору
    func deselect() {
        chekmark.image = UIImage(systemName: "circle")
        chekmark.tintColor = .black
    }
}

