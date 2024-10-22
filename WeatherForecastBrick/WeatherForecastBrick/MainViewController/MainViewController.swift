import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel = ViewModel()
    
    private let backgroundView = BackgroundView()
    private let temperatureLabel = UILabel()
    private let weatherTypeLabel = UILabel()
    private let locationButton = UIButton()
    private var placeArrowUIImageView = UIImageView()
    private var magnifyingGlassUIImageView = UIImageView()
    private var brickUIImageVIew = UIImageView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackroundView()
        setupLocationButton()
        setupWeatherTypeLabel()
        setupTemperatureLabel()
        setupBrickUIImageVIew()
    }
    
    // MARK: - Setup Methods
    func setupBackroundView() {
        view.backgroundColor = .systemBackground
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupBrickUIImageVIew() {
        
        
        view.addSubview(brickUIImageVIew)
        
        brickUIImageVIew.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        Task {
            do {
                let weather = try await viewModel.getWeather()
                let tempInCelsius = kelvinToCelsius(weather.main.temp)
                temperatureLabel.text = "\(tempInCelsius)°"
                let weatherConditions = weather.weather
                weatherTypeLabel.text = weatherConditions[0].main
                brickUIImageVIew.image = getWeatherImage(for: weatherConditions[0].main, temperature: tempInCelsius)
            } catch {
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    
    func setupTemperatureLabel() {
        temperatureLabel.textColor = .black
        temperatureLabel.font = .systemFont(ofSize: 63, weight: .bold)
        
        view.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.bottom.equalTo(weatherTypeLabel.snp.top)
            $0.top.greaterThanOrEqualToSuperview()
            $0.right.greaterThanOrEqualToSuperview()
        }
        
        Task {
            do {
                let weather = try await viewModel.getWeather()
                let tempInCelsius = kelvinToCelsius(weather.main.temp)
                temperatureLabel.text = "\(tempInCelsius)°"
            } catch {
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    
    func setupWeatherTypeLabel() {
        weatherTypeLabel.textColor = .black
        weatherTypeLabel.font = .systemFont(ofSize: 36, weight: .light)
        
        view.addSubview(weatherTypeLabel)
        
        weatherTypeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalTo(locationButton.snp.top).offset(-74)
            $0.right.lessThanOrEqualToSuperview()
            
        }
        
        Task {
            do {
                let weather = try await viewModel.getWeather()
                let weatherConditions = weather.weather
                weatherTypeLabel.text = weatherConditions[0].main
                
            } catch {
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    
    func setupLocationButton() {
        
        locationButton.setTitle("\(viewModel.selectedCityName), \(viewModel.selectedContryName)", for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        locationButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold) // Font
        locationButton.titleLabel?.numberOfLines = 0
        
        view.addSubview(locationButton)
        
        locationButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-57)
        }
        
        placeArrowUIImageView = UIImageView(image: UIImage(resource: .placeArrow))
        
        view.addSubview(placeArrowUIImageView)
        
        placeArrowUIImageView.snp.makeConstraints {
            $0.right.equalTo(locationButton.snp.left).offset(-5)
            $0.centerY.equalTo(locationButton)
            $0.width.height.equalTo(24)
            $0.left.greaterThanOrEqualToSuperview().offset(16)
        }
        
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
        Task {
            do {
                let weather = try await viewModel.getWeather()
                let weatherConditions = weather.weather
                weatherTypeLabel.text = weatherConditions[0].main
                let tempInCelsius = kelvinToCelsius(weather.main.temp)
                temperatureLabel.text = "\(tempInCelsius)°"
                brickUIImageVIew.image = getWeatherImage(for: weatherConditions[0].main, temperature: tempInCelsius)
            } catch {
                print("Error fetching weather: \(error.localizedDescription)")
            }
        }
    }
    
    func kelvinToCelsius(_ kelvin: Double) -> Int {
        return Int(kelvin - 273.15)
    }
    func getWeatherImage(for weatherType: String, temperature: Int) -> UIImage? {
        switch weatherType {
        case "Snow":
            return UIImage(resource: .imageStoneSnow)
        case "Rain":
            return UIImage(resource: .imageStoneWet)
        case "Clear":
            if temperature > 30 {
                return UIImage(resource: .imageStoneCracks)
            } else {
                return UIImage(resource: .imageStoneNormal)
            }
        default:
            return UIImage(resource: .imageStoneNormal)
        }
    }
}

enum TypeWeather {
    case sunny
    case rainy
    case snow
    case hot
    
    var image: UIImage {
        switch self {
        case .sunny:
                .imageStoneNormal
        case .rainy:
                .imageStoneWet
        case .snow:
                .imageStoneSnow
        case .hot:
                .imageStoneCracks
        }
    }
}
