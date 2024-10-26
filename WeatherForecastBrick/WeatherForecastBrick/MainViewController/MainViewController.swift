import UIKit
import SnapKit
import Network

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel = WeatherLocationViewModel()
    
    private var infoButtonView = ButtonInfoView()
    private let backgroundView = BackgroundView()
    private let infoView = InfoView()
    
    private let monitor = NWPathMonitor()
    
    private var gradusLabel = UILabel()
    private let weatherTypeLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    private let refreshControl = UIRefreshControl()
    private let scrollView = UIScrollView()
    
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
        navigationController?.setNavigationBarHidden(true, animated: false)
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
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(brickUIImageVIew.snp.edges)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        brickUIImageVIew.isUserInteractionEnabled = true
        brickUIImageVIew.addGestureRecognizer(panGesture)
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshViewController), for: .valueChanged)
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
                refreshViewController()
            }
            UIView.animate(withDuration: 0.3) {
                self.brickUIImageVIew.transform = .identity
            }
            
        default:
            break
        }
    }
    
    @objc func refreshViewController() {
        Task {
            fetchWeatherData()
            setupNetworkMonitor()
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
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(83)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        gradusLabel.text = "0"
        gradusLabel.textColor = .black
        gradusLabel.font = UIFont(name: "Ubuntu-Bold", size: 40)
        backgroundView.addSubview(gradusLabel)
        
        gradusLabel.snp.makeConstraints {
            $0.top.equalTo(brickUIImageVIew.snp.bottom)
            $0.leading.equalTo(temperatureLabel.snp.trailing).offset(-3)
        }
    }
    
    // MARK: - Weather Type Label Setup
    func setupWeatherTypeLabel() {
        weatherTypeLabel.textColor = .black
        weatherTypeLabel.font = UIFont(name: "Ubuntu-Light", size: 36)
        backgroundView.addSubview(weatherTypeLabel)
        
        weatherTypeLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(58)
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - Location Button Setup
    func setupLocationButton() {
        locationButton.setTitle("\(viewModel.selectedCityName), \(viewModel.selectedCountryName)", for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        locationButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 17)
        locationButton.titleLabel?.numberOfLines = 0
        backgroundView.addSubview(locationButton)
        
        locationButton.snp.makeConstraints {
            $0.top.equalTo(weatherTypeLabel.snp.bottom).offset(120)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        // MARK: - Place Arrow Image View
        placeArrowUIImageView = UIImageView(image: UIImage(resource: .placeArrow))
        backgroundView.addSubview(placeArrowUIImageView)
        
        placeArrowUIImageView.snp.makeConstraints {
            $0.trailing.equalTo(locationButton.snp.leading).offset(-5)
            $0.centerY.equalTo(locationButton)
        }
        
        // MARK: - Magnifying Glass Image View
        magnifyingGlassUIImageView = UIImageView(image: UIImage.iconSearch)
        magnifyingGlassUIImageView.tintColor = .black
        backgroundView.addSubview(magnifyingGlassUIImageView)
        
        magnifyingGlassUIImageView.snp.makeConstraints {
            $0.leading.equalTo(locationButton.snp.trailing).offset(5)
            $0.centerY.equalTo(locationButton)
        }
    }
    
    // MARK: - Setup Show Button Info View
    func setupInfoButton() {
        backgroundView.addSubview(infoButtonView)
        infoButtonView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(locationButton.snp.bottom).offset(30)
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
            self.setAdditionalViewsAlpha(0.0)
        }, completion: nil)
    }
    
    private func hideRectangleView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.infoView.transform = .identity
            self.setAdditionalViewsAlpha(1.0)
        }, completion: nil)
    }
    
    // MARK: - Helper Method to Change Alpha of Other Views
    private func setAdditionalViewsAlpha(_ alpha: CGFloat) {
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
                let weatherData = try await viewModel.getWeather()
                let tempInCelsius = weatherData.main.temp.kelvinToCelsius()
                temperatureLabel.text = "\(tempInCelsius)"

                let weatherConditions = weatherData.weather
                
                if let firstCondition = weatherConditions.first {
                    let weatherType = getWeatherType(from: firstCondition.main.rawValue, temperature: tempInCelsius)
                    brickUIImageVIew.image = weatherType.image
                    weatherTypeLabel.text =  weatherType.rawValue
                }
            }
        }
    }
    
    // MARK: - Update UI for No Internet
    func updateUIForNoInternet() {
        DispatchQueue.main.async {
            self.weatherTypeLabel.text = "No Internet"
            self.temperatureLabel.text = "--"
            self.gradusLabel.isHidden = true
            self.brickUIImageVIew.image = UIImage(resource: .imageNoInternet)
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
               self?.dismiss(animated: true, completion: nil)
           }
        self.present(locationViewController, animated: true, completion: nil)
    }
    
    // MARK: - Update Location Button
    func updateLocationButton() {
        locationButton.setTitle("\(viewModel.selectedCityName), \(viewModel.selectedCountryName)", for: .normal)
        fetchWeatherData()
    }
    
    // MARK: - Weather Type Handling
    func getWeatherType(from condition: String, temperature: Int) -> WeatherTypes {
        if temperature > 30 {
            return .hot
        }
        
        return WeatherTypes(rawValue: condition.capitalized) ?? .clear
    }
}
