//
//  GameViewController.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    
    var spike = Spike()
    var arrowShooter = ArrowShooter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spike = Spike(frame: CGRectMake(view.center.x * 0.2, view.center.y, 40, 20))
        view.addSubview(spike)
        
        arrowShooter = ArrowShooter(frame: CGRectMake(view.center.x, view.center.y, 30, 20))
        view.addSubview(arrowShooter)
        arrowShooter.reload(view)
        
        let spikeDynamicBehavior = UIDynamicItemBehavior(items: [])
        spikeDynamicBehavior.anchored = true
        spikeDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(spikeDynamicBehavior)
        
        let arrowShooterDynamicBehavior = UIDynamicItemBehavior(items: [])
        arrowShooterDynamicBehavior.anchored = true
        arrowShooterDynamicBehavior.angularResistance = 10.0
        dynamicAnimator.addBehavior(arrowShooterDynamicBehavior)
        
        let arrowDynamicBehavior = UIDynamicItemBehavior(items: [])
        arrowDynamicBehavior.friction = 0.5
        arrowDynamicBehavior.resistance = 0.1
        dynamicAnimator.addBehavior(arrowDynamicBehavior)
        
        collisionBehavior = UICollisionBehavior(items: [])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        spikeDynamicBehavior.addItem(spike)
        arrowShooterDynamicBehavior.addItem(arrowShooter)
        arrowDynamicBehavior.addItem(arrowShooter.arrow)
        collisionBehavior.addItem(arrowShooter.arrow)
        
        
        //arrowShooter.shoot(spike, dynamicAnimator: dynamicAnimator)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        arrowShooter.shoot(spike, dynamicAnimator: dynamicAnimator)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        if (item1 is Arrow && item2 is UIView) || (item2 is Arrow && item1 is UIView) {
            arrowShooter.arrow.collided = true
        }
    }
}
