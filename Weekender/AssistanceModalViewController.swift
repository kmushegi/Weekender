//
//  AssistanceModalViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 5/8/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit

class AssistanceModalViewController: UIViewController {

    var doneButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.magentaColor()
        addDoneButton()
        
    }
    
    func addDoneButton() {
        doneButton = UIButton()
        doneButton?.frame = CGRectMake(0, 5, 60, 20)
        doneButton?.setTitle("Done", forState: .Normal)
        doneButton?.setTitleColor(UIColor.cyanColor(), forState: .Normal)
        doneButton?.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        doneButton?.backgroundColor = UIColor.purpleColor()
        doneButton?.layer.cornerRadius = 5
        doneButton?.addTarget(self, action: #selector(WellnessTipsModalViewController.dismiss), forControlEvents: .TouchUpInside)
        self.view.addSubview(doneButton!)
    }
    
    func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
