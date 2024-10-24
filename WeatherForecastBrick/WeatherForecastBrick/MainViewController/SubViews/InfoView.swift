import UIKit
import SnapKit

class InfoView: UIView {
    
    private var downRectangleView = UIView()
    private var upperRectangleView = UIView()
    
    private let stackView = UIStackView()
    private let backgroundButtonView = UIView()
    
    private let hideButton = UIButton()
    
    private var hideLabel = UILabel()
    private var infoLabel = UILabel()
    private var rainingLabel = UILabel()
    private var sunnyLabel = UILabel()
    private var fogLabel = UILabel()
    private var veryHotLabel = UILabel()
    private var snowLabel = UILabel()
    private var windyLabel = UILabel()
    private var noInternetLabel = UILabel()
    
    var hideAction: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        
        // MARK: - Setup Down Rectangle View
        downRectangleView.layer.cornerRadius = 10
        downRectangleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        downRectangleView.backgroundColor = .downRectangleOrange
        addSubview(downRectangleView)
        
        downRectangleView.snp.makeConstraints {
            $0.width.equalTo(277)
            $0.height.equalTo(372)
            $0.edges.equalToSuperview()
        }
        
        // MARK: - Setup Upper Rectangle View
        upperRectangleView.layer.cornerRadius = 10
        upperRectangleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        upperRectangleView.backgroundColor = .upperRectangleOrange
        downRectangleView.addSubview(upperRectangleView)
        
        upperRectangleView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(269)
            $0.height.equalTo(372)
        }
        
        // MARK: - Setup Info Label
        infoLabel.text = "INFO"
        infoLabel.font = UIFont(name: "Ubuntu-Bold", size: 18)
        upperRectangleView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(116)
            $0.right.equalToSuperview().offset(-109)
        }
        
        // MARK: - Setup Stack View and Weather Labels
        upperRectangleView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        
        rainingLabel.text = "Brick is wet - raining"
        sunnyLabel.text = "Brick is dry - sunny"
        fogLabel.text = "Brick is hard to see - fog"
        veryHotLabel.text = "Brick with cracks - very hot"
        snowLabel.text = "Brick with snow - snow"
        windyLabel.text = "Brick is swinging - windy"
        noInternetLabel.text = "Brick is gone - No Internet"
        
        let labels = [
            rainingLabel,
            sunnyLabel,
            fogLabel,
            veryHotLabel,
            snowLabel,
            windyLabel,
            noInternetLabel
        ]
        
        labels.forEach {
            $0.font = UIFont(name: "Ubuntu-Regular", size: 15)
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(23)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        // MARK: - Setup Background Button View
        backgroundButtonView.layer.cornerCurve = .continuous
        backgroundButtonView.layer.cornerRadius = 15.5
        backgroundButtonView.layer.borderWidth = 1
        backgroundButtonView.layer.borderColor = UIColor.black.cgColor
        upperRectangleView.addSubview(backgroundButtonView)
        
        backgroundButtonView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom)
            $0.left.equalToSuperview().offset(81)
            $0.height.equalTo(31)
            $0.right.equalToSuperview().offset(-73)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        // MARK: - Setup Hide Button and Label
        hideLabel.text = "Hide"
        hideLabel.font = UIFont(name: "Ubuntu-Medium", size: 15)
        backgroundButtonView.addSubview(hideLabel)
        
        hideLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        backgroundButtonView.addSubview(hideButton)
        hideButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        
        hideButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Button Action
    @objc private func hideButtonTapped() {
        hideAction?()
    }
}
