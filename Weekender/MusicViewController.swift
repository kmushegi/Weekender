//
//  MusicViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 5/8/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    
    var player = SPTAudioStreamingController?()
    let auth = SPTAuth.defaultInstance()
    var session = SPTSession()
    
    let kClientID = "4f47cb86c66d4d7592bb2c48f875ba68"
    let kCallbackURL = "weekender://returnafterlogin"
    //let kTokenSwapURL = "https://thawing-tundra-45046.herokuapp.com/swap"
    //let kTokenRefreshServiceURL = "https://thawing-tundra-45046.herokuapp.com/refresh"
    let kTokenSwapURL = "http://localhost:1234/swap"
    let kTokenRefreshServiceURL = "http://localhost:1234/refresh"
    
    var needsSessionRefresh = false
    var sessionIsRefreshing = false
    var newUser = false
    var refreshingTokens = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spotifyUserCheck()
        self.timeToPlayMusic()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        if player == nil && newUser == true {
            self.playUsingSession(auth.session)
        } else {
            print("Player is ok")
        }
    }
    
    func timeToPlayMusic() {
        if session.isValid() {
            sessionIsRefreshing = false
        }
        
        if !session.isValid() && sessionIsRefreshing == false {
            self.renewToken(session)
        }
        
        self.useLoggedInPermissions("spotify:user:1250305260:playlist:2CQkLloZ3kSclgsrIP09sg")
    }
    
    func spotifyUserCheck() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let seshObj : AnyObject = userDefaults.objectForKey("SpotifySession") {
            print("Already Logged In")
            newUser = false
            
            let sessionObjectData = seshObj as! NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionObjectData) as! SPTSession
            print(seshObj)
            
            if !session.isValid() {
                print("Session Invalid. Need Token Refresh")
                needsSessionRefresh = true
                self.renewToken(session)
            } else {
                self.playUsingSession(session)
            }
        } else {
            newUser = true
            //segue to log in
        }
    }
    
    func playUsingSession(session: SPTSession) {
        if player == nil {
            player = SPTAudioStreamingController(clientId: kClientID)
            player!.playbackDelegate = self
            player!.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64)
        }
        
        player?.loginWithSession(session, callback: { (error: NSError!) -> Void in
            if error != nil {
                print("Session login error")
            }
        })
    }
    
    func useLoggedInPermissions(playlistURI: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Check")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession Active Check")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        player?.shuffle = true
        player?.playURIs([NSURL(string: playlistURI)!], withOptions: nil, callback: nil)
    }
    
    func renewToken(invalidSession: SPTSession) {
        sessionIsRefreshing = true
        print("Refreshing Token")
        
        auth.tokenSwapURL = NSURL(string: kTokenSwapURL)
        auth.tokenRefreshURL = NSURL(string: kTokenRefreshServiceURL)
        
        auth.renewSession(invalidSession, callback: { (error, session) -> Void in
            if error == nil {
                self.saveNewSession(session)
                self.playUsingSession(session)
                self.refreshingTokens = true
            } else {
                print("The issue with renewing session is \(error)")
            }
        })
    }
    
    func saveNewSession(newSession: SPTSession) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(newSession)
        
        userDefaults.setObject(sessionData, forKey: "SpotifySession")
        userDefaults.synchronize()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event!.type == UIEventType.RemoteControl{
            if event!.subtype == UIEventSubtype.RemoteControlPause {
                print("Player Pause")
                player?.stop(nil)
            } else if event!.subtype == UIEventSubtype.RemoteControlNextTrack {
                print("Player Next")
                
                let callback: SPTErrorableOperationCallback = { error -> Void in
                    if(error != nil) {
                        print("Player Error")
                    } else {
                        print("Playing Next Song")
                    }
                }
                player!.skipNext(callback)
            }
        }
    }

}
