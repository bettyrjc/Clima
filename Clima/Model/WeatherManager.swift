//
//  WeatherManager.swift
//  Clima
//
//  Created by BETTY JIMENEZ on 16/4/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
  func didUpdateWeather( _ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
  
}
struct  WeatherManager {
  
  let city = "Caracas"
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9816199868f1decd4f25b37668ee21f9&units=metric"
  var delegate: WeatherManagerDelegate?
  
  func fetchWeather(cityName:String){
    let urlString = "\(weatherURL)&q=\(cityName)"
    perfomRequest(with: urlString)
  }
  func fetchWeather(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
    let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
    perfomRequest(with: urlString)
  }
  
  
  func perfomRequest (with urlString: String){
    //1 Create URL
    if let url = URL(string: urlString){
      //2 Create a URLSession
      let session = URLSession(configuration: .default)
      
      //3 Give the sesion a task
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil{
          self.delegate?.didFailWithError(error: error!)
          return
        }
        
        if let safeData = data {
          if let weather = self.parseJSON(safeData){
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      }
      
      //4 Start the task
      task.resume()
    }
  }
  func parseJSON( _ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let temp = decodedData.main.temp
      let name = decodedData.name
      
      let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
      
      return weather
    } catch {
      delegate?.didFailWithError(error: error)
      print(error)
      return nil
    }
    
  }
 
}

