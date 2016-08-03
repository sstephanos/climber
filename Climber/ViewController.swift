//
//  ViewController.swift
//  Climber
//
//  Created by Samone on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var ball = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ball = UIView(frame: CGRectMake(view.center.x, view.center.y, 25, 25))
        ball.backgroundColor = UIColor.whiteColor()
        ball.layer.cornerRadius = 13
        ball.clipsToBounds = true
        view.addSubview(ball)
        
    }
}



