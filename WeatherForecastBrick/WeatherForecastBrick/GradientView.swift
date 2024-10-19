import UIKit

class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        // Кольори градієнту
        gradientLayer.colors = [
            UIColor.lineaGradientYellow.withAlphaComponent(0.3).cgColor,
            UIColor.lineaGradientBlue.withAlphaComponent(0.3).cgColor
        ]
        
        // Розділяємо градієнт посередині
        gradientLayer.locations = [0.0, 1.0]
        
        // Зміна напрямку градієнту зверху вниз
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
