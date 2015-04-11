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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        let baseURL = NSURL(string:"https://api.forecast.io/forecast/\(apiKey)/")
        if let forecastURL = NSURL(string:"37.739024,-122.462700/", relativeToURL: baseURL) {
            let sharedSession = NSURLSession.sharedSession()
            let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: {
                (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if error == nil {
                    if let dataObject = NSData(contentsOfURL: location) {
                        let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as! NSDictionary
                        println(weatherDictionary)
                    }
                }
            
            })
            
            downloadTask.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

