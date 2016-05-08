//
//  BACalculator.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 4/26/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import Foundation

class BACalculator {
    
    var weight = 0.0
    var gender = 0 //0 - male; 1 - female
    
    struct Constants {
        let femaleR = 0.55
        let maleR = 0.68
        let poundToGram = 453.6
        let alcoholGramsPerDrink = 14.0
    }
    
    var c = Constants()
    private let userInfo = UserDefaults()
    
    
    func poundsToGrams(weight: Double) -> Double {
        return weight * c.poundToGram
    }
    
    func roundWith4DigitsOfPrecision(n: Double) -> Double {
        let rounded = Double(round(1000*n)/1000)
        return rounded
    }
    
    func fetchInformation() {
        weight = userInfo.weight
        gender = userInfo.gender
    }
    
    func computeBAC(drinks: Double, elapsedHours: Int) -> Double {
        fetchInformation()

        let gramsOfAlcoholConsumed = c.alcoholGramsPerDrink * drinks
        let weightInGrams = poundsToGrams(weight)
        
        weight = userInfo.weight
        
        var gc: Double = -1
        if(gender == 0) {
            gc = c.maleR
        } else {
            gc = c.femaleR
        }
        
        let raw_number = weightInGrams * gc
        let raw_fraction = gramsOfAlcoholConsumed / raw_number
        let raw_percentage = raw_fraction * 100
        let timeEffect = (Double(elapsedHours) * 0.015)
        let true_percentage = raw_percentage - timeEffect
        let rounded_value = roundWith4DigitsOfPrecision(true_percentage)
        return rounded_value
    }
}

