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
    var collidingObjects: [UIDynamicItem] = []
    
    var spikes: [Spike] = []
    var spikeSpawnChance = 0
    var arrowShooter = ArrowShooter()
    var ball = UIView()
    var wall1 = UIView()
    var wall2 = UIView()
    var canSwipeLeft = false
    var canSwipeRight = true
    var spikeOnRightWall = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //======================
        // Create walls and ball
        //======================
        
        wall1 = UIView(frame: CGRectMake(0, 0, view.frame.width / 4, view.frame.height))
        wall1.backgroundColor = UIColor.darkGrayColor()
        view.addSubview(wall1)
        
        
        wall2 = UIView(frame: CGRectMake(view.frame.width * 0.75 , 0, view.frame.width / 4, view.frame.height))
        wall2.backgroundColor = UIColor.darkGrayColor()
        view.addSubview(wall2)
        
        ball = UIView(frame: CGRectMake(view.center.x - view.frame.width / 4.07, view.frame.width + 150, 26, 26))
        ball.backgroundColor = UIColor.whiteColor()
        ball.layer.cornerRadius = 13
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        //=================================
        // Generate spikes and spawn chance
        //=================================
        
        // Ten spike limit on screen
        for _ in 0...9 {
            spikes.append(Spike(frame: CGRectMake(view.center.x, view.center.y, 80, 20)))
        }
       
        // Spike chance for spawn, multiplied w/number of spikes that are available for spawn because every spike is checked with the same chance
        spikeSpawnChance = 5
        
        //==================
        // Dynamic Behaviors
        //==================
        let spikeDynamicBehavior = UIDynamicItemBehavior(items: spikes)
        spikeDynamicBehavior.anchored = false
        spikeDynamicBehavior.allowsRotation = true
        dynamicAnimator.addBehavior(spikeDynamicBehavior)
        
        let arrowShooterDynamicBehavior = UIDynamicItemBehavior(items: [])
        arrowShooterDynamicBehavior.anchored = true
        arrowShooterDynamicBehavior.angularResistance = 10.0
        dynamicAnimator.addBehavior(arrowShooterDynamicBehavior)
        
        let arrowDynamicBehavior = UIDynamicItemBehavior(items: [])
        arrowDynamicBehavior.friction = 0.5
        arrowDynamicBehavior.resistance = 0.1
        dynamicAnimator.addBehavior(arrowDynamicBehavior)
        
        let wallDynamicBehavior = UIDynamicItemBehavior(items: [wall1, wall2])
        wallDynamicBehavior.density = 10000
        wallDynamicBehavior.resistance = 100
        wallDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(wallDynamicBehavior)
        
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 0
        ballDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)

        //==========
        // Collision
        //==========
        
        //Maybe eventually add walls to collisions
        
        collidingObjects.append(ball)
        for spike in spikes {
            collidingObjects.append(spike)
        }
        
        collisionBehavior = UICollisionBehavior(items: collidingObjects)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        //=====================
        // Timers for functions
        //=====================
        
        //Increments score
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameViewController.increment), userInfo: nil, repeats: true)
        //Spawns spikes on right wall
        _ = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(GameViewController.spikeRightWallRandomSpawn), userInfo: nil, repeats: true)
        //Delay for right wall death checker
        _ = NSTimer.scheduledTimerWithTimeInterval(1.22, target: self, selector: #selector(GameViewController.handleRightWallDeathTimer), userInfo: nil, repeats: false)
        //Spawns spikes on left wall
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameViewController.spikeLeftWallTimedSpawn), userInfo: nil, repeats: true)
        //Delay for left wall death checker
        _ = NSTimer.scheduledTimerWithTimeInterval(1.22, target: self, selector: #selector(GameViewController.handleLeftWallDeathTimer), userInfo: nil, repeats: false)
        
        
        //================
        // Swipe Variables
        //================
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    //================================
    // Actual Swipe Direction Function
    //================================
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            if (!canSwipeLeft) { return }
            print("Swipe Left")
            let ballPosition = CGPointMake(self.ball.frame.origin.x - view.frame.width / 2.34, self.ball.frame.origin.y)
            UIView.animateWithDuration(0.3, animations: {
                self.ball.frame = CGRectMake(ballPosition.x, ballPosition.y, self.ball.frame.size.width, self.ball.frame.size.height)
                self.dynamicAnimator.updateItemUsingCurrentState(self.ball)
                self.canSwipeLeft = false
                }, completion: { (completion) in
                    self.canSwipeRight = true
            })
        }
        if (sender.direction == .Right) {
            if (!canSwipeRight) { return }
            print("Swipe Right")
            let ballPosition = CGPointMake(self.ball.frame.origin.x + view.frame.width / 2.34, self.ball.frame.origin.y)
            UIView.animateWithDuration(0.3, animations: {
                self.ball.frame = CGRectMake(ballPosition.x, ballPosition.y, self.ball.frame.size.width, self.ball.frame.size.height)
                self.dynamicAnimator.updateItemUsingCurrentState(self.ball)
                self.canSwipeRight = false
                }, completion: { (completion) in
                    self.canSwipeLeft = true
            })
        }
    }
    
    //====================
    // Time Label Function
    //====================
    
    func increment() {
        score += 1
        scoreCounterLabel.text = String(score)
    }
    
    //=========================
    // Spike spawning functions
    //=========================
    
    func yesSpikeOnRightWall() {
        spikeOnRightWall = true
    }
    
    func noSpikeOnRightWall() {
        spikeOnRightWall = false
    }
    
    func spikeAnimatorHelperAnimations(spike: Spike, rightSide: Bool) {
        spike.spawned = true
        spike.center = rightSide ? CGPoint(x: 3 * view.frame.width / 4, y: 0) : CGPoint(x: view.frame.width / 4, y: 0)
        view.addSubview(spike)
        view.sendSubviewToBack(spike)
        _ = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(GameViewController.yesSpikeOnRightWall), userInfo: nil, repeats: false)
        UIView.animateWithDuration(2.0, delay: 0.0, options: .AllowAnimatedContent, animations: {
            spike.center.y = self.view.frame.height + spike.frame.height / 2
            self.dynamicAnimator.updateItemUsingCurrentState(spike)
            }, completion: { (completed) in
                spike.spawned = false
                spike.removeFromSuperview()
        })
        
    }
    
    func spikeAnimatorHelperWallSides(rightSide: Bool) {
        for spike in spikes {
            if spike.spawned == false {
                if rightSide {
                    let spawnChanceRange = Int(arc4random_uniform(100))
                    if spawnChanceRange < spikeSpawnChance {
                        spikeAnimatorHelperAnimations(spike, rightSide: rightSide)
                        break
                    } else {
                        _ = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: #selector(GameViewController.noSpikeOnRightWall), userInfo: nil, repeats: false)
                    }
                } else {
                    spikeAnimatorHelperAnimations(spike, rightSide: false)
                    break
                }
            }
        }
    }
    
    func spikeRightWallRandomSpawn() {
        spikeAnimatorHelperWallSides(true)
    }
    
    func spikeLeftWallTimedSpawn() {
        spikeAnimatorHelperWallSides(false)
        
    }
    
    //============================
    // Collision Behavior Function + Timer for checking the collision
    //============================
    
    func handleRightWallDeathTimer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(GameViewController.rightWallDeath), userInfo: nil, repeats: true)
    }
    
    func rightWallDeath() {
        if canSwipeLeft && spikeOnRightWall {
            performSegueWithIdentifier("EndGame", sender: nil)
        }
    }
    
    func handleLeftWallDeathTimer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1.00, target: self, selector: #selector(GameViewController.leftWallDeath), userInfo: nil, repeats: true)
    }
    
    func leftWallDeath() {
        if canSwipeRight {
            performSegueWithIdentifier("EndGame", sender: nil)
        }
    }

    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        if (item1.isEqual(ball) && item2 is Spike) || (item2.isEqual(ball) && item1 is Spike) {
            //performSegueWithIdentifier("EndGame", sender: nil)
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! EndGameViewController
        dvc.score = "\(score)"
    }
        
}