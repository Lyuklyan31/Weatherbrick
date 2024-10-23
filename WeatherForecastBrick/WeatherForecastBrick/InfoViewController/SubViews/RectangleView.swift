//
//  RectangleView.swift
//  WeatherForecastBrick
//
//  Created by Mac on 23.10.2024.
//

import UIKit

class RectangleView: UIView {
    
    private var downRectangleView = UIView()
    private var upperRectangleView = UIView()
    
    private let stackView = UIStackView()
    
    private var infoLabel = UILabel()
    private var rainingLabel = UILabel()
    private var sunnyLabel = UILabel()
    private var fogLabel = UILabel()
    private var veryHotLable = UILabel()
    private var snowLable = UILabel()
    private var windyLabel = UILabel()
    private var noInternetLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRectangles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRectangles() {
        
        downRectangleView.layer.cornerRadius = 10
        downRectangleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        downRectangleView.backgroundColor = .downRectangleOrange
        
        addSubview(downRectangleView)
        
        downRectangleView.snp.makeConstraints {
            $0.width.equalTo(277)
            $0.height.equalTo(372)
            $0.edges.equalToSuperview()
        }
        
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
        
        infoLabel.text = "INFO"
        infoLabel.font = UIFont(name: "Ubuntu-Bold", size: 18)
        
        upperRectangleView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        upperRectangleView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        rainingLabel.text = "Brick is wet - raining"
        sunnyLabel.text = "Brick is dry - sunny "
        fogLabel.text = "Brick is hard to see - fog"
        veryHotLable.text = "Brick with cracks - very hot "
        snowLable.text = "Brick with snow - snow"
        windyLabel.text = "Brick is swinging- windy"
        noInternetLabel.text = "Brick is gone - No Internet "
        
        [rainingLabel, sunnyLabel, fogLabel, veryHotLable, snowLable, windyLabel, noInternetLabel].forEach {
            $0.font = UIFont(name: "Ubuntu-Regular", size: 17)
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(23)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }

    }
}
