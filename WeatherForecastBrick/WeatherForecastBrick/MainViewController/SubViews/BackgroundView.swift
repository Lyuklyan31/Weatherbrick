import UIKit

//MARK: - BackgroundView
class BackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Gradient
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = [
            UIColor.lineaGradientYellow.withAlphaComponent(0.30).cgColor,
            UIColor.lineaGradientBlue.withAlphaComponent(0.30).cgColor
        ]
        
        gradientLayer.locations = [0.4, 0.6]
        
        self.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.first?.frame = self.bounds
    }
}
