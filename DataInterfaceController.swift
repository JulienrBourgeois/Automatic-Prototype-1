//
//  DataInterfaceController.swift
//  Automatic WatchKit Extension
//
//  Created by Julien Developer on 7/22/22.
//

import WatchKit
import Foundation
import CoreMotion


class DataInterfaceController: WKInterfaceController, WKExtendedRuntimeSessionDelegate {
    
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("")
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        recordData()
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("")
    }
    
    
    
    
    
    @IBOutlet var recordButton : WKInterfaceButton!
    
    var session : WKExtendedRuntimeSession!
    
    var motionManager = CMMotionManager()
    var timer : Timer?
    
    var accelerometerIsAvailable : Bool = false
    var gyrometerIsAvailable : Bool = false
    var recording : Bool = false
    
    var intervalCounter = 0
    
    var motionData = DataCollection()
    
    
    @IBAction func recordButtonPressed()
    {
        if gyrometerIsAvailable && accelerometerIsAvailable
        {
            motionManager.startAccelerometerUpdates()
            motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical)
            motionManager.deviceMotionUpdateInterval = 1.0 / 100.0
            motionManager.accelerometerUpdateInterval = 10.0 / 100.0
            
            session = WKExtendedRuntimeSession()
            session.delegate = self
            session.start()
        }
    }
    
    func recordData()
    {
        
        timer = Timer(fire : Date(), interval: (1/100.0), repeats: true, block: { [self] (timer) in
            
            if accelerometerIsAvailable && gyrometerIsAvailable
            {
                let aData = motionManager.accelerometerData
                let gData = motionManager.deviceMotion
                
                motionData.accelX.append(Double(round(100 * (aData?.acceleration.x)! ) / 100))
                motionData.accelY.append(Double(round(100 * (aData?.acceleration.y)! ) / 100))
                motionData.accelZ.append(Double(round(100 * (aData?.acceleration.z)! ) / 100))

                motionData.gyroX.append(Double(round(100 * (gData?.userAcceleration.z)! ) / 100))
                
                motionData.gyroY.append(Double(round(100 * (gData?.userAcceleration.y)! ) / 100))
                
                motionData.gyroZ.append(Double(round(100 * (gData?.userAcceleration.z)! ) / 100))
                

            }
            else
            {
                timer.invalidate()
            }
            
            
            intervalCounter += 1
            
            print(intervalCounter)
            
            if intervalCounter >= 300
            {
                timer.invalidate()
                ConvertDataToFile()
            }
        })
        
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
    }
    
    
    func ConvertDataToFile()
    {
        if motionData.isFull()
        {
            motionData.wrapIntoDict()
            motionData.convertToCSV()
        }
        else
        {
            print("motion data is not full")
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if motionManager.isAccelerometerAvailable
        {
            accelerometerIsAvailable = true
        }
        else
        {
            accelerometerIsAvailable = false
        }
        
        if motionManager.isDeviceMotionAvailable
        {
            gyrometerIsAvailable = true
        }
        else
        {
            gyrometerIsAvailable = false
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}


class DataCollection
{
    var accelX : [Double] = []
    var accelY : [Double] = []
    var accelZ : [Double] = []
    var gyroX : [Double] = []
    var gyroY : [Double] = []
    var gyroZ : [Double] = []
    var dct = Dictionary<String,[Double]>()
    
    
    
    func isFull() -> Bool
    {
        if accelX.count >= 300
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    func wrapIntoDict()
    {
        dct.updateValue(accelX, forKey: "AccelerometerX")
        dct.updateValue(accelY, forKey: "AccelerometerY")
        dct.updateValue(accelZ, forKey: "AccelerometerZ")
        dct.updateValue(gyroX, forKey:"GyrometerX")
        dct.updateValue(gyroY, forKey: "GyrometerY")
        dct.updateValue(gyroZ, forKey: "GyrometerZ")
        
    }
    
    func convertToCSV()
    {
        var csvString : String = ""
        
        var counter = 0
        
        for(key,value) in dct
        {
            counter += 1
            
            if counter < 6
            {
                csvString += "\(key),"
            }
            else
            {
                csvString += "\(key)\n"
            }
        }
        
        counter = 0
        
        
        for i in 0...accelX.count-1
        {
            for(key,value) in dct
            {
                csvString += "\(value[i]),"
            }
            
            if i != accelX.count - 1
            {
            csvString += "\n"
            }
           
        }
        
        
        print(csvString)
        
        let fileName = "Data \(1)"
        let documentDirectoryUrl = try! FileManager.default.url(
           for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("csv")
        // prints the file path
        print("File path \(fileUrl.path)")
        
        let stringData = csvString
           do {
              try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
               
               print("Saved")
           } catch let error as NSError {
              print (error)
           }
        
        var readFile = ""
              do {
                 readFile = try String(contentsOf: fileUrl)
              } catch let error as NSError {
                 print(error)
              }
              print (readFile)
    }
    
    
   
}
