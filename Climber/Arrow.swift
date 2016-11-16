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

    override func draw(_ rect: CGRect) {
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: layerHeight / 2)) //arrow point
        bezierPath.addLine(to: CGPoint(x: layerWidth / 3, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth / 3 + 2.12, y: 2.12))
        bezierPath.addLine(to: CGPoint(x: 6.0, y: layerHeight / 2 - 1.5))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight / 2 - 1.5))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight / 2 + 1.5))
        bezierPath.addLine(to: CGPoint(x: 6.0, y: layerHeight / 2 + 1.5))
        bezierPath.addLine(to: CGPoint(x: layerWidth / 3 + 2.12, y: layerHeight - 2.12))
        bezierPath.addLine(to: CGPoint(x: layerWidth / 3, y: layerHeight))
        bezierPath.close()
        
        UIColor.darkGray.setFill()
        bezierPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
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
