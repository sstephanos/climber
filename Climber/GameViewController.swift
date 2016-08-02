//
//  GameViewController.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var scoreCounterLabel: UILabel!
    
    
    var score = 0
    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    
    var spikes: [Spike] = []
    var spikeSpawnChance = 0
    var arrowShooter = ArrowShooter()
    var ball = UIView()
    var wall1 = UIView()
    var wall2 = UIView()
    var canSwipeLeft = false
    var canSwipeRight = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spike = Spike(frame: CGRectMake(view.center.x * 0.2, view.center.y, 40, 20))
        view.addSubview(spike)
        
        
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
    
    //================================
    // Actual Swipe Direction Function
    //================================
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            if (!canSwipeLeft) { return }
            print("Swipe Left")
            let ballPosition = CGPointMake(self.ball.frame.origin.x - view.frame.width / 2.34, self.ball.frame.origin.y);
            
            UIView.animateWithDuration(0.3, animations: {
                self.ball.frame = CGRectMake( ballPosition.x , ballPosition.y , self.ball.frame.size.width, self.ball.frame.size.height)
                
                self.canSwipeLeft = false
                self.canSwipeRight = true
                
            })
            
        }
        
        if (sender.direction == .Right) {
            if (!canSwipeRight) { return }
            print("Swipe Right")
            let ballPosition = CGPointMake(self.ball.frame.origin.x + view.frame.width / 2.34, self.ball.frame.origin.y);
            
            UIView.animateWithDuration(0.3, animations: {
                self.ball.frame = CGRectMake( ballPosition.x , ballPosition.y , self.ball.frame.size.width, self.ball.frame.size.height)
                
                self.canSwipeLeft = true
                self.canSwipeRight = false
                
            })
            
        }
    }
    //================================
    // Time Label Function
    //================================
    
    func increment() {
        score += 1
        scoreCounterLabel.text = String(score)
    }
    
    //================================
    // Spike spawning function
    //================================
    
    func spikeRightWallRandomSpawn() {
        for spike in spikes {
            if spike.spawned == false {
                let spawnChanceRange = Int(arc4random_uniform(100))
                if spawnChanceRange < spikeSpawnChance {
                    spike.spawned = true
                    spike.center = CGPoint(x: 3 * view.frame.width / 4 - spike.frame.width / 2, y: 0)
                    view.addSubview(spike)
                    UIView.animateWithDuration(2.0, animations: {
                        spike.center.y = self.view.frame.height + spike.frame.height / 2
                        self.dynamicAnimator.updateItemUsingCurrentState(spike)
                        }, completion: { (completed) in
                            spike.spawned = false
                    })
                    break
                }
            }
        }
    }
    
    func spikeLeftWallTimedSpawn() {
        for spike in spikes {
            if spike.spawned == false {
                spike.spawned = true
                spike.center = CGPoint(x: view.frame.width / 4 + spike.frame.width / 2, y: 0)
                //spike.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                view.addSubview(spike)
                UIView.animateWithDuration(2.0, animations: {
                    spike.center.y = self.view.frame.height + spike.frame.height / 2
                    self.dynamicAnimator.updateItemUsingCurrentState(spike)
                    }, completion: { (completed) in
                        spike.spawned = false
                })
                break
            }
        }
    }
}