//
//  WeatherViewModel.swift
//  DemoApp
//
//

import UIKit
import CoreLocation

// MARK: - View Model
class WeatherViewModel: NSObject {
    
    // Properties
    var data: WeatherData?
    public var loading: Observable<Loading> = Observable(.idle)
    private var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    // Display properties
    public var temprature: String {
        guard let data = data else { return "-" }
        return "\(data.temprature) °"
    }
    public var weatherDescription: String {
        guard let data = data else { return "-" }
        return "\(data.weatherDescription)"
    }
    public var humidity: String {
        guard let data = data else { return "-" }
        return "Humidity: \(data.humidity)"
    }
    public var directioun: String {
        guard let data = data else { return "-" }
        return "Wind: 🧭 \(data.windDirection) \(data.windDegree)° \(data.windSpeed) 💨"
    }
    public var location: String {
        guard let data = data else { return "-" }
        return "\(data.city), \(data.country)"
    }
    public var imageUrl: URL? {
        guard let data = data else { return nil }
        return URL(string: data.imageURLString)
    }
    
    // Life Cycle
    override init() {
        super.init()
    }
}

// MARK: - Location method(s)
extension WeatherViewModel: CLLocationManagerDelegate {
    
    /// Set location manager delegate and check - request location permission
    public func checkLocationPermission() {
        
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            loading.value = .loading
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            loading.value = .idle
        case .denied:
            PermissionManager.shared.showPopup(
                title: kNoLocationTitle,
                message: kNoLocationMessage)
            loading.value = .error
        default:
            loading.value = .error
            showAlert(title: String.localizedString(key: "kError"),
                      message: String.localizedString(key: "kErrorLocationPermission"))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            loading.value = .loading
        case .denied:
            loading.value = .error
            if currentLocation == nil {
                PermissionManager.shared.showPopup(title: kNoLocationTitle, message: kNoLocationMessage)
            }
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            loading.value = .error
            showAlert(title: String.localizedString(key: "kLocationError"),
                      message: String.localizedString(key: "kLocationFetchError"))
            return
        }
        locationManager.stopUpdatingLocation()
        currentLocation = location
        fetchCityFromLocation()
    }
    
    // Fetch city from coordinates
    private func fetchCityFromLocation() {
        guard let location = currentLocation else { return }
        location.fetchCityAndCountry {[weak self] city, country, error in
            guard let city = city else {
                self?.loading.value = .error
                showAlert(title: String.localizedString(key: "kLocationError"),
                          message: String.localizedString(key: "kLocationFetchError"))
                return
            }
            self?.getWeatherData(city: city)
        }
    }
}

// MARK: - API
extension WeatherViewModel {
    
    // fetch weather data from API
    private func getWeatherData(city: String) {
        // Preparing url
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "access_key", value: _apiKey),
            URLQueryItem(name: "query", value: city),
            //URLQueryItem(name: "language", value: currentLanguage.apiParameterValue),
        ]
        var urlComponents = URLComponents(string: "http://api.weatherstack.com/current")
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }
        
        print(url.absoluteString)
        
        // Make API call
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let strongSelf = self else { return }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            if let data = data {
                do {
                    // Data parsing
                    let json = try JSONSerialization.jsonObject(with: data)
                    DispatchQueue.main.async {[weak self] in
                        if let dict = json as? NSDictionary {
                            self?.data = WeatherData(dictionary: dict)
                            self?.loading.value = .success
                        } else {
                            self?.loading.value = .error
                            showAlert(title: String.localizedString(key: "kAPIErrorTitle"),
                                      message: String.localizedString(key: "kAPIErrorMessage"))
                        }
                    }
                } catch let error as NSError {
                    print("*** Error in JSON parsing: \(error.localizedDescription) ***")
                }
            }
        }.resume()
    }
}
