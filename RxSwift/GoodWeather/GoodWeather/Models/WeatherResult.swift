//
//  WeatherResult.swift
//  GoodWeather
//
//  Created by 이재은 on 27/04/2020.
//  Copyright © 2020 Jaeeun. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
