import UIKit

class LocationViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private let searchTextField = UISearchTextField()
    private let tableView = UITableView()
    private let backgroundView = UIView()
    private var cities = [CityData]()
    
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        setupTapGesture()
    }

    func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchTextField)
        
        searchTextField.placeholder = "Enter city name"
        searchTextField.delegate = self
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.textColor = .black

        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
    }
}

// MARK: - UITextFieldDelegate
extension LocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
   
        Task {
            cities = try await viewModel.fetchCities(for: currentText)
            self.tableView.reloadData()
        }
        return true
    }
}

// MARK: - UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        let cityData = cities[indexPath.row]
        cell.configure(with: "\(cityData.name), \(cityData.country)")
        return cell
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let previousIndexPath = selectedIndexPath, let previousCell = tableView.cellForRow(at: previousIndexPath) as? CityCell {
            previousCell.deselect()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? CityCell {
            cell.select()
        }
        
        selectedIndexPath = indexPath
        searchTextField.text = cities[indexPath.row].name
    }
}

//extension LocationViewController {
//    
//    func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func hideKeyboard() {
//        view.endEditing(true)
//    }
//}

