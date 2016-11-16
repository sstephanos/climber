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
    
    var canChangeScore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //======================
        // Create walls and ball
        //======================
        
        wall1 = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.25, height: view.frame.height))
        wall1.backgroundColor = UIColor.darkGray
        view.addSubview(wall1)
        
        
        wall2 = UIView(frame: CGRect(x: view.frame.width * 0.75 , y: 0, width: view.frame.width / 4, height: view.frame.height))
        wall2.backgroundColor = UIColor.darkGray
        view.addSubview(wall2)
        
        ball = UIView(frame: CGRect(x: view.frame.width / 4, y: view.frame.width + 150, width: 26, height: 26))
        ball.backgroundColor = UIColor.white
        ball.layer.cornerRadius = 13
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        //=================================
        // Generate spikes and spawn chance
        //=================================
        
        // Ten spike limit on screen
        for _ in 0...9 {
            spikes.append(Spike(frame: CGRect(x: view.center.x, y: view.center.y, width: 80, height: 20)))
        }
       
        // Spike chance for spawn, multiplied w/number of spikes that are available for spawn because every spike is checked with the same chance
        spikeSpawnChance = 5
        
        //==================
        // Dynamic Behaviors
        //==================
        let spikeDynamicBehavior = UIDynamicItemBehavior(items: spikes)
        spikeDynamicBehavior.isAnchored = false
        spikeDynamicBehavior.allowsRotation = true
        dynamicAnimator.addBehavior(spikeDynamicBehavior)
        
        let arrowShooterDynamicBehavior = UIDynamicItemBehavior(items: [])
        arrowShooterDynamicBehavior.isAnchored = true
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
        collisionBehavior.collisionMode = .everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        //=====================
        // Timers for functions
        //=====================
        
        //Increments score
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameViewController.increment), userInfo: nil, repeats: true)
        //Spawns spikes on right wall
        _ = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(GameViewController.spikeRightWallRandomSpawn), userInfo: nil, repeats: true)
        //Delay for right wall death checker
        _ = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(GameViewController.handleRightWallDeathTimer), userInfo: nil, repeats: false)
        //Spawns spikes on left wall
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.spikeLeftWallTimedSpawn), userInfo: nil, repeats: true)
        //Delay for left wall death checker
        _ = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(GameViewController.handleLeftWallDeathTimer), userInfo: nil, repeats: false)
        
        
        //================
        // Swipe Variables
        //================
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    //================================
    // Actual Swipe Direction Function
    //================================
    
    func canSwipeLeftMakeTrue() {
        canSwipeLeft = true
    }
    
    func canSwipeRightMakeTrue() {
        canSwipeRight = true
    }
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            if (!canSwipeLeft) { return }
            //print("Swipe Left")
            let ballPosition = CGPoint(x: self.wall1.frame.width, y: self.ball.frame.origin.y)
            UIView.animate(withDuration: 0.3, animations: {
                self.ball.frame = CGRect(x: ballPosition.x, y: ballPosition.y, width: self.ball.frame.size.width, height: self.ball.frame.size.height)
                self.dynamicAnimator.updateItem(usingCurrentState: self.ball)
                self.canSwipeLeft = false
                }, completion: { (completion) in
            })
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameViewController.canSwipeRightMakeTrue), userInfo: nil, repeats: false)
        }
        if (sender.direction == .right) {
            if (!canSwipeRight) { return }
            //print("Swipe Right")
            let ballPosition = CGPoint(x: self.view.frame.width - (self.wall2.frame.width + 26), y: self.ball.frame.origin.y)
            UIView.animate(withDuration: 0.3, animations: {
                self.ball.frame = CGRect(x: ballPosition.x, y: ballPosition.y, width: self.ball.frame.size.width, height: self.ball.frame.size.height)
                self.dynamicAnimator.updateItem(usingCurrentState: self.ball)
                self.canSwipeRight = false
                }, completion: { (completion) in
            })
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameViewController.canSwipeLeftMakeTrue), userInfo: nil, repeats: false)
        }
    }
    
    //====================
    // Time Label Function
    //====================
    
    func increment() {
        if canChangeScore {
            score += 1
            scoreCounterLabel.text = String(score)
        }
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
    
    func spikeAnimatorHelperAnimations(_ spike: Spike, rightSide: Bool) {
        spike.spawned = true
        spike.center = rightSide ? CGPoint(x: 3 * view.frame.width / 4, y: 0) : CGPoint(x: view.frame.width / 4, y: 0)
        view.addSubview(spike)
        view.sendSubview(toBack: spike)
        if rightSide {
            _ = Timer.scheduledTimer(timeInterval: 1.29, target: self, selector: #selector(GameViewController.yesSpikeOnRightWall), userInfo: nil, repeats: false)
        }
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .allowAnimatedContent, animations: {
            spike.center.y = self.view.frame.height + spike.frame.height / 2
            self.dynamicAnimator.updateItem(usingCurrentState: spike)
            }, completion: { (completed) in
                spike.spawned = false
                spike.removeFromSuperview()
        })
        
    }
    
    func spikeAnimatorHelperWallSides(_ rightSide: Bool) {
        for spike in spikes {
            if spike.spawned == false {
                if rightSide {
                    let spawnChanceRange = Int(arc4random_uniform(100))
                    if spawnChanceRange < spikeSpawnChance {
                        spikeAnimatorHelperAnimations(spike, rightSide: rightSide)
                        break
                    } else {
                        _ = Timer.scheduledTimer(timeInterval: 1.29, target: self, selector: #selector(GameViewController.noSpikeOnRightWall), userInfo: nil, repeats: false)
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
    
    //Reason for double view controller: On the right side, when two spikes spawn right after another and the first hits you, the second somehow still hits you too. Maybe solve this with a canDie boolean
    
    func handleRightWallDeathTimer() {
        _ = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(GameViewController.rightWallDeath), userInfo: nil, repeats: true)
    }
    
    func rightWallDeath() {
        if canSwipeLeft && spikeOnRightWall {
            canChangeScore = false
            performSegue(withIdentifier: "EndGame", sender: nil)
        }
    }
    
    func handleLeftWallDeathTimer() {
        _ = Timer.scheduledTimer(timeInterval: 1.00, target: self, selector: #selector(GameViewController.leftWallDeath), userInfo: nil, repeats: true)
    }
    
    func leftWallDeath() {
        if canSwipeRight {
            canChangeScore = false
            performSegue(withIdentifier: "EndGame", sender: nil)
        }
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if (item1.isEqual(ball) && item2 is Spike) || (item2.isEqual(ball) && item1 is Spike) {
            //performSegueWithIdentifier("EndGame", sender: nil)
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! EndGameViewController
        dvc.score = "\(score)"
    }
        
}
