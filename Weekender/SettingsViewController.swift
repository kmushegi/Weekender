//
//  SettingsViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 4/26/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: UITableViewController, UITextFieldDelegate {
    
    private let userDefaults = UserDefaults()
    
    @IBOutlet weak var genderSelector: UISegmentedControl! {
        didSet {
            genderSelector.addTarget(self, action: #selector(SettingsViewController.storeGender(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func storeGender(segmentedController: UISegmentedControl) {
        userDefaults.gender = segmentedController.selectedSegmentIndex
    }
    
    @IBOutlet weak var weightSelector: UITextField! {
        didSet {
            weightSelector.addTarget(self, action: #selector(SettingsViewController.storeWeight(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        }
    }
    
    func storeWeight(weight: UITextField) {
        if let weightString = weight.text {
            let weight = Double(weightString)
            if weight != nil {
                userDefaults.weight = weight!
            }
        }
    }
    
    func addDoneButton() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0,0,320,50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,target: nil,action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",style: UIBarButtonItemStyle.Done, target: self, action: #selector(SettingsViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.weightSelector!.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.weightSelector.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        weightSelector.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButton()
        weightSelector.text = String(userDefaults.weight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
