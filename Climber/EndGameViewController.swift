//
//  EndGameViewController.swift
//  Climber
//
//  Created by SESP Walkup on 7/29/16.
//  Copyright © 2016 Simon Stephanos. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    var score = ""
    
    @IBOutlet weak var endScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endScoreLabel.text = "\(score)"

        // Do any additional setup after loading the view.
    }

}




