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
        
        //=======================
        // Spike and Arrow Logic
        //=======================
        
        //        spike = Spike(frame: CGRectMake(view.center.x, view.center.y * 1.7, 40, 20))
        //        view.addSubview(spike)
        //
        //        arrowShooter = ArrowShooter(frame: CGRectMake(view.center.x, view.center.y, 30, 20))
        //        view.addSubview(arrowShooter)
        //        arrowShooter.reload(view)
        
        
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
        
        
        //        spikeDynamicBehavior.addItem(spike)
        //        arrowShooterDynamicBehavior.addItem(arrowShooter)
        //        arrowDynamicBehavior.addItem(arrowShooter.arrow)
        
        //=======================
        // Create spikes and spawn chance
        //=======================
        
        // Seven spike limit on screen
        for _ in 0...9 {
            spikes.append(Spike(frame: CGRectMake(view.center.x, view.center.y * 1.7, 40, 20)))
        }
        
        for spike in spikes {
            spikeDynamicBehavior.addItem(spike)
            collisionBehavior.addItem(spike)
        }
        // Spike chance for spawn
        spikeSpawnChance = 5
        
        //================
        //Wall Objects
        //================
        
        wall1 = UIView(frame: CGRectMake(0, 0, view.frame.width / 4, view.frame.height))
        wall1.backgroundColor = UIColor.grayColor()
        view.addSubview(wall1)
        
        
        wall2 = UIView(frame: CGRectMake(view.frame.width * 0.75 , 0, view.frame.width / 4, view.frame.height))
        wall2.backgroundColor = UIColor.grayColor()
        view.addSubview(wall2)
        
        
        //Wall1 Dynamic Behavior
        let wall1DynamicBehavior = UIDynamicItemBehavior(items: [wall1])
        wall1DynamicBehavior.density = 10000
        wall1DynamicBehavior.resistance = 100
        wall1DynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(wall1DynamicBehavior)
        
        //Wall2 Dynamic Behavior
        let wall2DynamicBehavior = UIDynamicItemBehavior(items: [wall2])
        wall2DynamicBehavior.density = 10000
        wall2DynamicBehavior.resistance = 100
        wall2DynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(wall2DynamicBehavior)
        
        
        
        
        //===========
        //Ball Object
        //===========
        
        ball = UIView(frame: CGRectMake(view.center.x - view.frame.width / 4.07, view.frame.width + 150, 26, 26))
        ball.backgroundColor = UIColor.blackColor()
        ball.layer.cornerRadius = 13
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        //Ball Dynamic Behavior
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 0
        ballDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        //================
        // Swipe Variables
        //================
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "increment", userInfo: nil, repeats: true)
        
        let spikeRightWallTimer = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: "spikeRightWallRandomSpawn", userInfo: nil, repeats: true)
        
        let spikeLeftWallTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "spikeLeftWallTimedSpawn", userInfo: nil, repeats: true)
    }
    
    //================================
    // Actual Swipe Direction Function
    //================================
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            if (!canSwipeLeft) { return }
            print("Swipe Left")
            var ballPosition = CGPointMake(self.ball.frame.origin.x - view.frame.width / 2.34, self.ball.frame.origin.y);
            
            UIView.animateWithDuration(0.3, animations: {
                self.ball.frame = CGRectMake( ballPosition.x , ballPosition.y , self.ball.frame.size.width, self.ball.frame.size.height)
                
                self.canSwipeLeft = false
                self.canSwipeRight = true
                
            })
            
        }
        
        if (sender.direction == .Right) {
            if (!canSwipeRight) { return }
            print("Swipe Right")
            var ballPosition = CGPointMake(self.ball.frame.origin.x + view.frame.width / 2.34, self.ball.frame.origin.y);
            
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