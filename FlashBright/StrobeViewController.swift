//
//  StrobeViewController.swift
//  FlashBright
//
//  Created by Elli Scharlin on 8/2/16.
//  Copyright © 2016 ElliBelly. All rights reserved.
//

import UIKit
import AVFoundation

class StrobeViewController: UIViewController {
    //I want the stepper to affect the strobe light in real time. I also want the intensity slider to affect in real time. I want flashlight to take precedence? Or keep it to no interaction?
    
    @IBOutlet weak var switchStrobe: UISwitch!
    @IBOutlet weak var stepperStrobe: UIStepper!
    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var onTimer = NSTimer()
    var offTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let slowImage = UIImage.init(named: "slow")
//        let fastImage = UIImage.init(named: "fast")
//        stepperStrobe.setIncrementImage(fastImage, forState: .Normal)
//        stepperStrobe.setDecrementImage(slowImage, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleStrobe(sender: UISwitch) {
        
        if switchStrobe.on{
           strobeTheLight(stepperStrobe.value)
            print("strobe is on")

        }else{
            onTimer.invalidate()
            offTimer.invalidate()
            turnLightOff()
            print("strobe is off")

        }
    
    }
    
    func turnLightOn(){
        
        do {
            try device.lockForConfiguration()
            
            device.torchMode = AVCaptureTorchMode.On
            device.unlockForConfiguration()
        }catch{
            print("error turning on")
        }
        print("light is on")
        
    }

    func turnLightOff(){
        do {
            try device.lockForConfiguration()
            
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }catch{
            
            print("error turning off")
        }
        
        print("light is off")
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
    
    @IBAction func stepperChanged(sender: UIStepper) {
        onTimer.invalidate()
        offTimer.invalidate()
        strobeTheLight(sender.value)
        
        
    }
    
    
}