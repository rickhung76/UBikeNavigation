//
//  SWeatherViewController.swift
//  P6
//
//  Created by Frank Chen on 2019/9/24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class SWeatherViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var WeatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainRateLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var info: SWeatherInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "今日天氣"
        self.requestData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
       
    func requestData() {
        let url = URL(string: "https://works.ioa.tw/weather/api/weathers/1.json")!
        let request = URLRequest(url: url)
        
        self.contentView.alpha = 0
        FCLoadingDialog.shared.presentInWindow()
           
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            FCLoadingDialog.shared.dismissSelf()
            
            if let data = data, let weatherInfo = try? JSONDecoder().decode(SWeatherInfo.self, from: data) {
                self?.info = weatherInfo
                DispatchQueue.main.async {
                    self?.updateUI()
                    UIView.animate(withDuration: 1.2, animations: {
                       self?.contentView.alpha = 1
                    })
                }
            } else {

            }
        }
        task.resume()
    }
       
    func updateUI() {
        if let info = self.info {
            self.dateLabel.text = info.at
            self.WeatherLabel.text = info.desc
            self.temperatureLabel.text = "\(info.temperature)度"
            self.humidityLabel.text = "\(info.humidity)度"
            self.rainRateLabel.text = "\(info.rainfall)%"
            self.sunriseLabel.text = info.sunrise
            self.sunsetLabel.text =  info.sunset
        }
    }

}
