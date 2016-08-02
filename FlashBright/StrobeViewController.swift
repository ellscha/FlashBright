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
    
    @IBOutlet weak var switchStrobe: UISwitch!
    @IBOutlet weak var stepperStrobe: UIStepper!
    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var onTimer = NSTimer()
    var offTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleStrobe(sender: UISwitch) {
        
        if switchStrobe.on{
           strobeTheLight()
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
    
    func strobeTheLight(){
        
        performSelector(#selector(self.delayLightOff), withObject: nil, afterDelay: 0.1)

         onTimer = NSTimer.scheduledTimerWithTimeInterval(0.50, target: self, selector:#selector(self.turnLightOn), userInfo: nil, repeats: true)

    }
    
    func delayLightOff(){
        
        offTimer = NSTimer.scheduledTimerWithTimeInterval(0.50, target: self, selector:#selector(self.turnLightOff), userInfo: nil, repeats: true)
    }
    
    
}
