import UIKit

class LocationViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ViewModel
    private var cities = [CityData]()
    
    private let searchTextField = UISearchTextField()
    private let tableView = UITableView()
    private let backgroundView = UIView()
    
    private var selectedIndexPath: IndexPath?
    
    private var dataSource: UITableViewDiffableDataSource<Int, CityData>!
    private var snapshot = NSDiffableDataSourceSnapshot<Int, CityData>()
    
    var onCitySelected: (() -> Void)?
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDefaults()
    }
    
    private func configureDefaults() {
        setupDataSource()
        applySnapshot()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchTextField)
        
        searchTextField.placeholder = "Enter city name"
        searchTextField.delegate = self
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.textColor = .black
        searchTextField.text = viewModel.selectedCityName + ", " + viewModel.selectedContryName
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        Task {
            cities = try await viewModel.fetchCities(for: searchTextField.text ?? "")
            applySnapshot()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell else {
                return UITableViewCell()
            }
            cell.configure(with: "\(cityData.name), \(self.getFullCountryName(from: cityData.country) ?? "")")
            
            if cityData.name == self.viewModel.selectedCityName &&
                cityData.lat == self.viewModel.latitude &&
                 cityData.lon == self.viewModel.longitude {
                cell.select()
            } else {
                cell.deselect()
            }
            
            return cell
        }
    }

    // MARK: - Snapshot Handling
    private func applySnapshot() {
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(cities, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if let indexPath = cities.firstIndex(where: { $0.name == viewModel.selectedCityName }) {
            let selectedIndexPath = IndexPath(row: indexPath, section: 0)
            tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
            
            if let cell = tableView.cellForRow(at: selectedIndexPath) as? CityCell {
                cell.select()
            }
        }
    }
    
    func getFullCountryName(from countryCode: String) -> String? {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: countryCode.uppercased())
    }
}

// MARK: - UITextFieldDelegate
extension LocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        Task {
            cities = try await viewModel.fetchCities(for: currentText)
            applySnapshot()
        }
        return true
    }
}

// MARK: - UITableViewDelegate
extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = cities[indexPath.row]
        
        if let previousCell = tableView.cellForRow(at: selectedIndexPath ?? IndexPath(row: 0, section: 0)) as? CityCell {
            previousCell.deselect()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? CityCell {
            cell.select()
        }
        selectedIndexPath = indexPath
        
        searchTextField.text = selected.name + ", " + (getFullCountryName(from: selected.country) ?? "")
       
        viewModel.selectedCityName = selected.name
        viewModel.selectedContryName = (getFullCountryName(from: selected.country) ?? "")
        viewModel.latitude = selected.lat
        viewModel.longitude = selected.lon
        
        dismiss(animated: true) {
            self.onCitySelected?()
        }
    }
}
