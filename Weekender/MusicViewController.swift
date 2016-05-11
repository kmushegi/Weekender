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
    
    var player  = SPTAudioStreamingController?()
    let auth    = SPTAuth.defaultInstance()
    var session = SPTSession()
    
    var needsSessionRefresh = false
    var sessionIsRefreshing = false
    var newUser             = false
    var refreshingTokens    = false
    
    let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
    
    let C = Constants()
    
    @IBOutlet weak var nowPlayingLabel  : UILabel!
    @IBOutlet weak var songLabel        : UILabel!
    @IBOutlet weak var artistLabel      : UILabel!
    @IBOutlet weak var albumLabel       : UILabel!
    
    private var playPauseButton : UIButton?
    private var nextButton      : UIButton?
    
    let c = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spotifyUserCheck()
        self.timeToPlayMusic()
        setup()
    }
    
    func setup() {
        backgroundImage.image = UIImage(named: "bkgd-green-long")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        nowPlayingLabel?.alpha = 0.75
        songLabel?.alpha = 0.75
        albumLabel?.alpha = 0.75
        artistLabel?.alpha = 0.75
        
        addPlayPauseButton()
        addNextButton()
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
        
        self.useLoggedInPermissions(c.AHSAlternative)
    }
    
    func spotifyUserCheck() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let seshObj : AnyObject = userDefaults.objectForKey("SpotifySession") {
            print("Already Logged In")
            newUser = false
            
            let sessionObjectData = seshObj as! NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionObjectData) as! SPTSession
            
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
            player = SPTAudioStreamingController(clientId: C.kClientID)
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
        
        auth.tokenSwapURL = NSURL(string: C.kTokenSwapURL)
        auth.tokenRefreshURL = NSURL(string: C.kTokenRefreshServiceURL)
        
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
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
        let songTitle = trackMetadata["SPTAudioStreamingMetadataTrackName"]
        let songArtist = trackMetadata["SPTAudioStreamingMetadataArtistName"]
        let songAlbum = trackMetadata["SPTAudioStreamingMetadataAlbumName"]
        
        if(songTitle != nil) {
            songLabel!.text = "Song: \(songTitle!)"
        }
        if(songArtist != nil) {
            artistLabel!.text = "Artist: \(songArtist!)"
        }
        if(songAlbum != nil){
            albumLabel!.text = "Album: \(songAlbum!)"
        }
    }
    
    func addPlayPauseButton() {
        playPauseButton = UIButton(type: UIButtonType.Custom) as UIButton
        let buttonImage = UIImage(named: c.pausePath) as UIImage?
        
        let buttonX = c.takePhotoButtonBuffer
        let buttonY = self.view.frame.height - c.playPauseButtonSize * 3 - c.takePhotoButtonBuffer
        
        playPauseButton!.frame = CGRectMake(buttonX,buttonY, c.takePhotoButtonSize * 2, c.takePhotoButtonSize * 2)
        playPauseButton!.setImage(buttonImage, forState: UIControlState.Normal)
        playPauseButton!.addTarget(self, action: #selector(MusicViewController.playPauseTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(playPauseButton!)
    }
    
    func addNextButton() {
        nextButton = UIButton(type: UIButtonType.Custom) as UIButton
        let buttonImage = UIImage(named: c.nextPath) as UIImage?
        
        let buttonX = self.view.frame.width - c.playPauseButtonSize * 2 - c.takePhotoButtonBuffer
        let buttonY = self.view.frame.height - c.playPauseButtonSize * 3 - c.takePhotoButtonBuffer
        
        nextButton!.frame = CGRectMake(buttonX,buttonY, c.takePhotoButtonSize * 2, c.takePhotoButtonSize * 2)
        nextButton!.setImage(buttonImage, forState: UIControlState.Normal)
        nextButton!.addTarget(self, action: #selector(MusicViewController.nextTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(nextButton!)
    }
    
    
    func playPauseTapped(sender: UIButton!) {
        if(sender.currentImage == UIImage(named: c.pausePath)) {
            sender.setImage(UIImage(named: c.playPath), forState: .Normal)
            player?.stop(nil)
        } else {
            sender.setImage(UIImage(named: c.pausePath), forState: .Normal)
            self.useLoggedInPermissions(c.AHSAlternative)
        }
    }
    
    func nextTapped(sender: UIButton!) {
        let callback: SPTErrorableOperationCallback = { error -> Void in
            if(error != nil) {
                print("Player Error")
            } else {
                print("Playing Next Song")
            }
        }
        player!.skipNext(callback)
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event!.type == UIEventType.RemoteControl{
            if event!.subtype == UIEventSubtype.RemoteControlPause {
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
