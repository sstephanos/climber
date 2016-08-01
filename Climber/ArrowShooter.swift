//
//  ArrowShooter.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class ArrowShooter: UIView {

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

}
