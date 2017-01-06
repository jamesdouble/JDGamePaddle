//
//  ViewController.swift
//  JDGamePaddle
//
//  Created by JamesDouble on 2017/1/6.
//  Copyright © 2017年 jamesdouble. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JDPaddleVectorDelegate {

    var paddle:JDGamePaddle!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        paddle = JDGamePaddle(forUIView: self.container, size: container.frame.size)
        paddle.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getVector(vector:CGVector)
    {
        xLabel.text = "x:\(vector.dx)"
        yLabel.text = "y:\(vector.dy)"
    }

}

