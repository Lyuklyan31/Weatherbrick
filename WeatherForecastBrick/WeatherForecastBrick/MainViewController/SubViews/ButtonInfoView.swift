import SnapKit
import UIKit

//MARK: - InfoView
class ButtonInfoView: UIView {

    // MARK: - UI Elements
    private let rectangleView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let infoLabel = UILabel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRectangle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = rectangleView.bounds
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: rectangleView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 10, height: 10)
        ).cgPath
        gradientLayer.mask = maskLayer
    }
    
    // MARK: - Setup Methods
    private func setupRectangle() {
        gradientLayer.colors = [
            UIColor.orangeTop.cgColor,
            UIColor.orangeBottom.cgColor
        ]
        
        rectangleView.layer.insertSublayer(gradientLayer, at: 0)
        rectangleView.layer.cornerRadius = 10
        rectangleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        rectangleView.clipsToBounds = true
        addSubview(rectangleView)
        
        rectangleView.snp.makeConstraints {
            $0.height.equalTo(65)
            $0.edges.equalToSuperview()
        }
        
        infoLabel.text = "INFO"
        infoLabel.font = UIFont(name: "Ubuntu-Bold", size: 18)
        infoLabel.textColor = .black
        rectangleView.addSubview(infoLabel)

        infoLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
