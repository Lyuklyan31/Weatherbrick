import UIKit

// MARK: - LocationViewController
class LocationViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: WeatherLocationViewModel

    private let searchTextField = UISearchTextField()
    private let tableView = UITableView()
    private let backgroundView = UIView()
    
    private var selectedIndexPath: IndexPath?
    private var currentTask: Task<Void, Never>?
    private var dataSource: UITableViewDiffableDataSource<Int, CityData>!
    
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
        fetchCities()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchTextField)
        
        searchTextField.placeholder = "Enter city name"
        searchTextField.delegate = self
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.textColor = .black
        searchTextField.text = viewModel.selectedCityName + ", " + viewModel.selectedCountryName
        
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

    // MARK: - Data Source Setup
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CityData>(tableView: tableView) { tableView, indexPath, cityData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell else { return UITableViewCell() }
            
            cell.configure(with: "\(cityData.name), \(cityData.getFullCountryName())")
            
            if cityData.name == self.viewModel.selectedCityName &&
                cityData.lat == self.viewModel.latitude &&
                cityData.lon == self.viewModel.longitude &&
                cityData.country == self.viewModel.selectedCountryName {
                cell.applyChecked()
            } else {
                cell.uncheckedLook()
            }
            return cell
        }
    }

    // MARK: - Snapshot Handling
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CityData>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.cities, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if let indexPath = viewModel.cities.firstIndex(where: { $0.name == viewModel.selectedCityName }) {
            let selectedIndexPath = IndexPath(row: indexPath, section: 0)
            tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
            
            if let cell = tableView.cellForRow(at: selectedIndexPath) as? CityCell {
                cell.applyChecked()
            }
        }
    }
    
    private func fetchCities() {
        Task {
            viewModel.cities = try await viewModel.fetchCities(for: searchTextField.text ?? "")
            applySnapshot()
        }
    }
}

// MARK: - UITextFieldDelegate
extension LocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        currentTask?.cancel()
        
        guard !currentText.isEmpty else {
            viewModel.cities = []
            applySnapshot()
            return true
        }
        
        currentTask = Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                if Task.isCancelled { return }
                fetchCities()
                applySnapshot()
            } catch {
                if !(error is CancellationError) {
                }
            }
        }
        return true
    }
}

// MARK: - UITableViewDelegate
extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateSelectedCity(at: indexPath.row)

        if let previousCell = tableView.cellForRow(at: selectedIndexPath ?? IndexPath(row: 0, section: 0)) as? CityCell {
            previousCell.uncheckedLook()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? CityCell {
            cell.applyChecked()
        }
        selectedIndexPath = indexPath
        
        let selected = viewModel.cities[indexPath.row]
        searchTextField.text = selected.name + ", " + selected.getFullCountryName()

        dismiss(animated: true) {
            self.onCitySelected?()
        }
    }
}
