import UIKit
import Combine
import SnapKit

// MARK: - LocationViewController
class LocationViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: WeatherLocationViewModel
    
    // MARK: - UI Elements
    private let searchTextField = UISearchTextField()
    private let tableView = UITableView()
    private let backgroundView = UIView()
    
    // MARK: - Variables
    private var selectedIndexPath: IndexPath?
    private var dataSource: UITableViewDiffableDataSource<Int, WeatherLocationViewModel.City>!
    private var cancellables = Set<AnyCancellable>()
    
    var onCitySelected: (() -> Void)?
    
    // MARK: - Initializer
    init(viewModel: WeatherLocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        setupUI()
    }
    
    // MARK: - Configure Defaults
    private func configureDefaults() {
        setupDataSource()
        setupBinding()
        fetchCities()
    }
    
    // MARK: - Binding Setup
    private func setupBinding() {
        // Search Text Field Publisher
        searchTextField.textPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                Task {
                    await self?.viewModel.fetchCities(for: text)
                }
            }
            .store(in: &cancellables)
        
        // View Model Publishers
        viewModel.$city
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.searchTextField.text = ("\(location.cityName), \(location.countryName)")
            }
            .store(in: &cancellables)
        
        // Cities Publisher
        viewModel.$cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applySnapshot()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchTextField)
        searchTextField.placeholder = "Enter city name"
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.textColor = .black
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        tableView.delegate = self
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
    }
    
    // MARK: - Fetch Cities
    func fetchCities() {
        Task {
            await viewModel.fetchCities(for: searchTextField.text ?? "")
        }
    }
    
    // MARK: - Data Source Setup
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, WeatherLocationViewModel.City>(tableView: tableView) { [self] tableView, indexPath, cityData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell else { return UITableViewCell() }
            
            cell.configure(with: "\(cityData.cityName), \(cityData.countryName)")
            
            if cityData == viewModel.city {
                cell.applyCheckedLook()
            } else {
                cell.applyUncheckedLook()
            }
            return cell
        }
    }
    
    // MARK: - Snapshot Handling
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, WeatherLocationViewModel.City>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.cities, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        selectCityRow()
    }
    
    // MARK: - Select City Row
    private func selectCityRow() {
        guard let selectedIndex = viewModel.cities.firstIndex(where: { $0 == viewModel.city }) else { return }
        let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        
        tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
        
        if let cell = tableView.cellForRow(at: selectedIndexPath) as? CityCell {
            cell.applyCheckedLook()
        }
    }
}

// MARK: - UITableViewDelegate
extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateSelectedCity(at: indexPath.row)
        
        if let cell = tableView.cellForRow(at: indexPath) as? CityCell {
            cell.applyCheckedLook()
        }
        selectedIndexPath = indexPath
        
        let selected = viewModel.cities[indexPath.row]
        searchTextField.text = selected.cityName + ", " + selected.countryName
        onCitySelected?()
    }
}


