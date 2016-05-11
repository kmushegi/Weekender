//
//  SecondViewController.swift
//  Weekender
//
//  Created by Konstantine Mushegian on 4/26/16.
//  Copyright © 2016 Konstantine Mushegian. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    let captureSession = AVCaptureSession()
    
    private var captureDevice : AVCaptureDevice?
    private var whichCamera   : AVCaptureDevicePosition?
    private var imageOutput   : AVCaptureStillImageOutput?
    private var previewLayer  : AVCaptureVideoPreviewLayer?
    
    private var imageOverlayView   : UIImageView?
    private var swipeRight         : UISwipeGestureRecognizer?
    private var swipeLeft          : UISwipeGestureRecognizer?
    private var currentOverlayPath : String?
    private var overlayImage       : UIImage?
    
    private var overlays = [String]()
    private var whichOverlay = 0
    
    private var takePhotoButton     : UIButton?
    private var flipCameraButton    : UIButton?
    private var bringTabsBackButton : UIButton?
    
    let c = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        whichCamera = AVCaptureDevicePosition.Back
        
        if(findCamera(whichCamera!)) {
            beginSession()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addtakePhotoButton()
        addflipCameraButton()
        addbringTabsBackButton()
        initializeOverlaysArray()
        
        if(currentOverlayPath == nil && overlayImage == nil) {
            currentOverlayPath = overlays[whichOverlay]
            overlayImage = UIImage(named: currentOverlayPath!)
        }
        
        addOverlay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func findCamera(cameraPos : AVCaptureDevicePosition) -> Bool {
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == whichCamera {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        return true
                    }
                }
            }
        }
        print("Cannot Find Capture Device")
        return false
    }
    
    func configureDevice() {
        if let device = captureDevice {
            try! device.lockForConfiguration()
            if device.isFocusModeSupported(.ContinuousAutoFocus) {
                device.focusMode = .ContinuousAutoFocus
            }
            device.unlockForConfiguration()
        }
    }
    
    
    func beginSession() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        configureDevice()
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch _ {
            print("[ERROR] Cannot add input")
        }
        
        if !captureSession.running {
            imageOutput = AVCaptureStillImageOutput()
            let outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            imageOutput!.outputSettings = outputSettings
            
            if captureSession.canAddOutput(imageOutput) {
                captureSession.addOutput(imageOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraView.layer.addSublayer(previewLayer!)
            previewLayer!.frame = self.view.layer.frame
            captureSession.startRunning()
        }
    }
    
    func stopSession() {
        if captureSession.running {
            let curInput = captureSession.inputs[0] as! AVCaptureInput
            captureSession.removeInput(curInput)
            captureSession.stopRunning()
        }
    }
    
    func addtakePhotoButton() {
        takePhotoButton = UIButton(type: UIButtonType.Custom) as UIButton
        let buttonImage = UIImage(named: c.takePhotoPath) as UIImage?
        
        let buttonX = self.view.frame.midX-c.takePhotoButtonSize/2
        let buttonY = self.view.frame.height - c.takePhotoButtonSize - c.takePhotoButtonBuffer
        
        takePhotoButton!.frame = CGRectMake(buttonX,buttonY, c.takePhotoButtonSize, c.takePhotoButtonSize)
        takePhotoButton!.setImage(buttonImage, forState: UIControlState.Normal)
        takePhotoButton!.addTarget(self, action: #selector(CameraViewController.takePhoto(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(takePhotoButton!)
    }
    
    func addflipCameraButton() {
        flipCameraButton = UIButton(type: UIButtonType.Custom) as UIButton
        let buttonImage = UIImage(named: c.flipPhotoPath) as UIImage?
        
        let buttonX = self.view.frame.width - c.flipCameraButtonSize - c.flipCameraButtonHorizontalBuffer
        
        flipCameraButton!.frame = CGRectMake(buttonX, 0, c.flipCameraButtonSize, c.flipCameraButtonSize)
        flipCameraButton!.setImage(buttonImage, forState: UIControlState.Normal)
        flipCameraButton!.addTarget(self, action: #selector(CameraViewController.flipCamera(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(flipCameraButton!)
    }
    
    func addbringTabsBackButton() {
        bringTabsBackButton = UIButton(type: UIButtonType.Custom) as UIButton
        let buttonImage = UIImage(named: c.tabsBackPhotoPath) as UIImage?
        
        bringTabsBackButton!.frame = CGRectMake(c.bringTabsBackButtonBuffer, c.bringTabsBackButtonBuffer, c.bringTabsBackButtonSize, c.bringTabsBackButtonSize)
        bringTabsBackButton!.setImage(buttonImage, forState: UIControlState.Normal)
        bringTabsBackButton!.addTarget(self, action: #selector(CameraViewController.bringTabsBack(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(bringTabsBackButton!)
    }
    
    func bringTabsBack(sender: UIButton!) {
        if(self.tabBarController?.tabBar.hidden == true) {
            self.tabBarController?.tabBar.hidden = false
        } else {
            self.tabBarController?.tabBar.hidden = true
        }
        
    }
    
    func flipCamera(sender: UIButton!) {
        captureSession.beginConfiguration()
        
        let curInput = captureSession.inputs[0] as! AVCaptureInput
        captureSession.removeInput(curInput)
        
        whichCamera = whichCamera == .Back ? .Front : .Back
        
        if findCamera(whichCamera!) {
            beginSession()
        }
        
        captureSession.commitConfiguration()
    }
    
    func findDeviceWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if(device.position == position){
                return device as! AVCaptureDevice
            }
        }
        return AVCaptureDevice()
    }
    
    func takePhoto(sender: UIButton!) {
        
        //MARK - Flash Screen
        let flashView: UIView = UIView(frame: self.cameraView.frame)
        flashView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(flashView)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            flashView.alpha = 0.0
            }, completion: { (finished : Bool) -> Void in
                flashView.removeFromSuperview()
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let connection = self.imageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
                
                connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
                
                self.imageOutput?.captureStillImageAsynchronouslyFromConnection(connection) {
                    (imageDataBuffer, error) -> Void in
                    if error == nil {
                        let outData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                        self.tookPhoto(outData)
                    }
                }
            }
        }
    }
    
    func tookPhoto(snapData: NSData) {
        if let image = UIImage(data: snapData) {
            
            let overlayImage = UIImage(named: currentOverlayPath!)
            
            let updatedImage = updatedOutputWithOverlay(image: overlayImage!, toImage: image, at: (imageOverlayView?.frame.origin)!)
            UIImageWriteToSavedPhotosAlbum(updatedImage, nil, nil, nil)
        }
    }
    
    func touchPercentage(touch : UITouch) -> CGPoint {
        let screenSize = UIScreen.mainScreen().bounds.size
        
        var touchPercent = CGPointZero
        
        touchPercent.x = touch.locationInView(self.view).x / screenSize.width
        touchPercent.y = touch.locationInView(self.view).y / screenSize.height
        
        return touchPercent
    }
    
    func computeOverlayPosition() -> CGPoint {
        let x = self.view.bounds.midX - (UIScreen.mainScreen().bounds.width - 5)/2
        let y = (takePhotoButton?.frame.origin.y)! - 130
        let position = CGPoint(x:x,y:y)
        return position
    }
    
    func computeOverlayRect() -> CGRect {
        let overlayPosition = computeOverlayPosition()
        let overlayRect = CGRectMake(overlayPosition.x, overlayPosition.y, UIScreen.mainScreen().bounds.width-5, 126)
        return overlayRect
    }
    
    func initializeOverlaysArray() {
        overlays.append(c.empty)
        overlays.append(c.mobile2016)
        overlays.append(c.searles)
    }
    
    func addOverlay() {
        if imageOverlayView != nil {
            imageOverlayView?.removeFromSuperview()
        }
        
        overlayImage! = UIImage(named: currentOverlayPath!)!
        imageOverlayView = UIImageView(image: overlayImage)
        
        let overlayRect = computeOverlayRect()
        imageOverlayView!.frame = overlayRect
        self.view.addSubview(imageOverlayView!)
        
        addSwipeGestureRecognizer()
    }
    
    func addSwipeGestureRecognizer() {
        swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(CameraViewController.handleSwipe(_:)))
        swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(CameraViewController.handleSwipe(_:)))
        swipeRight?.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight?.direction = UISwipeGestureRecognizerDirection.Left
        swipeRight?.numberOfTouchesRequired = 1
        swipeLeft?.numberOfTouchesRequired = 1
        cameraView?.addGestureRecognizer(swipeRight!)
        cameraView?.addGestureRecognizer(swipeLeft!)
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.Left {
            whichOverlay -= 1
            if(whichOverlay < 0) {
                whichOverlay = overlays.count-1
            }
            currentOverlayPath = overlays[whichOverlay]
            addOverlay()
        } else if(sender.direction == UISwipeGestureRecognizerDirection.Right) {
            whichOverlay += 1
            if(whichOverlay > overlays.count-1) {
                whichOverlay = 0
            }
            currentOverlayPath = overlays[whichOverlay]
            addOverlay()
        }
    }
    
    func updatedOutputWithOverlay(image foreground: UIImage, toImage background: UIImage, at point: CGPoint) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(background.size, false, 0.0)
        background.drawInRect(CGRectMake(0, 0, background.size.width, background.size.height))
        
        let foregroundTrueY = background.size.height - foreground.size.height*1.5
        
        foreground.drawInRect(CGRectMake(point.x,foregroundTrueY,background.size.width-5,foreground.size.height*1.2))
        let imageWithOverlay = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithOverlay
    }
}

