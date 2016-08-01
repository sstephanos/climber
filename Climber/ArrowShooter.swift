//
//  ArrowShooter.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class ArrowShooter: UIView {
    
    var arrow = Arrow()

    override func drawRect(rect: CGRect) {
        let layerWidth = self.layer.frame.width
        let layerHeight = self.layer.frame.height
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, 0))
        bezierPath.addLineToPoint(CGPointMake(layerWidth, 0))
        bezierPath.addLineToPoint(CGPointMake(layerWidth, layerHeight))
        bezierPath.addLineToPoint(CGPointMake(0, layerHeight))
        bezierPath.addLineToPoint(CGPointMake(0, layerHeight - 5.0))
        bezierPath.addLineToPoint(CGPointMake(layerWidth - 5.0, layerHeight - 5.0))
        bezierPath.addLineToPoint(CGPointMake(layerWidth - 5.0, 5.0))
        bezierPath.addLineToPoint(CGPointMake(0, 5.0))
        bezierPath.closePath()
        
        UIColor.blueColor().setFill()
        bezierPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.CGPath
        self.layer.mask = shapeLayer
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
    }

    func reload(view: UIView) {
        arrow = Arrow(frame: CGRectMake(self.frame.minX - 20.0, self.frame.minY, 40, 20))
        view.addSubview(arrow)
    }
    
    
    // Use this func to check if center of arrow, tip(minX), and target's center are in line
    internal func checkInLine(pointOne: CGPoint, pointTwo: CGPoint, pointThree: CGPoint) -> Bool {
        let slope = (pointOne.y - pointTwo.y) / (pointOne.x - pointTwo.x)
        let yIntercept = pointOne.y - slope * pointOne.x
        if pointThree.y == slope * pointThree.x + yIntercept {
            return true
        } else {
            return false
        }
    }
    
    func shoot(targetView: UIView) {
        while arrow.collided == false {
            let targetPoint = targetView.center
            UIView.animateWithDuration(0.2, animations: {
                
                if targetPoint.x - self.arrow.frame.minX <= 3 || self.arrow.frame.minX - targetPoint.x <= 3 {
                    //nothing
                } else if targetPoint.x > self.arrow.frame.minX {
                    self.arrow.center.x += 3
                } else {
                    self.arrow.center.x -= 3
                }
                
                if targetPoint.y - self.arrow.frame.minY <= 3 || self.arrow.frame.minY - targetPoint.y <= 3 {
                    //nothing
                } else if targetPoint.y > self.arrow.frame.minY {
                    self.arrow.center.y += 3
                } else {
                    self.arrow.center.y -= 3
                }
                //Below may need convertPoint to general view
                if !(self.checkInLine(self.arrow.center, pointTwo: self.convertPoint(CGPointMake(self.arrow.frame.minX, self.arrow.center.y), toView: self.superview), pointThree: targetPoint)) {
                    //Using trig
                    let sideOneTwo = sqrt(
                        pow(self.arrow.center.x - self.convertPoint(CGPointMake(self.arrow.frame.minX, self.arrow.center.y), toView: superview)).x, 2)
                    )
                
                    
                }
            })
        }
    }
}
