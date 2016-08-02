//
//  ViewController.swift
//  FlashBright
//
//  Created by Elli Scharlin on 7/27/16.
//  Copyright © 2016 ElliBelly. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var strobeSwitch: UISwitch!
    @IBOutlet weak var strobeRate: UISlider!
    
    var timer = NSTimer()
    var counter = 0
    var strobeOn: Bool = false
    var flashOn: Bool = false
    let device: AVCaptureDevice! = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //brightnessSlider.addTarget(self, action: Selector("sliderValueChanged:"), forControlEvents: .ValueChanged)
        //We will write this function in a few steps, but begin by naming it.
        //MAKE SURE YOU NAME YOUR FUNCTION THE SAME THING AS YOUR SELECTOR.
        strobeRate.hidden = false
        brightnessSlider.minimumValue =  0.0000001
        brightnessSlider.maximumValue = 1.0
        strobeRate.maximumValue = 2.0
        strobeRate.minimumValue = 1.0
        //strobeRate.addTarget(self, action: Selector("strobeRateChanged:"), forControlEvents: .ValueChanged)
//
//        self.enablingOnView()
//        strobeSwitch.enabled = true
        
        //        let device: AVCaptureDevice! = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //        do {
        //            try device.lockForConfiguration()
        //            device.unlockForConfiguration()
        //
        //        } catch{
        //            print("catch")
        //        }
        
        print("view did load \(device.torchActive)")
        
    }
    
    func enablingOnView(){
        
        if strobeOn {
            self.lightSwitch.hidden = true
            self.brightnessSlider.hidden = true
            self.strobeSwitch.hidden = false
            self.strobeRate.hidden = false
        }
        if flashOn {
            self.brightnessSlider.hidden = false
            self.lightSwitch.hidden = false
            self.strobeSwitch.hidden = true
            self.strobeRate.hidden = true
        }
        if !flashOn && !strobeOn {
            self.brightnessSlider.hidden = true
            self.lightSwitch.hidden = false
            self.strobeSwitch.hidden = false
            self.strobeRate.hidden = true
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider!) {
        //        let device: AVCaptureDevice! = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let currentValue : Float = sender.value
        do {
            try device.lockForConfiguration()
            do {
                try device.setTorchModeOnWithLevel(currentValue)
            } catch {
                print("error changing levels")
            }
            device.unlockForConfiguration()
        } catch {
            print("error with configuration")
        }
        
    }
    
    
    @IBAction func strobeRateChanged(sender: UISlider!){
        
        let timeInterval: NSTimeInterval = NSTimeInterval(sender.value)
        
        print(strobeOn)
        
        if strobeOn == true{
            print("strobe on true")
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: #selector(ViewController.turnOnLight), userInfo: nil, repeats: true)
        }else {
            print("else false strob on")
            
            timer.invalidate()
        }
        
        
    }
    
    
    
    func turnOnLight(){
        //        let device: AVCaptureDevice! = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            try device.lockForConfiguration()
            if (device.torchMode == AVCaptureTorchMode.On) {
                
                device.torchMode = AVCaptureTorchMode.Off
                print("turn off light")

            } else {
                print("turn on light")
                do {
                    try device.setTorchModeOnWithLevel(1.0)
                } catch {
                    print(error)
                }
            }
        } catch{
            print("error with device and strobe")
            
        }
        
    }
    
    
    func toggleStrobe(){
        print("touching")
        //        if counter == 0 {
        //            let alert = UIAlertController(title: "Caution, Strobe.", message: "Press okay to continue", preferredStyle: UIAlertControllerStyle.Alert)
        //
        //            // add an action (button)
        //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        //
        //            // show the alert
        //            self.presentViewController(alert, animated: true, completion: nil)
        //        }
        //        counter+=1
//        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if strobeSwitch.on == true {
                    
                    self.strobeOn = true
                    strobeRateChanged(strobeRate)
                } else {
                    //                    print("strobe off else statement")
                    //                    print("before \(device.torchActive)")
                    self.strobeOn = false
                    device.torchMode = AVCaptureTorchMode.Off
                    //                    print("after \(device.torchActive)")
                    timer.invalidate()
                    
                }
            }catch {
                print("error with torch")
            }
            device.unlockForConfiguration()
        }
    }
    
    //        if strobeSwitch.on{
    //            lightSwitch.enabled = false
    //            strobeRateChanged(strobeRate)
    //        } else if !strobeSwitch.on {
    //            lightSwitch.enabled = true
    //            let device: AVCaptureDevice! = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    //            do {
    //                try device.lockForConfiguration()
    //                device.torchMode = AVCaptureTorchMode.Off
    //                device.unlockForConfiguration()
    //            }catch {
    //                print("error with torch")
    //            }
    //
    //        }
    
    @IBAction func strobeTapped(sender: AnyObject) {
        print("touching action")
        
        self.toggleStrobe()
        strobeRate.hidden = false
//        self.enablingOnView()
        
//        if strobeRate.hidden == true{
//            timer.invalidate()
//            
//            device.torchMode = AVCaptureTorchMode.Off
//        }
    }
    
    @IBAction func lightSwitch(sender: AnyObject) {
        self.toggleFlash()
        //self.enablingOnView()
    }
    
    
    
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                    self.flashOn = false
                } else {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                        self.flashOn = true
                    }
                    catch {
                        print("turning on with mode error:")
                    }
                }
            }catch {
                print("error with torch")
            }
            device.unlockForConfiguration()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

