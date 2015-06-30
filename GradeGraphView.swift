//
//  GradeGraphView.swift
//  ClassAssistant
//
//  Created by Caleb Bogenschutz on 6/22/15.
//  Copyright (c) 2015 Caleb Bogenschutz. All rights reserved.
//

import Foundation

@objc class GradeGraphView : UIView {
    
    //1 - the properties for the gradient
    var startColor: UIColor = UIColor.grayColor()
    var endColor: UIColor = UIColor.blackColor()
    
    
    var graphPoints:[Int] = []
    
    override func drawRect(rect: CGRect) {
        println("DrawRect Count: \(graphPoints.count)");
        if (graphPoints.count > 0) {
            
            let width = rect.width + 15
            let height = rect.height
        
            //set up background clipping area
            var path = UIBezierPath(roundedRect: rect,
                byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: 8.0, height: 8.0))
            path.addClip()
        
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
            /*
            //6 - draw the gradient
            var startPoint = CGPoint.zeroPoint
            var endPoint = CGPoint(x:0, y:self.bounds.height)
            CGContextDrawLinearGradient(context,
                gradient,
                startPoint,
                endPoint,
                0)*/
        
            //calculate the x point
        
            let margin:CGFloat = 30.0
            var columnXPoint = { (column:Int) -> CGFloat in
                //Calculate gap between points
                
                var divisor = CGFloat(1)
                if (self.graphPoints.count == 1) {
                    divisor = CGFloat(1)
                }
                else {
                    divisor = CGFloat((self.graphPoints.count - 1))
                }
                let spacer = (width - margin*2 - 4) / divisor
                var x:CGFloat = CGFloat(column) * spacer
                x += margin + 2
                return x
            }
        
            // calculate the y point
        
            let topBorder:CGFloat = 10
            let bottomBorder:CGFloat = 10
            let graphHeight = height - topBorder - bottomBorder
            let maxValue = 100
            var columnYPoint = { (graphPoint:Int) -> CGFloat in
                var y:CGFloat = CGFloat(graphPoint) /
                    CGFloat(maxValue) * graphHeight
                y = graphHeight + topBorder - y // Flip the graph
                return y
            }
        
            // draw the line graph
        
            UIColor.whiteColor().setFill()
            UIColor.whiteColor().setStroke()
        
            //set up the points line
            var graphPath = UIBezierPath()
            //go to start of line
            graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
                y:columnYPoint(graphPoints[0])))
        
            //add points for each item in the graphPoints array
            //at the correct (x, y) for the point
            for i in 1..<graphPoints.count {
                let nextPoint = CGPoint(x:columnXPoint(i),
                    y:columnYPoint(graphPoints[i]))
                graphPath.addLineToPoint(nextPoint)
            }
        
            graphPath.stroke()
        
            //Create the clipping path for the graph gradient
        
            //1 - save the state of the context (commented out for now)
            CGContextSaveGState(context)
        
            //2 - make a copy of the path
            var clippingPath = graphPath.copy() as UIBezierPath
            
            clippingPath.addLineToPoint(CGPoint(
                x: columnXPoint(graphPoints.count - 1),
                y:height))
            clippingPath.addLineToPoint(CGPoint(
                x:columnXPoint(0),
                y:height))
            
            clippingPath.closePath()
        
            //4 - add the clipping path to the context
            clippingPath.addClip()
        
            //5 - check clipping path - temporary code
            let highestYPoint = columnYPoint(maxValue)
            var startPoint = CGPoint(x:margin, y: highestYPoint)
            var endPoint = CGPoint(x:margin, y:self.bounds.height)
        
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
            CGContextRestoreGState(context)
        
            //draw the line on top of the clipped gradient
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            //end temporary code
        
            //Draw the circles on top of graph stroke
            for i in 0..<graphPoints.count {
                var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
                point.x -= 5.0/2
                point.y -= 5.0/2
            
                let circle = UIBezierPath(ovalInRect:
                    CGRect(origin: point,
                        size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
            }
            
            //Draw horizontal graph lines on the top of everything
            var linePath = UIBezierPath()
            
            //top line
            linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: topBorder))
            
            //first line
            linePath.moveToPoint(CGPoint(x:margin,
                y: graphHeight/4 + topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: graphHeight/4 + topBorder))
            
            //center line
            linePath.moveToPoint(CGPoint(x:margin,
                y: graphHeight/2 + topBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y: graphHeight/2 + topBorder))
            
            //fourth line
            linePath.moveToPoint(CGPoint(x:margin,
                y: 3*graphHeight/4 + topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: 3*graphHeight/4 + topBorder))
            
            //bottom line
            linePath.moveToPoint(CGPoint(x: margin,
                y: height - bottomBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: height - bottomBorder))
            let color = UIColor(white: 1.0, alpha: 0.3)
            color.setStroke()
            
            linePath.lineWidth = 1.0
            linePath.stroke()
        }
            
        //Just draw graph.  No points
        else {
            let width = rect.width + 15
            let height = rect.height
            
            //set up background clipping area
            var path = UIBezierPath(roundedRect: rect,
                byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: 8.0, height: 8.0))
            path.addClip()
            
            //2 - get the current context
            let context = UIGraphicsGetCurrentContext()
            let colors = [startColor.CGColor, endColor.CGColor]
            
            //3 - set up the color space
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            //4 - set up the color stops
            let colorLocations:[CGFloat] = [0.0, 1.0]
            
            //calculate the x point
            
            let margin:CGFloat = 30.0
            
            let topBorder:CGFloat = 10
            let bottomBorder:CGFloat = 10
            let graphHeight = height - topBorder - bottomBorder
            let maxValue = 100

            
            // draw the line graph
            
            UIColor.whiteColor().setFill()
            UIColor.whiteColor().setStroke()
            
            //set up the points line
            var graphPath = UIBezierPath()
            
            graphPath.stroke()
            
            //Create the clipping path for the graph gradient
            
            //1 - save the state of the context (commented out for now)
            CGContextSaveGState(context)
            
            //2 - make a copy of the path
            var clippingPath = graphPath.copy() as UIBezierPath
            
            //4 - add the clipping path to the context
            clippingPath.addClip()
            
            //5 - check clipping path - temporary code
            let highestYPoint = CGFloat(100)
            var startPoint = CGPoint(x:margin, y: highestYPoint)
            var endPoint = CGPoint(x:margin, y:self.bounds.height)
            
            //CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
            CGContextRestoreGState(context)
            
            //draw the line on top of the clipped gradient
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            //end temporary code
            
            //Draw horizontal graph lines on the top of everything
            var linePath = UIBezierPath()
            
            //top line
            linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: topBorder))
            
            //first line
            linePath.moveToPoint(CGPoint(x:margin,
                y: graphHeight/4 + topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: graphHeight/4 + topBorder))
            
            //center line
            linePath.moveToPoint(CGPoint(x:margin,
                y: graphHeight/2 + topBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y: graphHeight/2 + topBorder))
            
            //fourth line
            linePath.moveToPoint(CGPoint(x:margin,
                y: 3*graphHeight/4 + topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: 3*graphHeight/4 + topBorder))
            
            //bottom line
            linePath.moveToPoint(CGPoint(x: margin,
                y: height - bottomBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y: height - bottomBorder))
            let color = UIColor(white: 1.0, alpha: 0.3)
            color.setStroke()
            
            linePath.lineWidth = 1.0
            linePath.stroke()
        }
    }
}
