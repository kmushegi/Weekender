//
//  UserDefaults.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 4/28/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import Foundation
import UIKit

class UserDefaults {
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    private struct Key {
        static let gender = "UserDefaults.Key.gender"
        static let weight = "UserDefaults.Key.weight"
        static let secondsPassed = "UserDefaults.Key.secondsPassed"
        static let suspendTime = "UserDefaults.Key.suspendTime"
        static let consumedDrinks = "UserDefaults.Key.consumedDrinks"
        static let currentBac = "UserDefaults.Key.currentBac"
    }
    
    private struct DefaultUserSettings {
        static let weight: Double = 175.0
        static let gender: Int = 0
        static let secondsPassed: Int = 0
        static let suspendTime: Double = 0
        static let consumedDrinks: Int = 0
        static let currentBac: Double = 0.000
    }
    
    var weight: Double {
        get {
            return userDefaults.objectForKey(Key.weight) as? Double ?? DefaultUserSettings.weight
        }
        set {
            userDefaults.setObject(newValue, forKey: Key.weight)
            userDefaults.synchronize()
        }
    }
    
    var gender: Int {
        get {
            return userDefaults.objectForKey(Key.gender) as? Int ?? DefaultUserSettings.gender
        }
        set {
            userDefaults.setObject(newValue, forKey: Key.gender)
            userDefaults.synchronize()
        }
    }
    
    var secondsPassed: Int {
        get {
            return userDefaults.objectForKey(Key.secondsPassed) as? Int ?? 0
        }
        set {
            userDefaults.setObject(newValue, forKey: Key.secondsPassed)
            userDefaults.synchronize()
        }
    }
    
    var suspendTime: Double {
        get {
            return userDefaults.objectForKey(Key.suspendTime) as? Double ?? 0.0
        }
        set {
            userDefaults.setObject(newValue, forKey: Key.suspendTime)
            userDefaults.synchronize()
        }
    }
    
    var consumedDrinks: Int {
        get {
            return userDefaults.objectForKey(Key.consumedDrinks) as? Int ?? 0
        }
        set {
            userDefaults.setObject(newValue, forKey: Key.consumedDrinks)
            userDefaults.synchronize()
        }
    }
    
    var currentBac: Double {
        get {
            return userDefaults.objectForKey(Key.currentBac) as? Double ?? 0.000
        }
        set {
            userDefaults.setObject(newValue, forKey: Key.currentBac)
            userDefaults.synchronize()
        }
    }
}
