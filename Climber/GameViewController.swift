//
//  GameViewController.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate
    
    {
    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    
    var spike = Spike()
    var arrowShooter = ArrowShooter()
    var ball = UIView()
    var wall1 = UIView()
    var wall2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //=======================
        // Spike and Arrow Logic
        //=======================
        
        spike = Spike(frame: CGRectMake(view.center.x, view.center.y * 1.7, 40, 20))
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
       
        //================
        //Wall Objects
        //================
        
        wall1 = UIView(frame: CGRectMake(0, 0, view.frame.width / 4, view.frame.height))
        wall1.backgroundColor = UIColor.grayColor()
        view.addSubview(wall1)
        
        
        wall2 = UIView(frame: CGRectMake(view.frame.width * 0.75 , 0, view.frame.width / 4, view.frame.height))
        wall2.backgroundColor = UIColor.grayColor()
        view.addSubview(wall2)

        //===========
        //Ball Object
        //===========
        
        ball = UIView(frame: CGRectMake(view.center.x - view.frame.width / 4, view.frame.width + 150, 26, 26))
        ball.backgroundColor = UIColor.blackColor()
        ball.layer.cornerRadius = 13
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        //================
        // Swipe Variables
        //================
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
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
            print("Swipe Left")
            var ballPosition = CGPointMake(self.ball.frame.origin.x - view.frame.width / 2.34, self.ball.frame.origin.y);
            
            UIView.animateWithDuration(0.3, animations: {
                self.ball.frame = CGRectMake( ballPosition.x , ballPosition.y , self.ball.frame.size.width, self.ball.frame.size.height)
            })
            
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            var ballPosition = CGPointMake(self.ball.frame.origin.x + view.frame.width / 2.34, self.ball.frame.origin.y);
            UIView.animateWithDuration(0.3, animations: {
                self.ball.frame = CGRectMake( ballPosition.x , ballPosition.y , self.ball.frame.size.width, self.ball.frame.size.height)
            })
        }
    }
    
}
