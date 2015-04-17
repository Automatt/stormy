//
//  ViewController.swift
//  Stormy
//
//  Created by Mathew Spolin on 4/11/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    let forecast: Forecast = Forecast()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshActivityIndicator.hidden = true
        getCurrentWeatherData()
    }
    
    func getCurrentWeatherData() {
        
        forecast.loadCurrentWeatherData(refreshWithWeather, errorCallback: alertUserOfError)
    }
    
    func alertUserOfError() {
        let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data.  Connectivity error.", preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        networkIssueController.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        networkIssueController.addAction(cancelButton)
        
        self.presentViewController(networkIssueController, animated: true, completion: nil)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.stopUpdating()
        })
    }
    
    func refreshWithWeather(currentWeather: Current) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.temperatureLabel.text = "\(currentWeather.temperature)"
            self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
            self.humidityLabel.text = "\(currentWeather.humidity)"
            self.precipitationLabel.text = "\(currentWeather.precipProbability)"
            self.summaryLabel.text = "\(currentWeather.summary)"
            self.iconView.image = currentWeather.icon!
            self.stopUpdating()
            
        })
    }
    
    func stopUpdating() {
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
        self.refreshButton.hidden = false
    }

    @IBAction func refresh() {
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        getCurrentWeatherData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

