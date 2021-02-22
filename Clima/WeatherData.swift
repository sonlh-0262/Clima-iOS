//
//  WeatherData.swift
//  Clima
//
//  Created by lanh.hung.son on 2/21/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Decodable {
    let description: String
    let main: String
    let id: Int
}
