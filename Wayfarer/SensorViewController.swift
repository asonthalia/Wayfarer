//
//  SensorViewController.swift
//  Wayfarer
//
//  Created by Akash Sonthalia on 15/04/17.
//  Copyright © 2017 Akash Sonthalia. All rights reserved.
//

import UIKit
import Lottie

class SensorViewController: UIViewController {

    @IBOutlet weak var tShirtFront: UIImageView!
    @IBOutlet weak var tShirtBack: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pelRefViewRightFront: UIView!
    @IBOutlet weak var pelRefViewLeft: UIView!
    @IBOutlet weak var pelRefView1Back: UIView!
    @IBOutlet weak var pelRefView2Back: UIView!
    @IBOutlet weak var pelRefView4Back: UIView!
    @IBOutlet weak var pelRefView3Back: UIView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var backContainerView: UIView!
    
    var hot = 0
    var jsonname:String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let url: String = "https://thingspeak.com/channels/258554/feeds?api_key=PJS3LQB22M21QG37"
    let serialQueue = DispatchQueue(label: "com.wf.serial")
    
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    //MARK: Flag 0 means Front is active ; 1 means Back is active
    var flag = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchvalues()
        
        if(hot == 1){
            jsonname = "red"
        }
        if(hot == 0){
            jsonname = "blue"
        }
        
        
        
        backContainerView.alpha = 0.0
        
        logoAnimationFront()
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SensorViewController.handlePan(recognizer:)))
        
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        

        // Do any additional setup after loading the view.
    }
    
    
    
    func dataOfJSON(url: String) -> NSDictionary {
        let data = NSData(contentsOf: NSURL(string: url)! as URL)
        //var error: NSError?
        if data == nil {
            return [:]
        }
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            return jsonArray
            
            
        } catch _ {
            return [:]
        }
        
        
    }
    
    
    func fetchvalues(){
        self.serialQueue.sync {
            let data = self.dataOfJSON(url: url)
            let feeds = data["feeds"] as! NSArray
            let lastDict = feeds[feeds.count - 1] as! NSDictionary
            
            print(lastDict)
            let ambientTemperature = lastDict["field2"] as! String
            let internalTemperature = lastDict["field3"] as! String
            
            let at = Int(ambientTemperature)
            let it = Int(internalTemperature)
            
            if( at! >= it! )
            {
                hot = 0
            }
            else
            {
                hot = 1
            }
            
            
        }
    
    }
    
    
    func handlePan(recognizer: UIPanGestureRecognizer ){
        let translation = recognizer.translation(in: self.view)
        let progress = translation.x / self.view.bounds.size.width
        
        if((progress > 0.5) && (flag == 0))
        {
            self.logoAnimationBack()
            flag = 1
            
        }
        
        else if((progress < -0.5) && (flag == 1))
        {
            self.logoAnimationFront()
            flag = 0
            
        }
        
        print(progress)
    }
    
    func logoAnimationFront(){
        
        //tShirtBack.alpha = 1.0
        //logoView.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            self.tShirtBack.alpha = 0.0
            self.logoView.alpha = 1.0
            self.tShirtFront.alpha = 1.0
            self.backContainerView.alpha = 0.0

            
        })
        
        let animationView = LOTAnimationView(name: jsonname)
        animationView?.frame = pelRefViewLeft.frame
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopAnimation = true
        animationView?.play()
        self.containerView.addSubview(animationView!)
        
        let animationView2 = LOTAnimationView(name: jsonname)
        animationView2?.frame = pelRefViewRightFront.frame
        animationView2?.contentMode = .scaleAspectFit
        animationView2?.loopAnimation = true
        animationView2?.play()
        self.containerView.addSubview(animationView2!)
        
        
    }
    
    func logoAnimationBack(){
        
        //tShirtFront.alpha = 1.0
        //logoView.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: {
            self.tShirtFront.alpha = 0.0
            self.logoView.alpha = 0.0
            self.tShirtBack.alpha = 1.0
            self.backContainerView.alpha = 1.0
        
        })
        
        
        let animationView = LOTAnimationView(name: jsonname)
        animationView?.frame = pelRefView1Back.frame
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopAnimation = true
        animationView?.play()
        self.backContainerView.addSubview(animationView!)
        
        let animationView2 = LOTAnimationView(name: jsonname)
        animationView2?.frame = pelRefView2Back.frame
        animationView2?.contentMode = .scaleAspectFit
        animationView2?.loopAnimation = true
        animationView2?.play()
        self.backContainerView.addSubview(animationView2!)
        
        let animationView3 = LOTAnimationView(name: jsonname)
        animationView3?.frame = pelRefView3Back.frame
        animationView3?.contentMode = .scaleAspectFit
        animationView3?.loopAnimation = true
        animationView3?.play()
        self.backContainerView.addSubview(animationView3!)
        
        let animationView4 = LOTAnimationView(name: jsonname)
        animationView4?.frame = pelRefView4Back.frame
        animationView4?.contentMode = .scaleAspectFit
        animationView4?.loopAnimation = true
        animationView4?.play()
        self.backContainerView.addSubview(animationView4!)
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
