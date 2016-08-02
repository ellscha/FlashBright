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
    let timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleStrobe(sender: UISwitch) {
        
        if switchStrobe.on{
            
            do {
                try device.lockForConfiguration()
                
                    device.torchMode = AVCaptureTorchMode.On
                    device.unlockForConfiguration()
            }catch{
                print("error turning on")
            }
            print("strobe is on")
        }else{
            
            do {
                try device.lockForConfiguration()
                
                device.torchMode = AVCaptureTorchMode.Off
                device.unlockForConfiguration()
            }catch{
                print("error turning off")
            }

            print("strobe is off")
        }

        
    }
    
}
