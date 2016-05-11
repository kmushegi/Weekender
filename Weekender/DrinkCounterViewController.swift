//
//  FirstViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 4/26/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit

class DrinkCounterViewController: UIViewController {
    
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var drinkCount: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var bac: UILabel!
    @IBOutlet weak var bacLabel: UILabel!
    var calculator = BACalculator()
    
    var timer = NSTimer()
    var secondsPassed: Int = 0
    @IBOutlet weak var timerLabel: UILabel!
    
    let notification: UILocalNotification = UILocalNotification()
    
    private let userInfo = UserDefaults()
    
    let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
    
    let C = Constants()
    
    func setup() {
        
        backgroundImage.image = UIImage(named: "bkgd-blue-long")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        stepper.minimumValue = 0
        stepper.maximumValue = 20
        stepper.value = 0
        stepper.continuous = true
        stepper.autorepeat = false
        
        drinkCount.numberOfLines = 1
        drinkCount.text = stepper.value.description
        drinkLabel.alpha = C.alpha
        
        bac.numberOfLines = 1
        bac.adjustsFontSizeToFitWidth = true
        bac.alpha = 0.90
        bacLabel.alpha = C.alpha
        
        timerLabel.text = String(format:"%02i:%02i:%02i", 0, 0, 0)
    }
    
    func updateTimerLabel() {
        secondsPassed += 1
        let hours = Int(secondsPassed) / 3600
        let minutes = Int(secondsPassed) / 60 % 60
        let seconds = Int(secondsPassed) % 60
        timerLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        drinkCount.text = Int(sender.value).description
        
        if(stepper.value == 1) {
            timer  = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTimerLabel),userInfo: nil, repeats: true)
        } else if(stepper.value == 0) {
            timer.invalidate()
            secondsPassed = 0
            userInfo.secondsPassed = 0
        }
        
        switch stepper.value {
        case 0:
            bac.backgroundColor = UIColor.greenColor()
        case 4:
            bac.backgroundColor = UIColor.orangeColor()
        case 7:
            bac.backgroundColor = UIColor.redColor()
        default:
            break
        }
        
        if(stepper.value != 0) {
            notification.fireDate = NSDate.init(timeIntervalSinceNow: 30*60)
            notification.alertBody = "Don't Forget to Drink Water"
            notification.alertAction = "dismiss"
            notification.timeZone = NSTimeZone.localTimeZone()
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        let currentBAC = calculator.computeBAC(stepper.value, elapsedHours: Int(secondsPassed) / 3600)
        bac.text = String(currentBAC)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //activeAgain()
        setup()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DrinkCounterViewController.activeAgain), name: "UIApplicationDidBecomeActiveNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DrinkCounterViewController.goingAway), name: "UIApplicationWillResignActiveNotification", object: nil)
    }
    
    func activeAgain() {
        if(stepper.value > 0) {
            
            let timeInBackground = Int(NSDate().timeIntervalSince1970 - userInfo.suspendTime)
            secondsPassed = userInfo.secondsPassed + timeInBackground

            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        } else {
            secondsPassed = 0
            userInfo.secondsPassed = 0
            userInfo.suspendTime = 0.0
            timer.invalidate()
        }
    }
    
    func goingAway() {
        userInfo.secondsPassed = secondsPassed
        userInfo.suspendTime = NSDate().timeIntervalSince1970
        userInfo.consumedDrinks = Int(stepper.value)
        userInfo.currentBac = Double(bac.text!)!
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

