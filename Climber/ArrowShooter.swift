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
    // This will also make sure that the arrow is not backwards
    internal func checkInLineAndInOrder(pointOne: CGPoint, pointTwo: CGPoint, pointThree: CGPoint) -> String {
        let slope = (pointOne.y - pointTwo.y) / (pointOne.x - pointTwo.x)
        let yIntercept = pointOne.y - slope * pointOne.x
        if pointThree.y == slope * pointThree.x + yIntercept {
            let sideOneThreeLength = sqrt(
                pow(pointOne.x - pointThree.x, 2) +
                pow(pointOne.y - pointThree.y, 2)
            )
            let sideTwoThreeLength = sqrt(
                pow(pointTwo.x - pointThree.x, 2) +
                pow(pointTwo.y - pointThree.y, 2)
            )
            if sideOneThreeLength > sideTwoThreeLength {
                return "yes"
            } else {
                return "backward"
            }
        } else {
            return "no"
        }
    }
    
    
    func shoot(targetView: UIView, dynamicAnimator: UIDynamicAnimator) {
        var delay = 0.0
        while arrow.collided == false {
            let targetPoint = targetView.center
            UIView.animateWithDuration(delay, animations: {
               // print("animating")
                
                if abs(targetPoint.x - self.arrow.center.x) <= 3 {
                    //nothing
                    print(abs(targetPoint.x - self.arrow.center.x))
                } else if targetPoint.x > self.arrow.center.x {
                    self.arrow.center.x += 3
                    print("2x")
                } else {
                    self.arrow.center.x -= 3
                    print("3x")
                }
                
                if abs(targetPoint.y - self.arrow.center.y) <= 3{
                    //nothing
                    print(abs(targetPoint.y - self.arrow.center.y))
                } else if targetPoint.y > self.arrow.center.y {
                    self.arrow.center.y += 3
                    print("2y")
                } else {
                    self.arrow.center.y -= 3
                    print("3y")
                }
                
//                switch self.checkInLineAndInOrder(self.arrow.center, pointTwo: self.convertPoint(CGPointMake(self.arrow.frame.minX, self.arrow.center.y), toView: self.superview), pointThree: targetPoint) {
//                    case "yes": break
//                    case "no":
//                        //Distance formula
//                        let sideOneTwoLength = sqrt(
//                            pow(self.arrow.center.x - self.convertPoint(CGPointMake(self.arrow.frame.minX, self.arrow.center.y), toView: self.superview).x, 2) +
//                                pow(self.arrow.center.y - self.convertPoint(CGPointMake(self.arrow.frame.minX, self.arrow.center.y), toView: self.superview).y, 2)
//                        )
//                        let sideTwoThreeLength = sqrt(
//                            pow(self.convertPoint(CGPointMake(self.arrow.frame.minX, self.arrow.center.y), toView: self.superview).x - targetPoint.x, 2) +
//                                pow(self.convertPoint(CGPointMake(self.arrow.frame.minX, self.arrow.center.y), toView: self.superview).y - targetPoint.y, 2)
//                        )
//                        let sideThreeOneLength = sqrt(
//                            pow(targetPoint.x - self.arrow.center.x, 2) +
//                                pow(targetPoint.y - self.arrow.center.y, 2)
//                        )
//                        //Law of cosines to find the angle with the vertex of arrow.center
//                        let angleArrowCenter = acos((pow(sideTwoThreeLength, 2) - pow(sideThreeOneLength, 2) - pow(sideOneTwoLength, 2)) / (-2 * sideThreeOneLength * sideOneTwoLength))
//                        
//                        //Puts the target point in relation to the arrow view, to see whether to rotate backwards or
//                        let targetPointInRelationToArrowView = self.convertPoint(targetPoint, fromView: self.superview)
//                        
//                        if self.arrow.frame.minX > targetPointInRelationToArrowView.x {
//                            self.arrow.transform = CGAffineTransformMakeRotation(-angleArrowCenter)
//                        } else {
//                            self.arrow.transform = CGAffineTransformMakeRotation(-angleArrowCenter)
//                        }
//                    case "backward": self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
//                    default: break
//                }
                dynamicAnimator.updateItemUsingCurrentState(self.arrow)
            })
            delay += 0.2
        }
    }
}
