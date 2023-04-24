//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
  
    var weatherManager =  WeatherManager()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
      locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Do any additional setup after loading the view.
        weatherManager.delegate = self
        searchTextField.delegate = self // current view controller
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
  @IBAction func searchPressed(_ sender: UIButton) {
    searchTextField.endEditing(true)
    
  }
  //ask the delegate if the text field should process the pressing of the return button
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    print(searchTextField.text ?? "defaul" )
    return true
  }
  //delegate metho notify when end editing
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    }else {
      textField.placeholder = "Search a city"
      return false
    }
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    // use searchTextField.text to get  the weather for ga city
    if let city = searchTextField.text {
      weatherManager.fetchWeather(cityName: city)
    }
    
    searchTextField.text = ""
  }
}
 // MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
  
  func didUpdateWeather( _ weatherManager: WeatherManager, weather: WeatherModel){
    //poder imprimir las cosas lazy and dont make an error
    DispatchQueue.main.async { [self] in
      self.temperatureLabel.text = weather.temperatureString
      self.conditionImageView.image = UIImage(systemName: weather.conditionName)
      self.cityLabel.text = weather.cityName
    }
    
    
    print(weather.temperature)
  }
  func didFailWithError(error: Error) {
    print(error)
  }
}
 // MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
        locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      weatherManager.fetchWeather(latitude: lat, longitude: lon)
    }
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
