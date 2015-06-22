//
//  GradeGraphView.swift
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/22/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

import Foundation

@IBDesignable class GradeGraphView : UIView {
    //1 - the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.grayColor()
    @IBInspectable var endColor: UIColor = UIColor.blackColor()
    
    override func drawRect(rect: CGRect) {
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            0)
    }
}
