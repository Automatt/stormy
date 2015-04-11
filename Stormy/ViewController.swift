//
//  ViewController.swift
//  Stormy
//
//  Created by Mathew Spolin on 4/11/15.
//  Copyright (c) 2015 Automatt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiKey = "c8e33a8ffc6786ac699def73291860a0"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshActivityIndicator.hidden = true
       
        getCurrentWeatherData()
    }
    
    func getCurrentWeatherData() {
        let baseURL = NSURL(string:"https://api.forecast.io/forecast/\(apiKey)/")
        if let forecastURL = NSURL(string:"37.739024,-122.462700/", relativeToURL: baseURL) {
            let sharedSession = NSURLSession.sharedSession()
            let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: {
                (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if error == nil {
                    if let dataObject = NSData(contentsOfURL: location) {
                        let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as! NSDictionary
                        
                        let currentWeather = Current(weatherDictionary: weatherDictionary)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.temperatureLabel.text = "\(currentWeather.temperature)"
                            self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                            self.humidityLabel.text = "\(currentWeather.humidity)"
                            self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                            self.summaryLabel.text = "\(currentWeather.summary)"
                            self.iconView.image = currentWeather.icon!
                            
                            self.refreshActivityIndicator.stopAnimating()
                            self.refreshActivityIndicator.hidden = true
                            self.refreshButton.hidden = false
                        })
                        
                    }
                } else {
                    let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data.  Connectivity error.", preferredStyle: .Alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    
                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    networkIssueController.addAction(cancelButton)

                    self.presentViewController(networkIssueController, animated: true, completion: nil)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.refreshActivityIndicator.stopAnimating()
                        self.refreshActivityIndicator.hidden = true
                        self.refreshButton.hidden = false
                    })
                }
                
            })
            
            downloadTask.resume()
        }
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

