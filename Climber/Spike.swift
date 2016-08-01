//
//  Spike.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class Spike: UIView {

    override func drawRect(rect: CGRect) {
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, layerHeight / 2))
        bezierPath.addLineToPoint(CGPointMake(layerWidth, 0))
        bezierPath.addLineToPoint(CGPointMake(layerWidth, layerHeight))
        bezierPath.addLineToPoint(CGPointMake(0, layerHeight / 2))
        bezierPath.closePath()
        
        UIColor.grayColor().setFill()
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
