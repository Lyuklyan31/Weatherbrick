import SnapKit
import UIKit

class ButtonInfoView: UIView {

    let rectangleView = UIView()
    let gradientLayer = CAGradientLayer()
    let infolabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRectangle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = rectangleView.bounds
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: rectangleView.bounds,
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: 10, height: 10)).cgPath
        gradientLayer.mask = maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRectangle() {
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
        
        infolabel.text = "INFO"
        infolabel.font = UIFont(name: "Ubuntu-Bold", size: 18)
        infolabel.textColor = .black

        rectangleView.addSubview(infolabel)
        
        infolabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
