//
//  RainfallView.swift
//  Rainfall
//
//  Created by Morgan Harris on 6/01/2016.
//  Copyright © 2016 Morgan Harris. All rights reserved.
//

import Cocoa

class RainfallView: NSView {

    var rainfall: [[Float]] = [] {
        didSet {
            self.setNeedsDisplayInRect(self.bounds)
        }
    }
    
    var yearFilter: Int? = nil {
        didSet {
            self.setNeedsDisplayInRect(self.bounds)
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        
        let dayWidth = self.bounds.width / 365.0
        
        NSColor.whiteColor().setFill()
        NSBezierPath(rect: dirtyRect).fill()
        
        guard let context = NSGraphicsContext.currentContext() else {
            fatalError("graphics context unavailable")
        }
        context.compositingOperation = .CompositeMultiply
        
        let maxRainfall = 330
        let mmHeight = self.bounds.size.height / CGFloat(maxRainfall)
        
        if (yearFilter == nil) {
        
            let color = NSColor(deviceHue: 2.0/3.0, saturation: 0.1, brightness: 0.95, alpha: 1.0)
            color.setFill()
            
            for year in rainfall {
                
                for (i, mm) in year.enumerate() {
                    let left = dayWidth * CGFloat(i)
                    
                    let rect = NSRect(x: left, y: 0.0, width: dayWidth, height: CGFloat(mm) * mmHeight)
                    
                    NSRectFillUsingOperation(rect, .CompositeMultiply)
                    
                }
                
            }
            
        } else {
            
            let range = max(rainfall.startIndex, yearFilter! - 10)...yearFilter!

            for (y, year) in rainfall[range].enumerate() {
                
                let sat = CGFloat(y + 1 + (10 - range.count)) / 10.0
                let color = NSColor(deviceHue: 2.0/3.0, saturation: 1.0, brightness: 0.9, alpha: pow(sat,10))
                color.setFill()
                
                for (i, mm) in year.enumerate() {
                    let left = dayWidth * CGFloat(i)
                    
                    let rect = NSRect(x: left, y: 0.0, width: dayWidth, height: CGFloat(mm) * mmHeight)
                    
                    NSRectFillUsingOperation(rect, .CompositeMultiply)
                    
                }
            }
            
            let s = "\(yearFilter! + 1859)" as NSString
            let attrs: [String:AnyObject] = [NSForegroundColorAttributeName: NSColor.lightGrayColor(), NSFontAttributeName: NSFont(name: "HelveticaNeue", size: 36.0)!]
            let size = s.sizeWithAttributes(attrs)
            
            s.drawAtPoint(NSPoint(x: self.bounds.width - size.width, y: self.bounds.height - size.height), withAttributes: attrs)
            
        }
        
        // draw in month lines
        
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let lines = days.enumerate().map { (i, el) -> Int in
            return days[days.startIndex..<i].reduce(0) { $0 + $1 }
        }
        
        let months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]

        NSColor.whiteColor().setFill()
        let op: NSCompositingOperation = yearFilter == nil ? .CompositeScreen : .CompositeDifference
        context.compositingOperation = op
        
        for (i, l) in lines.enumerate() {
            let r = NSRect(x: CGFloat(l) * dayWidth, y: 0, width: 1, height: 50)
            NSRectFill(r)
            
            // draw tick lines
            
            let d = days[i]
            for t in 1 ..< d {
                let big = t % 5 == 0
                let left = CGFloat(l + t) * dayWidth
                let r = NSRect(x: left, y: 0, width: 1, height: big ? 20 : 10)
                NSRectFillUsingOperation(r, op)
            }
            
            let m = months[i] as NSString
            m.drawAtPoint(NSPoint(x: CGFloat(l) * dayWidth + 5, y: 10), withAttributes: [NSForegroundColorAttributeName: NSColor.whiteColor()])
        }
        
        // draw in mm
        
        context.compositingOperation = .CompositeDifference
        
        for i in 50.stride(to: 330, by: 10) {
            let big = i % 50 == 0
            let y = CGFloat(i) * mmHeight
            let r = NSRect(x: 0.0, y: y, width: big ? self.bounds.size.width : 10, height: 1.0)
            
            NSColor(deviceWhite: 1.0, alpha: 0.1).setFill()
            NSRectFillUsingOperation(r, .CompositeDifference)
            
            if (big) {
                let s = "\(i) mm"
                s.drawAtPoint(NSPoint(x: 0, y: y), withAttributes: [NSForegroundColorAttributeName: NSColor(deviceWhite: 1.0, alpha: 0.3)])
            }
        }
        
    }
    
    
    
}
