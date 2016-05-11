//
//  Constants.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 5/8/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import Foundation

class Constants {
    
    //MARK - Random GUI Constants
    let alpha: CGFloat = 0.75
    
    //MARK - BAC Constants
    let femaleR              = 0.55
    let maleR                = 0.68
    let poundToGram          = 453.6
    let alcoholGramsPerDrink = 14.0
    
    //MARK - Camera Constants
    let takePhotoButtonSize:   CGFloat = 75
    let takePhotoButtonBuffer: CGFloat = 5
    
    let flipCameraButtonSize:             CGFloat = 50
    let flipCameraButtonHorizontalBuffer: CGFloat = 5
    
    let bringTabsBackButtonSize:    CGFloat = 25
    let bringTabsBackButtonBuffer: CGFloat = 10
    
    
    //MARK - Image Paths
    let takePhotoPath     = "shoot.png"
    let flipPhotoPath     = "flipCamera.png"
    let tabsBackPhotoPath = "exit.png"
    
    let empty      = "empty.png"
    let mobile2016 = "mobile2016.png"
    let searles    = "searlesOverlay.png"
    
    //MARK - Contact Constants
    let buttonWidth:        CGFloat = 200
    let buttonHeight:       CGFloat = 70
    let buttonCornerRadius: CGFloat = 5
    
    let securityEmergency    = "2077253500"
    let securityNonEmergency = "2077253314"
    let pub                  = "2077253430"
    
    let securityEmergencyTitle    = "Bowdoin Security \n(EMERGENCY)"
    let securityNonEmergencyTitle = "Bowdoin Security \n(Non-Emergency)"
    let pubTitle                  = "Jack Magee's Pub"
    let wellnessTitle             = "Wellness Tips"
    let assistanceTitle           = "Assisting Others"
    
    //MARK - Music Constants
    let playPath  = "play.png"
    let pausePath = "pause.png"
    let nextPath  = "next.png"
    
    let playPauseButtonSize: CGFloat = 75
    
    let AHSAlternative = "spotify:user:1250305260:playlist:2CQkLloZ3kSclgsrIP09sg"
    
    //MARK - Spotify API
    let kClientID               = "4f47cb86c66d4d7592bb2c48f875ba68"
    let kCallbackURL            = "weekender://returnafterlogin"
    //let kTokenSwapURL         = "https://thawing-tundra-45046.herokuapp.com/swap"
    //let kTokenRefreshServiceURL = "https://thawing-tundra-45046.herokuapp.com/refresh"
    let kTokenSwapURL           = "http://localhost:1234/swap"
    let kTokenRefreshServiceURL = "http://localhost:1234/refresh"
    
    //MARK - Contacts, Wellness, Assistance
    let doneButtonX:            CGFloat = 5
    let doneButtonY:            CGFloat = 5
    let doneButtonWidth:        CGFloat = 60
    let doneButtonHeight:       CGFloat = 20
    let doneButtonCornerRadius: CGFloat = 5
    let buttonBuffer:           CGFloat = 40
    
    let backButtonTitle = "Back"
    
}