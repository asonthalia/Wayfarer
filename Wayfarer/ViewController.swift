//
//  ViewController.swift
//  Wayfarer
//
//  Created by Akash Sonthalia on 14/04/17.
//  Copyright © 2017 Akash Sonthalia. All rights reserved.
//

//PJS3LQB22M21QG37

import UIKit
import HomeKit


class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var degCent: UILabel!
    @IBOutlet weak var degCent2: UILabel!
    @IBOutlet weak var degCent3: UILabel!
    @IBOutlet weak var degFar2: UILabel!
    @IBOutlet weak var degFar: UILabel!
    @IBOutlet weak var defFar3: UILabel!
    @IBOutlet weak var tempCounter: CountingLabel!
    @IBOutlet weak var ambientTemp: UILabel!
    @IBOutlet weak var diffTemp: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var degreeToggle: UIButton!
    @IBOutlet weak var postureRating: UILabel!
    @IBOutlet weak var postureComment: UILabel!
    
    let url: String = "https://thingspeak.com/channels/258554/feeds?api_key=PJS3LQB22M21QG37"
    let serialQueue = DispatchQueue(label: "com.wf.serial")
    
    let homeManager = HMHomeManager()

    
    var temp = 10.0
    
    //MARK: To select the scale of the temperature 0 cent 1 far
    var choiceScale = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: HomeKit Setup 🏠
        homeKitSetup()
        
        updateTempScale()
        fetchvalues()
        
        //counter()
        applyMotionEffect(toView: bgView!, magnitude: 20)
        
    }
    
    func homeKitSetup(){
        
        initHomeSetup()
        
        let image = #imageLiteral(resourceName: "log")
        
    }
    
    
    
    private func initHomeSetup(){
        
        //MARK: Add a new Home 🏡
        homeManager.addHome(withName: "Jacket", completionHandler: {(home, error) -> Void in
            if error != nil{
                print("Something went wrong while creating the house.")
            }
            else{
                
                //MARK: Add new room to home 🕋
                home?.addRoom(withName: "Body", completionHandler: {(room,error) -> Void in
                    if  error != nil{
                        print("Something wrong went while creating your room")
                    }
                    else{
                        self.updateControllerWithHome(home: home!)
                    }
                
                })
                
                self.homeManager.updatePrimaryHome(home!, completionHandler: {(error) -> Void in
                
                    if error != nil{
                        print("Something went wrong while assigning the Priary Room")
                        
                        
                    }
                
                })
                
            }
        
        
        })
        
    }
    
    func updateControllerWithHome(home: HMHome){
    
    }
    
    func counter(){
        tempCounter.count(fromValue: 0.0, to: Float(temp), withDuration: 2.5, andAnimationType: .EaseOut, andCountingType: .Float)

    }
    
    func updateTempScale(){
        
        if(choiceScale == 0)
        {
            degCent.alpha = 1.0
            degFar.alpha = 0.2
            
            degCent2.alpha = 1.0
            degFar2.alpha = 0.2
            
            degCent3.alpha = 1.0
            defFar3.alpha = 0.2
        }
        
        if(choiceScale == 1)
        {
            degFar.alpha = 1.0
            degCent.alpha = 0.2
            
            degFar2.alpha = 1.0
            degCent2.alpha = 0.2
            
            defFar3.alpha = 1.0
            degCent3.alpha = 0.2
        }

        
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
            let slouchDegree = lastDict["field1"] as! String
            let ambientTemperature = lastDict["field2"] as! String
            let internalTemperature = lastDict["field3"] as! String
            
            self.temp = Double(internalTemperature)!
            self.ambientTemp.text = ambientTemperature
            self.diffTemp.text = "\(Int(ambientTemperature)! - Int(internalTemperature)!)"
            print(internalTemperature)
            
            if(Int(slouchDegree)! <= 195)
            {
                postureRating.text = "5"
                postureRating.textColor = UIColor(colorLiteralRed: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
                postureComment.text = "Excellent"
                postureComment.textColor = UIColor(colorLiteralRed: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            }
                
            
            else if(Int(slouchDegree)! > 196 && Int(slouchDegree)! <= 199)
            {
                postureRating.text = "4"
                postureRating.textColor = UIColor(colorLiteralRed: 0.5, green: 1.0, blue: 0.0, alpha: 1.0)
                postureComment.text = "Very Good"
                postureComment.textColor = UIColor(colorLiteralRed: 0.5, green: 1.0, blue: 0.0, alpha: 1.0)
            }
                
            
            else if(Int(slouchDegree)! > 200 && Int(slouchDegree)! <= 205)
            {
                postureRating.text = "3"
                postureRating.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
                postureComment.text = "Good"
                postureComment.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
            }
            
            else if(Int(slouchDegree)! >= 206 && Int(slouchDegree)! <= 215)
            {
                postureRating.text = "2"
                postureRating.textColor = UIColor(colorLiteralRed: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
                postureComment.text = "Not Good"
                postureComment.textColor = UIColor(colorLiteralRed: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
            }
            
            else if(Int(slouchDegree)! > 215)
            {
                postureRating.text = "1"
                postureRating.textColor = UIColor(colorLiteralRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
                postureComment.text = "Bad"
                postureComment.textColor = UIColor(colorLiteralRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            
            
            counter()
        }
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

    @IBAction func toggleAction(_ sender: Any) {
        
        //MARK: Make F to Degree C
        if(self.choiceScale == 1){
            degreeToggle.setTitle("°F" , for: .normal )
            self.choiceScale = 0
            updateTempScale()
            
            //
            let b = self.temp
            self.temp = (b - 32) * 5/9
            counter()
            
            //Ambient Faren
            
        }
        
        //MARK: Degree F
        else{
            degreeToggle.setTitle("°C", for: .normal)
            self.choiceScale = 1
            updateTempScale()
            
            self.temp = self.temp * 9/5 + 32
            counter()
            
            //Ambient Faren
            
            }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

