//
//  AboutViewController.swift
//  Wayfarer
//
//  Created by Akash Sonthalia on 15/04/17.
//  Copyright © 2017 Akash Sonthalia. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var fgView: UIView!
    @IBOutlet weak var logoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        applyMotionEffect(toView: bgView!, magnitude: 20)
        applyMotionEffect(toView: fgView!, magnitude: -20)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Motion Effect Function 🐒
    func applyMotionEffect(toView view:UIView,magnitude:Float){
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion,yMotion]
        view.addMotionEffect(group)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
