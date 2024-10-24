import UIKit
import SnapKit
import Network

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel = ViewModel()
    
    private let monitor = NWPathMonitor()
    
    private let refreshControl = UIRefreshControl()
    
    private let scrollView = UIScrollView()
    
    private var infoButtonView = ButtonInfoView()
    private let backgroundView = BackgroundView()
    private let infoView = InfoView()
    
    private var gradusLabel = UILabel()
    private let weatherTypeLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    private let locationButton = UIButton()
    private var infoButton = UIButton()
    
    private var placeArrowUIImageView = UIImageView()
    private var magnifyingGlassUIImageView = UIImageView()
    private var brickUIImageVIew = UIImageView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDefaults()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupBackgroundView()
        setupBrickUIImageVIew()
        setupTemperatureLabel()
        setupWeatherTypeLabel()
        setupLocationButton()
        setupInfoButton()
        setupInfoView()
        updateUIForNoInternet()
    }
    
    // MARK: - Default Configuration
    private func configureDefaults() {
        fetchWeatherData()
        setupNetworkMonitor()
    }
    
    // MARK: - Setup BackgroundView
    func setupBackgroundView() {
        view.backgroundColor = .systemBackground
        backgroundView.frame = view.bounds
        view.addSubview(backgroundView)
    }
    
    // MARK: - Brick Image View Setup
    func setupBrickUIImageVIew() {
        brickUIImageVIew.contentMode = .scaleAspectFit
        view.addSubview(brickUIImageVIew)
        
        backgroundView.addSubview(scrollView)
        
        brickUIImageVIew.snp.makeConstraints {
            $0.top.lessThanOrEqualToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
       
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
       
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        brickUIImageVIew.isUserInteractionEnabled = true
        brickUIImageVIew.addGestureRecognizer(panGesture)
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefreshViewController), for: .valueChanged)
    }

    
    // MARK: - Gesture Handling
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        let maxYPosition: CGFloat = 200

        switch gesture.state {
        case .changed:
            let constrainedY = min(max(0, translation.y), maxYPosition)
            brickUIImageVIew.transform = CGAffineTransform(translationX: 0, y: constrainedY)
            
        case .ended, .cancelled:
            if translation.y > 50 {
                refreshControl.beginRefreshing()
                didRefreshViewController()
            }
            UIView.animate(withDuration: 0.3) {
                self.brickUIImageVIew.transform = .identity
            }

        default:
            break
        }
    }
    
    @objc func didRefreshViewController() {
        Task {
             fetchWeatherData()
            refreshControl.endRefreshing()
        }
    }

    
    // MARK: - Temperature Label Setup
    func setupTemperatureLabel() {
        temperatureLabel.textColor = .black
        temperatureLabel.font = UIFont(name: "Ubuntu-Regular", size: 83)
        backgroundView.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(brickUIImageVIew.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(83)
            $0.right.lessThanOrEqualToSuperview()
        }
        
        gradusLabel.text = "0"
        gradusLabel.textColor = .black
        gradusLabel.font = UIFont(name: "Ubuntu-Bold", size: 40)
        temperatureLabel.addSubview(gradusLabel)
        
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
        backgroundView.addSubview(weatherTypeLabel)
        
        weatherTypeLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(58)
            $0.right.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - Location Button Setup
    func setupLocationButton() {
        locationButton.setTitle("\(viewModel.selectedCityName), \(viewModel.selectedContryName)", for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        locationButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 17)
        locationButton.titleLabel?.numberOfLines = 0
        backgroundView.addSubview(locationButton)
        
        locationButton.snp.makeConstraints {
            $0.top.equalTo(weatherTypeLabel.snp.bottom).offset(83)
            $0.centerX.equalToSuperview()
        }
        
        // MARK: - Place Arrow Image View
        placeArrowUIImageView = UIImageView(image: UIImage(resource: .placeArrow))
        backgroundView.addSubview(placeArrowUIImageView)
        
        placeArrowUIImageView.snp.makeConstraints {
            $0.right.equalTo(locationButton.snp.left).offset(-5)
            $0.centerY.equalTo(locationButton)
        }
        
        // MARK: - Magnifying Glass Image View
        magnifyingGlassUIImageView = UIImageView(image: UIImage.iconSearch)
        magnifyingGlassUIImageView.tintColor = .black
        backgroundView.addSubview(magnifyingGlassUIImageView)
        
        magnifyingGlassUIImageView.snp.makeConstraints {
            $0.left.equalTo(locationButton.snp.right).offset(5)
            $0.centerY.equalTo(locationButton)
        }
    }
    
    // MARK: - Setup Show Button Info View
    func setupInfoButton() {
        backgroundView.addSubview(infoButtonView)
        infoButtonView.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(27)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(100)
        }
        
        infoButtonView.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
    }
    
    // MARK: - Info Rectangle View Setup
    private func setupInfoView() {
        backgroundView.addSubview(infoView)
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        infoView.hideAction = { [weak self] in
            self?.hideRectangleView()
        }
    }
    
    // MARK: - Handle Tap
    @objc private func showInfo() {
        showRectangleView()
    }
    
    // MARK: - Show/Hide Animations
    private func showRectangleView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -600)
            self.setOtherViewsAlpha(0.0)
        }, completion: nil)
    }
    
    private func hideRectangleView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.infoView.transform = .identity
            self.setOtherViewsAlpha(1.0)
        }, completion: nil)
    }
    
    // MARK: - Helper Method to Change Alpha of Other Views
    private func setOtherViewsAlpha(_ alpha: CGFloat) {
        weatherTypeLabel.alpha = alpha
        temperatureLabel.alpha = alpha
        locationButton.alpha = alpha
        placeArrowUIImageView.alpha = alpha
        magnifyingGlassUIImageView.alpha = alpha
        brickUIImageVIew.alpha = alpha
        gradusLabel.alpha = alpha
        infoButtonView.alpha = alpha
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
    
    // MARK: - Update UI for No Internet
    func updateUIForNoInternet() {
        DispatchQueue.main.async {
            self.weatherTypeLabel.text = "No Internet"
            self.temperatureLabel.text = "--"
            self.gradusLabel.isHidden = true
            self.brickUIImageVIew.image = UIImage(named: "imageNoInternet")
        }
    }
    
    // MARK: - Setup Network Monitor
    func setupNetworkMonitor() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
        
        monitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied {
                self.updateUIForNoInternet()
            } else {
                self.fetchWeatherData()
                DispatchQueue.main.async {
                    self.gradusLabel.isHidden = false
                }
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
    
    // MARK: - Update Location Button
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
