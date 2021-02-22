//
//  WeatherManager.swift
//  Clima
//
//  Created by lanh.hung.son on 2/21/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=f347e724b6a56c7369c15e3a341048cf&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let url = "\(weatherUrl)&q=\(cityName)";
        performRequest(requestUrl: url)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let url = "\(weatherUrl)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(requestUrl: url)
    }
    
    func performRequest(requestUrl: String) {
        if let url = URL(string: requestUrl) {
            let session = URLSession.init(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(data: safeData) {
                        print(weather.temperature)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let dataDecoded = try decoder.decode(WeatherData.self, from: data)
            let temp = dataDecoded.main.temp
            let name = dataDecoded.name
            let id = dataDecoded.weather[0].id
            
            let weather = WeatherModel(temperature: temp, name: name, conditionID: id)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
