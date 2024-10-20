import UIKit
import SnapKit

class MainViewController: UIViewController {
    let viewModel = MainViewModel()
    
    let backgroundView = BackgroundView()
    let locationButton = UIButton()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackroundView()
        setupLocationButton()
    }

    func setupBackroundView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupLocationButton() {
        locationButton.setTitle("Open Sheet", for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        
        view.addSubview(locationButton)
        
        locationButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func openSheet() {
        let sheetViewController = SheetViewController()
        sheetViewController.modalPresentationStyle = .pageSheet
        
        self.present(sheetViewController, animated: true, completion: nil)
    }
}

