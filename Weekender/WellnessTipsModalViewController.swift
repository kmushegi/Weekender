//
//  WellnessTipsModalViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 5/8/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit

class WellnessTipsModalViewController: UIViewController {
    
    let C = Constants()
    
    var doneButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setup() {
        addDoneButton()
    }
    
    func addDoneButton() {
        doneButton = UIButton()
        doneButton?.frame = CGRectMake(C.doneButtonX, C.doneButtonY, C.doneButtonWidth, C.doneButtonHeight)
        doneButton?.setTitle(C.backButtonTitle, forState: .Normal)
        doneButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneButton?.setTitleColor(UIColor.grayColor(), forState: .Selected)
        doneButton?.backgroundColor = UIColor.purpleColor()
        doneButton?.layer.cornerRadius = C.doneButtonCornerRadius
        doneButton?.addTarget(self, action: #selector(WellnessTipsModalViewController.dismiss), forControlEvents: .TouchUpInside)
        self.view.addSubview(doneButton!)
    }
    
    func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
