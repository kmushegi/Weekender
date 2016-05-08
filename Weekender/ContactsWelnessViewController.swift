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
    
    let c = Constants()
    
    var buttonPosition: CGFloat = 50
    let buttonBuffer: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsView.contentSize = self.view.frame.size
        self.view.addSubview(contactsView)
        
        addSecurityEmergency()
        addSecurityNonEmergency()
        addPub()
        addWellness()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSecurityEmergency() {
        securityEmergencyButton = UIButton()
        setUpButton(securityEmergencyButton!)
        securityEmergencyButton!.backgroundColor = UIColor.redColor()
        securityEmergencyButton?.setTitle(c.securityEmergencyTitle, forState: .Normal)
        securityEmergencyButton?.addTarget(self, action: #selector(ContactsWellnessViewController.callSecurityEmergency), forControlEvents: .TouchUpInside)
        contactsView.addSubview(securityEmergencyButton!)
    }
    
    func addSecurityNonEmergency() {
        securityNonEmergencyButton = UIButton()
        setUpButton(securityNonEmergencyButton!)
        securityNonEmergencyButton!.backgroundColor = UIColor.orangeColor()
        securityNonEmergencyButton?.setTitle(c.securityNonEmergencyTitle, forState: .Normal)
        securityNonEmergencyButton?.addTarget(self, action: #selector(ContactsWellnessViewController.callSecurityNonEmergency), forControlEvents: .TouchUpInside)
        contactsView.addSubview(securityNonEmergencyButton!)
    }
    
    func addPub() {
        pubButton = UIButton()
        setUpButton(pubButton!)
        pubButton!.backgroundColor = UIColor.blueColor()
        pubButton?.setTitle(c.pubTitle, forState: .Normal)
        pubButton?.addTarget(self, action: #selector(ContactsWellnessViewController.callPub), forControlEvents: .TouchUpInside)
        pubButton?.layer.cornerRadius = c.buttonCornerRadius
        contactsView.addSubview(pubButton!)
    }
    
    func addWellness() {
        wellnessTipsButton = UIButton()
        setUpButton(wellnessTipsButton!)
        wellnessTipsButton!.backgroundColor = UIColor.greenColor()
        wellnessTipsButton?.setTitle(c.wellnessTitle, forState: .Normal)
        wellnessTipsButton?.addTarget(self, action: #selector(ContactsWellnessViewController.wellnessSegue), forControlEvents: .TouchUpInside)
        contactsView.addSubview(wellnessTipsButton!)
    }
    
    func addAssistingOthers() {
        assistingOthersButton = UIButton()
        setUpButton(assistingOthersButton!)
        assistingOthersButton!.backgroundColor = UIColor.purpleColor()
        assistingOthersButton?.setTitle(c.assistanceTitle, forState: .Normal)
        assistingOthersButton?.addTarget(self, action: #selector(ContactsWellnessViewController.assistanceSegue), forControlEvents: .TouchUpInside)
        
    }
    
    @objc private func callSecurityEmergency(sender: UIButton!) {
        callNumber(c.securityEmergency)
    }
    
    @objc private func callSecurityNonEmergency(sender: UIButton!) {
        callNumber(c.securityNonEmergency)
    }
    
    @objc private func callPub(sender: UIButton!) {
        callNumber(c.pub)
    }
    
    @objc private func wellnessSegue(sender: UIButton!) {
        performSegueWithIdentifier("wellness", sender: sender)
    }
    
    @objc private func assistanceSegue(sender: UIButton!) {
        performSegueWithIdentifier("assistance", sender: sender)
    }
    
    private func setUpButton(button: UIButton) {
        button.frame = CGRectMake(self.view.bounds.midX-c.buttonWidth/2, buttonPosition, c.buttonWidth, c.buttonHeight)
        buttonPosition += buttonBuffer + c.buttonHeight
        button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        button.layer.cornerRadius = c.buttonCornerRadius
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
