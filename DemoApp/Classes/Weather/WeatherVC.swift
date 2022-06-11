//
//  ViewController.swift
//  DemoApp
//
//

import UIKit
import CoreLocation
import Kingfisher

// MARK: - VC
class WeatherVC: ParentVC {
    
    // Outlets
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // Properties
    private var viewModel: WeatherViewModel!

    // Lify cycle method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        //setCurrentLanguage(rawValue: 1)
        viewModel = WeatherViewModel()
        setupBinding()
        viewModel.checkLocationPermission()
    }
}

// MARK: - Actions(s)
extension WeatherVC {
    
    @IBAction func languageChange(sender: UISegmentedControl) {
        //setCurrentLanguage(rawValue: sender.selectedSegmentIndex)
    }
}

// MARK: - UI Helper method(s)
extension WeatherVC {
    
    // Change appearance baesd on viewModel's loading state
    private func setupBinding() {
        viewModel.loading.bind {[weak self] observable, loading in
            DispatchQueue.main.async {[weak self] in
                switch loading {
                case .idle:
                    self?.hideHud()
                    self?.contentStack.isHidden = true
                    self?.errorView.isHidden = true
                case .loading:
                    self?.contentStack.isHidden = true
                    self?.errorView.isHidden = true
                    self?.showHud(shouldDeactiveInteraction: false)
                case .success:
                    self?.hideHud()
                    self?.errorView.isHidden = true
                    self?.contentStack.isHidden = false
                    self?.updateWeatherData()
                case .error:
                    self?.hideHud()
                    self?.contentStack.isHidden = true
                    self?.errorView.isHidden = false
                }
            }
        }
    }
    
    // Update on screen weather information
    private func updateWeatherData() {
        weatherImageView.kf.setImage(with: viewModel.imageUrl)
        temperatureLabel.text = viewModel.temprature
        descriptionLabel.text = viewModel.weatherDescription
        humidityLabel.text = viewModel.humidity
        directionLabel.text = viewModel.directioun
        cityLabel.text = viewModel.location
    }
}

