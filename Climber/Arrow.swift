//
//  Arrow.swift
//  Climber
//
//  Created by SESP Walkup on 7/31/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class Arrow: UIView {
    
    var collided = false

    override func drawRect(rect: CGRect) {
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, layerHeight / 2)) //arrow point
        bezierPath.addLineToPoint(CGPointMake(layerWidth / 3, 0))
        bezierPath.addLineToPoint(CGPointMake(layerWidth / 3 + 2.12, 2.12))
        bezierPath.addLineToPoint(CGPointMake(6.0, layerHeight / 2 - 1.5))
        bezierPath.addLineToPoint(CGPointMake(layerWidth, layerHeight / 2 - 1.5))
        bezierPath.addLineToPoint(CGPointMake(layerWidth, layerHeight / 2 + 1.5))
        bezierPath.addLineToPoint(CGPointMake(6.0, layerHeight / 2 + 1.5))
        bezierPath.addLineToPoint(CGPointMake(layerWidth / 3 + 2.12, layerHeight - 2.12))
        bezierPath.addLineToPoint(CGPointMake(layerWidth / 3, layerHeight))
        bezierPath.closePath()
        
        UIColor.darkGrayColor().setFill()
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
