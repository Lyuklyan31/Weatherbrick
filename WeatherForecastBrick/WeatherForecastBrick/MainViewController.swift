//
//  ViewController.swift
//  WeatherForecastBrick
//
//  Created by Mac on 17.10.2024.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let gradientView = GradientView(frame: view.bounds)
        view.addSubview(gradientView)
    }

    

}

