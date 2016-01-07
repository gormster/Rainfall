//
//  AppDelegate.swift
//  Rainfall
//
//  Created by Morgan Harris on 6/01/2016.
//  Copyright © 2016 Morgan Harris. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var rainfallView: RainfallView!
    
    var timer: NSTimer?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let error: NSErrorPointer = nil
        
        guard let data = CSV(contentsOfFile: "/Users/gormster/Downloads/IDCJAC0009_066062_1800/IDCJAC0009_066062_1800_Data.csv", error: error) else {
            fatalError("cannot open data file")
        }
        
        var rainfall: [[Float]] = []
        var thisYear: [Float] = []
        var year: String = ""
        
        for row in data.rows {
            if row["Year"] != year {
                if thisYear.count > 0 {
                    rainfall.append(thisYear)
                }
                year = row["Year"]!
                thisYear = []
            }
            
            if row["Month"]! == "2" && row["Day"]! == "29" {
                continue
            }
            
            guard let mmStr = row["Rainfall amount (millimetres)"] else {
                continue
            }
            
            guard let mmFloat = Float(mmStr) else {
                continue
            }
            
            thisYear.append(mmFloat)
        }
        
        if thisYear.count > 0 {
            rainfall.append(thisYear)
        }
        
        rainfallView.rainfall = rainfall
        
    }
    
    @IBAction func animate(sender: AnyObject) {
        
        timer?.invalidate()
        
        timer = NSTimer(timeInterval: 0.08, target: self, selector: "incrementYear", userInfo: nil, repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        
        rainfallView.yearFilter = 0

    }
    
    func incrementYear() {
        
        if rainfallView.yearFilter == nil {
            rainfallView.yearFilter = 0
        }
        
        if rainfallView.rainfall.count > rainfallView.yearFilter! + 1 {
            rainfallView.yearFilter! += 1
        } else {
            rainfallView.yearFilter = nil
            timer?.invalidate()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

