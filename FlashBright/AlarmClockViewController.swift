//
//  AlarmClock.swift
//  FlashBright
//
//  Created by Elli Scharlin on 8/9/16.
//  Copyright © 2016 ElliScharlin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVFoundation.AVAudioSession


class AlarmClockViewController:UIViewController{
    
    @IBOutlet weak var alarmPicker: UIDatePicker!
    
    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var onTimer = NSTimer()
    var offTimer = NSTimer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
    }

    
    func scheduleLocalNotification(date: NSDate){
        let notification : UILocalNotification = UILocalNotification()
        notification.fireDate = date
        notification.alertBody = "Time to get moving!"
        notification.soundName = "alarm-clock-1.caf"
        
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        notification.performSelector(#selector(strobeTheLight), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: false)
        
        
    }
    
    
    func presentMessage(message:String){
        let alert : UIAlertController = UIAlertController.init(title: "Alarm Clock", message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
    }
    @IBAction func alarmSetTapped(sender: AnyObject) {
        print("alarm set button tapped")
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.formatterBehavior = NSDateFormatterBehavior.BehaviorDefault
        let dateTimeString = dateFormatter.stringFromDate(alarmPicker.date)
        print("Alarm set for \(dateTimeString)")
        self.presentMessage("Alarm set!")
        self.scheduleLocalNotification(alarmPicker.date)
    }
    
    
    
    @IBAction func alarmCancelTapped(sender: AnyObject) {
        print("Alarm cancel tapped")
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        self.presentMessage("Alarm cancelled")
        
    }
    
    
    func turnLightOn(){
        do {
            try device.lockForConfiguration()
            device.torchMode = AVCaptureTorchMode.On
            device.unlockForConfiguration()
        }catch{
            print("error turning on")
        }
    }
    
    func turnLightOff(){
        do {
            try device.lockForConfiguration()
            
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }catch{
            
            print("error turning off")
        }
    }

    
    
    func strobeTheLight(){
        
        let stepperValueAbs = 1.0
        performSelector(#selector(self.delayLightOff), withObject: nil, afterDelay: 0.1)
        self.onTimer = NSTimer.scheduledTimerWithTimeInterval(stepperValueAbs, target: self, selector:#selector(self.turnLightOn), userInfo: nil, repeats: true)
        
        
    }
    func delayLightOff(){
        let stepperValueAbs = 1.0
        
        self.offTimer = NSTimer.scheduledTimerWithTimeInterval(stepperValueAbs, target: self, selector:#selector(self.turnLightOff), userInfo: nil, repeats: true)
    }

    
    
}