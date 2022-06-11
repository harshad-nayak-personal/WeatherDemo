//
//  WeatherModel.swift
//  DemoApp
//
//

import Foundation

// MARK: - Language
enum Language : Int {
    case english = 0
    case hindi = 1
    
    var tableName: String {
        switch self {
        case .english: return "English"
        case .hindi: return "Hindi"
        }
    }
    
    var apiParameterValue: String {
        switch self {
        case .english: return "en"
        case .hindi: return "hi"
        }
    }
}

// MARK: - Weather Data
struct WeatherData {
    
    let imageURLString: String
    let temprature: Int
    let weatherDescription: String
    let humidity: Int
    let windDegree: Int
    let windSpeed: Int
    let windDirection: String
    let city: String
    let country: String
    
    init?(dictionary: NSDictionary) {
        if let dictWeather = dictionary["current"] as? NSDictionary,
        let dictLocation = dictionary["location"] as? NSDictionary {
            // icon
            let icons: [String]? = dictWeather["weather_icons"] as? [String]
            imageURLString = icons?.first ?? ""
            
            // description
            let descriptions = dictWeather["weather_descriptions"] as? [String]
            weatherDescription = descriptions?.first ?? "-"
            
            temprature = dictWeather.getIntValue(key: "temperature")
            humidity = dictWeather.getIntValue(key: "humidity")
            windDegree = dictWeather.getIntValue(key: "wind_degree")
            windSpeed = dictWeather.getIntValue(key: "wind_speed")
            windDirection = dictWeather.getStringValue(key: "wind_dir")
            
            // location
            city = dictLocation.getStringValue(key: "name")
            country = dictLocation.getStringValue(key: "country")
        } else {
            return nil
        }
    }
}
