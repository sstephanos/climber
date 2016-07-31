//
//  GameViewController.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var dynamicAnimator = UIDynamicAnimator()
    
    var spike = Spike()
    var arrowShooter = ArrowShooter()
    let arrow = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        spike = Spike(frame: CGRectMake(view.center.x, view.center.y * 1.7, 40, 20))
        view.addSubview(spike)
        arrowShooter = ArrowShooter(frame: CGRectMake(view.center.x, view.center.y, 40, 20))
        view.addSubview(arrowShooter)
    }
}
