//
//  Spike.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class Spike: UIView {
    
    var spawned = false

    override func draw(_ rect: CGRect) {
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: layerHeight / 2))
        bezierPath.addLine(to: CGPoint(x: layerWidth / 2, y: 0))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight / 2))
        bezierPath.addLine(to: CGPoint(x: layerWidth / 2, y: layerHeight))
        bezierPath.close()
        
        UIColor.black.setFill()
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
