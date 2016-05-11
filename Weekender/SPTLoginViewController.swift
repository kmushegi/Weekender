//
//  MusicViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 5/5/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit
import MediaPlayer

class SPTLoginViewController: UIViewController, SPTAuthViewDelegate, SPTAudioStreamingPlaybackDelegate {
    
    let C = Constants()

    let auth = SPTAuth.defaultInstance()
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SPTLoginViewController.dismiss), name: "loginSuccessful", object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithSpotify(sender: UIButton) {
        auth.clientID = C.kClientID
        auth.redirectURL = NSURL(string: C.kCallbackURL)
        auth.tokenSwapURL = NSURL(string: C.kTokenSwapURL)
        auth.tokenRefreshURL = NSURL(string: C.kTokenRefreshServiceURL)
        auth.requestedScopes = [SPTAuthStreamingScope]
        
        let spotifyAuthenticationVC = SPTAuthViewController.authenticationViewController()
        spotifyAuthenticationVC.delegate = self
        
        spotifyAuthenticationVC.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        spotifyAuthenticationVC.definesPresentationContext = true
        
        presentViewController(spotifyAuthenticationVC, animated: false, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
        
        userDefaults.setObject(sessionData, forKey: "SpotifySession")
        userDefaults.synchronize()
        
        print("Login Successful")
        
        NSNotificationCenter.defaultCenter().postNotificationName("loginSuccessful", object: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        print("Login failed with error: \(error)")
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        print(" Login cancelled")
    }
    
    func dismiss(sender: UIButton) {
        self.performSegueWithIdentifier("loginsuccess", sender: sender)
    }
}
