import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel = ViewModel()
    
    private var buttonInfoView = ButtonInfoView()
    private let backgroundView = BackgroundView()
    private let rectangleView = RectangleView()
    
    private var gradusLabel = UILabel()
    private let weatherTypeLabel = UILabel()
    private let temperatureLabel = UILabel()
   
    private let locationButton = UIButton()
    private var buttonInfoButton = UIButton()
    
    private var placeArrowUIImageView = UIImageView()
    private var magnifyingGlassUIImageView = UIImageView()
    private var brickUIImageVIew = UIImageView()
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDefaults()
        updateLocationButton()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        setupBackroundView()
        setupLocationButton()
        setupWeatherTypeLabel()
        setupTemperatureLabel()
        setupBrickUIImageVIew()
        setupButtonInfoView()
        setupRectangleView()
    }
    
    // MARK: - Default Configuration
    private func configureDefaults() {
        fetchWeatherData()
    }
    
    // MARK: - Background View Setup
    func setupBackroundView() {
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Brick Image View Setup
    func setupBrickUIImageVIew() {
        brickUIImageVIew.contentMode = .scaleAspectFit
        view.addSubview(brickUIImageVIew)
        
        brickUIImageVIew.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-30)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Temperature Label Setup
    func setupTemperatureLabel() {
        temperatureLabel.textColor = .black
        temperatureLabel.font = UIFont(name: "Ubuntu-Regular", size: 83)
        view.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalTo(weatherTypeLabel.snp.top)
        }
        
        gradusLabel.text = "0"
        gradusLabel.textColor = .black
        gradusLabel.font = UIFont(name: "Ubuntu-Bold", size: 40)
        
        view.addSubview(gradusLabel)
        
        gradusLabel.snp.makeConstraints {
            $0.left.equalTo(temperatureLabel.snp.right).offset(-3)
            $0.centerY.equalTo(temperatureLabel).offset(-31.5)
            $0.width.greaterThanOrEqualTo(20)
        }
    }
    
    // MARK: - Weather Type Label Setup
    func setupWeatherTypeLabel() {
        weatherTypeLabel.textColor = .black
        weatherTypeLabel.font = UIFont(name: "Ubuntu-Light", size: 36)
        view.addSubview(weatherTypeLabel)
        
        weatherTypeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalTo(locationButton.snp.top).offset(-100)
            $0.right.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - Location Button Setup
    func setupLocationButton() {
        // MARK: Properties
        locationButton.setTitle("\(viewModel.selectedCityName), \(viewModel.selectedContryName)", for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        locationButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 17)
        locationButton.titleLabel?.numberOfLines = 0
        
        view.addSubview(locationButton)
        
        // MARK: Constraints
        locationButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        // MARK: - Place Arrow Image View
        placeArrowUIImageView = UIImageView(image: UIImage(resource: .placeArrow))
        view.addSubview(placeArrowUIImageView)
        
        placeArrowUIImageView.snp.makeConstraints {
            $0.right.equalTo(locationButton.snp.left).offset(-5)
            $0.centerY.equalTo(locationButton)
            $0.width.height.equalTo(24)
            $0.left.greaterThanOrEqualToSuperview().offset(16)
        }
        
        // MARK: - Magnifying Glass Image View
        magnifyingGlassUIImageView = UIImageView(image: UIImage.iconSearch)
        magnifyingGlassUIImageView.tintColor = .black
        view.addSubview(magnifyingGlassUIImageView)
        
        magnifyingGlassUIImageView.snp.makeConstraints {
            $0.left.equalTo(locationButton.snp.right).offset(5)
            $0.centerY.equalTo(locationButton)
            $0.width.height.equalTo(26)
            $0.right.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    //MARK: - Info Rectangle View
    
    private func setupRectangleView() {
        
        rectangleView.isHidden = false
        
        view.addSubview(rectangleView)
        
        rectangleView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }

    
    // MARK: - Button Info View Setup
    func setupButtonInfoView() {
        view.addSubview(buttonInfoView)
        
        buttonInfoView.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(27)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(100)
        }
        
        buttonInfoView.addSubview(buttonInfoButton)
        
        buttonInfoButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        buttonInfoButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    // MARK: - Handle Tap
    @objc private func handleTap() {
        if rectangleView.frame.origin.y >= view.frame.height {
            showRectangleView()
        } else {
            hideRectangleView()
        }
    }

    // MARK: - Show/Hide Animations
    private func showRectangleView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.rectangleView.transform = CGAffineTransform(translationX: 0, y: -600)
            self.setOtherViewsAlpha(0.0)
        }, completion: nil)
    }

    private func hideRectangleView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.rectangleView.transform = .identity
            self.setOtherViewsAlpha(1.0)
        }, completion: nil)
    }

    // MARK: - Helper method to change alpha of other views
    private func setOtherViewsAlpha(_ alpha: CGFloat) {
        self.weatherTypeLabel.alpha = alpha
        self.temperatureLabel.alpha = alpha
        self.locationButton.alpha = alpha
        self.placeArrowUIImageView.alpha = alpha
        self.magnifyingGlassUIImageView.alpha = alpha
        self.brickUIImageVIew.alpha = alpha
        self.gradusLabel.alpha = alpha
    }
    
    // MARK: - Weather Data Fetching
    func fetchWeatherData() {
        Task {
            do {
                let weather = try await viewModel.getWeather()
                let tempInCelsius = kelvinToCelsius(weather.main.temp)
                temperatureLabel.text = "\(tempInCelsius)"
                let weatherConditions = weather.weather
                
                if let firstCondition = weatherConditions.first {
                    let weatherType = getWeatherType(from: firstCondition.main.lowercased(), temperature: tempInCelsius)
                    brickUIImageVIew.image = weatherType.image
                    weatherTypeLabel.text = firstCondition.main
                }
            } catch {
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Actions
    @objc func openSheet() {
        let locationViewController = LocationViewController(viewModel: self.viewModel)
        locationViewController.modalPresentationStyle = .pageSheet
        locationViewController.onCitySelected = { [weak self] in
            self?.updateLocationButton()
        }
        self.present(locationViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Update Methods
    func updateLocationButton() {
        locationButton.setTitle("\(viewModel.selectedCityName), \(viewModel.selectedContryName)", for: .normal)
        fetchWeatherData()
    }
    
    // MARK: - Temperature Conversion
    func kelvinToCelsius(_ kelvin: Double) -> Int {
        return Int(kelvin - 273.15)
    }
    
    // MARK: - Weather Type Handling
    func getWeatherType(from condition: String, temperature: Int) -> WeatherType {
        if temperature > 30 {
            return .hot
        }
        
        if temperature < 0 {
            return .snow
        }
        
        
        switch condition.lowercased() {
        case "thunderstorm":
            return .thunderstorm
        case "drizzle":
            return .drizzle
        case "rain":
            return .rain
        case "snow":
            return .snow
        case "clear":
            return .clear
        case "clouds":
            return .clouds
        case "mist":
            return .mist
        case "fog":
            return .fog
        case "squall":
            return .squall
        default:
            return .clear
        }
    }
}
