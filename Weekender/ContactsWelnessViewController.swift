//
//  ContactsViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 5/8/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit

class ContactsWellnessViewController: UIViewController {

    @IBOutlet weak var contactsView: UIScrollView!
    
    var securityEmergencyButton     : UIButton?
    var securityNonEmergencyButton  : UIButton?
    var pubButton                   : UIButton?
    var wellnessTipsButton          : UIButton?
    var assistingOthersButton       : UIButton?
    
    let C = Constants()
    
    let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
    
    var buttonPositionX  : CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = UIImage(named: "bkgd-blue-long")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        contactsView.contentSize = self.view.frame.size
        self.view.addSubview(contactsView)
        
        addSecurityEmergency()
        addSecurityNonEmergency()
        addPub()
        addWellness()
        addAssistingOthers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSecurityEmergency() {
        securityEmergencyButton = UIButton()
        setUpButton(securityEmergencyButton!)
        securityEmergencyButton!.backgroundColor = UIColor.redColor()
        securityEmergencyButton?.setTitle(C.securityEmergencyTitle, forState: .Normal)
        securityEmergencyButton?.addTarget(self, action: #selector(ContactsWellnessViewController.callSecurityEmergency), forControlEvents: .TouchUpInside)
        contactsView.addSubview(securityEmergencyButton!)
    }
    
    func addSecurityNonEmergency() {
        securityNonEmergencyButton = UIButton()
        setUpButton(securityNonEmergencyButton!)
        securityNonEmergencyButton!.backgroundColor = UIColor.orangeColor()
        securityNonEmergencyButton?.setTitle(C.securityNonEmergencyTitle, forState: .Normal)
        securityNonEmergencyButton?.addTarget(self, action: #selector(ContactsWellnessViewController.callSecurityNonEmergency), forControlEvents: .TouchUpInside)
        contactsView.addSubview(securityNonEmergencyButton!)
    }
    
    func addPub() {
        pubButton = UIButton()
        setUpButton(pubButton!)
        pubButton!.backgroundColor = UIColor.brownColor()
        pubButton?.setTitle(C.pubTitle, forState: .Normal)
        pubButton?.addTarget(self, action: #selector(ContactsWellnessViewController.callPub), forControlEvents: .TouchUpInside)
        pubButton?.layer.cornerRadius = C.buttonCornerRadius
        contactsView.addSubview(pubButton!)
    }
    
    func addWellness() {
        wellnessTipsButton = UIButton()
        setUpButton(wellnessTipsButton!)
        wellnessTipsButton!.backgroundColor = UIColor.blueColor()
        wellnessTipsButton?.setTitle(C.wellnessTitle, forState: .Normal)
        wellnessTipsButton?.addTarget(self, action: #selector(ContactsWellnessViewController.wellnessSegue), forControlEvents: .TouchUpInside)
        contactsView.addSubview(wellnessTipsButton!)
    }
    
    func addAssistingOthers() {
        assistingOthersButton = UIButton()
        setUpButton(assistingOthersButton!)
        assistingOthersButton!.backgroundColor = UIColor.purpleColor()
        assistingOthersButton?.setTitle(C.assistanceTitle, forState: .Normal)
        assistingOthersButton?.addTarget(self, action: #selector(ContactsWellnessViewController.assistanceSegue), forControlEvents: .TouchUpInside)
        contactsView.addSubview(assistingOthersButton!)
        
    }
    
    @objc private func callSecurityEmergency(sender: UIButton!) {
        callNumber(C.securityEmergency)
    }
    
    @objc private func callSecurityNonEmergency(sender: UIButton!) {
        callNumber(C.securityNonEmergency)
    }
    
    @objc private func callPub(sender: UIButton!) {
        callNumber(C.pub)
    }
    
    @objc private func wellnessSegue(sender: UIButton!) {
        performSegueWithIdentifier("wellnessSegue", sender: self)
    }
    
    @objc private func assistanceSegue(sender: UIButton!) {
        performSegueWithIdentifier("assistanceSegue", sender: self)
    }
    
    private func setUpButton(button: UIButton) {
        button.frame = CGRectMake(self.view.bounds.midX-C.buttonWidth/2, buttonPositionX, C.buttonWidth, C.buttonHeight)
        buttonPositionX += C.buttonBuffer + C.buttonHeight
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        button.layer.cornerRadius = C.buttonCornerRadius
    }
    
    private func callNumber(number: String) {
        if let numberURL : NSURL = NSURL(string: "tel:\(number)") {
            let app : UIApplication = UIApplication.sharedApplication()
            if app.canOpenURL(numberURL) {
                app.openURL(numberURL)
            }
        }
    }

}
