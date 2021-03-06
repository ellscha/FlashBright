//
//  StrobeViewController.swift
//  FlashBright
//
//  Created by Elli Scharlin on 8/2/16.
//  Copyright © 2016 ElliBelly. All rights reserved.
//

import UIKit
import AVFoundation
import AVFoundation.AVAudioSession


class StrobeViewController: UIViewController {
    //I want the stepper to affect the strobe light in real time. I also want the intensity slider to affect in real time. I want flashlight to take precedence? Or keep it to no interaction?
    
    @IBOutlet weak var switchStrobe: UISwitch!
    @IBOutlet weak var sliderStrobe: UISlider!
    
    @IBOutlet weak var switchFlashlight: UISwitch!
    @IBOutlet weak var sliderFlashlight: UISlider!
    
    
    @IBOutlet weak var flashlightIcon: UILabel!
    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var onTimer = NSTimer()
    var offTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashlightIcon.hidden = true
        switchStrobe.enabled = true
        switchFlashlight.enabled = true
        
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
    }
    
    
    @IBAction func toggleFlashlight(sender: AnyObject) {
        if switchFlashlight.on {
            //            sliderFlashlight.enabled = true
            sliderValueChanged(sliderFlashlight)
            switchStrobe.enabled = false
        }else{
            switchStrobe.enabled = true
            turnLightOff()
            flashlightIcon.hidden = true

        }
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider!) {
        flashlightIcon.alpha = CGFloat(sender.value)
        flashlightIcon.hidden = false

        if switchFlashlight.on{
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
    }
    
    
    @IBAction func toggleStrobe(sender: UISwitch) {
        
        if switchStrobe.on{
            let alertController = UIAlertController(title: "Strobe Warning", message: "Strobe light effect warning. If you suffer from epilepsy & other visual light stimulation, please click 'Cancel'.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                print("cancelled strobe for caution.")
                self.switchStrobe.on = false
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.strobeTheLight(Double(self.sliderStrobe.value))
                print("strobe is on")
                self.switchFlashlight.enabled = false            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                //To show alert.
            }
        }else{
            switchFlashlight.enabled = true
            onTimer.invalidate()
            offTimer.invalidate()
            turnLightOff()
            flashlightIcon.hidden = true
            print("strobe is off")
            
        }
        
    }
    
    func turnLightOn(){
        flashlightIcon.alpha = 1.0
        flashlightIcon.hidden = true
        
        do {
            try device.lockForConfiguration()
            device.torchMode = AVCaptureTorchMode.On
            device.unlockForConfiguration()
        }catch{
            print("error turning on")
        }
    }
    
    func turnLightOff(){
        flashlightIcon.alpha = 1.0

        flashlightIcon.hidden = false
        do {
            try device.lockForConfiguration()
            
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }catch{
            
            print("error turning off")
        }
    }
    
    func strobeTheLight(stepperValue: Double){
        
        let stepperValueAbs = fabs(stepperValue)
        performSelector(#selector(self.delayLightOff(_:)), withObject: nil, afterDelay: 0.1)
        
        onTimer = NSTimer.scheduledTimerWithTimeInterval(stepperValueAbs, target: self, selector:#selector(self.turnLightOn), userInfo: nil, repeats: true)
        
    }
    
    func delayLightOff(stepperValue: Double){
        let stepperValueAbs = fabs(stepperValue)
        
        offTimer = NSTimer.scheduledTimerWithTimeInterval(stepperValueAbs, target: self, selector:#selector(self.turnLightOff), userInfo: nil, repeats: true)
    }
    
    @IBAction func stepperChanged(sender: UISlider) {
        onTimer.invalidate()
        offTimer.invalidate()
        print(sender.value)
        if switchStrobe.on{
            strobeTheLight(Double(sender.value))
        }
        
        
    }
    
    
}
