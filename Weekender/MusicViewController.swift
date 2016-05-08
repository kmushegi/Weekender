//
//  MusicViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 5/5/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    
    let ClientID = "4f47cb86c66d4d7592bb2c48f875ba68"
    let CallbackURL = "weekender://returnafterlogin"
    let TokenSwapURL = "http://localhost:1234/swap"
    let TokenRefreshServiceURL = "http://localhost:1234/refresh"

    var session: SPTSession!
    var player:  SPTAudioStreamingController?
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicViewController.updateAfterFirstLogin), name: "loginSuccessfull", object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") { // session available
            let sessionDataObj = sessionObj as! NSData
            
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, callback: { (error:NSError!, renewedSession:SPTSession!) -> Void in
                    if error == nil {
                        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        
                        self.session = renewedSession
                        self.playSession(renewedSession)
                    }else{
                        print("error refreshing session")
                    }
                })
            }else{
                print("session valid")
                self.session = session
                playSession(session)
            }
        }else{
            loginButton.hidden = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func updateAfterFirstLogin () {
        loginButton.hidden = true
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
            let sessionDataObj = sessionObj as! NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            playSession(firstTimeSession)
            
        }
    }

    
    func playSession(sessionObj:SPTSession!){
        if player == nil {
            player = SPTAudioStreamingController(clientId: ClientID)
            player?.playbackDelegate = self
        }
        
        player?.loginWithSession(sessionObj, callback: { (error:NSError!) -> Void in
            if error != nil {
                print("Enabling playback got error \(error)")
                return
            }
            
            /*SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), withSession: sessionObj, callback: { (error:NSError!, albumObj:AnyObject!) -> Void in
             if error != nil {
             println("Album lookup got error \(error)")
             return
             }
             
             let album = albumObj as SPTAlbum
             
             self.player?.playTrackProvider(album, callback: nil)
             })*/
            
            SPTRequest.performSearchWithQuery("let it go", queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: nil, callback: { (error:NSError!, result:AnyObject!) -> Void in
                let trackListPage = result as! SPTListPage
                
                let partialTrack = trackListPage.items.first as! SPTPartialTrack
                
                SPTRequest.requestItemFromPartialObject(partialTrack, withSession: nil, callback: { (error:NSError!, results:AnyObject!) -> Void in
                    let track = results as! SPTTrack
                    self.player?.playTrackProvider(track, callback: nil)
                })
                
                
            })
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithSpotify(sender: UIButton) {
        let auth = SPTAuth.defaultInstance()
        
        auth.clientID = ClientID
        auth.redirectURL = NSURL(string: CallbackURL)
        auth.tokenSwapURL = NSURL(string: TokenSwapURL)
        auth.tokenRefreshURL = NSURL(string: TokenRefreshServiceURL)
        auth.requestedScopes = [SPTAuthStreamingScope]
        
        let loginURL = auth.loginURL
        UIApplication.sharedApplication().openURL(loginURL)
    }
}
