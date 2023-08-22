//
//  BluetoothViewController.swift
//  Assignment1
//
//  Created by Inito on 22/08/23.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController, CBPeripheralDelegate {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var bluetoothStatusLabel: UILabel!
    
    

    private var centralManager: CBCentralManager!
    var discoveredPeripherals = [CBPeripheral]()
    
    var connectedPeripheral: CBPeripheral?
    
    var randomNumbaeChar: CBCharacteristic?
    var randomNumberGanaraterChar: CBCharacteristic?
    
    var someValue: Data?
    
    let bluetoothQueue = DispatchQueue(label: "Bluetooth", attributes: .concurrent)
    
    var imageDownloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: bluetoothQueue)
        
    }
    
    
    
    func startScan() {
        DispatchQueue.main.async {
            self.bluetoothStatusLabel.text = "scanning"
        }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func connect(peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        
    }
    
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    // Call after connecting to peripheral
    func discoverServices(peripheral: CBPeripheral) {
        peripheral.discoverServices([CBUUID(string: "A56E51F3-AFFE-4E14-87A2-54927B22354C")])
    }
     
    // Call after discovering services
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func discoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.discoverDescriptors(for: characteristic)
    }
    
    
    
    func subscribeToNotifications(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.setNotifyValue(true, for: characteristic)
     }

    func readValue(characteristic: CBCharacteristic) {
        self.connectedPeripheral?.readValue(for: characteristic)
    }

    
    func write(value: Data, characteristic: CBCharacteristic) {
        if let connectedPeripheral {
            self.connectedPeripheral!.writeValue(value, for: characteristic, type: .withResponse)
        }
    }
    
    
    
}

extension BluetoothViewController:  CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOn:
                startScan()
            case .poweredOff:
                DispatchQueue.main.async {
                    self.bluetoothStatusLabel.text = "Your Bluetooth is off, Please turn on bluetooth"
                }
            case .resetting:
                startScan()
             //   break
            case .unauthorized:
                showBluetoothPermissionAlert()
            case .unsupported:
                DispatchQueue.main.async {
                    self.bluetoothStatusLabel.text = "Your Divice Don't support bluetooth"
                }
            case .unknown:
                DispatchQueue.main.async {
                    self.bluetoothStatusLabel.text = "unknown error"
                }
            default:
                DispatchQueue.main.async {
                    self.bluetoothStatusLabel.text = "unknown error"
                }
        }
    }
    


    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if ((peripheral.name?.contains("Inito’s iPhone")) == true){
          
            print("connected")
            
            centralManager.stopScan()
            connect(peripheral: peripheral)
            //centralManager.connect(peripheral, options: nil)
        }else{
            print(peripheral.name)
        }
        
        self.discoveredPeripherals.append(peripheral)
        
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
       // peripheral.discoverServices([CBUUID.BatteryLevel])
        DispatchQueue.main.async {
            self.bluetoothStatusLabel.text = "Connected to \(String(describing: peripheral.name ?? "unkonwn Device"))"
        }
        
        self.connectedPeripheral = peripheral
        discoverServices(peripheral: peripheral)
        
        peripheral.delegate = self
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            self.bluetoothStatusLabel.text = "Fail to Connect"
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            return
        }
        DispatchQueue.main.async {
            self.bluetoothStatusLabel.text = "Successfully disconnected"
        }
        
        // Successfully disconnected
    }

    
    
    

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        print("Services is \(services)")
//        for service in services {
//            if service.uuid == UUID(uuidString: "A56E51F3-AFFE-4E14-87A2-54927B22354C")! as NSObject{
                discoverCharacteristics(peripheral: peripheral)
//            }
//        }
        
    }
     
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        
        
        if let charac = service.characteristics {
            for characteristic in charac {
              //MARK:- Light Value
                if characteristic.uuid == CBUUID(string: "0001") {
                  self.randomNumberGanaraterChar = characteristic
                      print("Characteristic is \(randomNumberGanaraterChar)")
                 }
                if characteristic.uuid == CBUUID(string: "0002") {
                    self.randomNumbaeChar = characteristic
                      print("Characteristic is \(randomNumbaeChar)")
                 }
            }
        }
            
        
        if let randomNumberGanaraterChar {
            subscribeToNotifications(peripheral: peripheral, characteristic: randomNumberGanaraterChar)
            readValue(characteristic: randomNumberGanaraterChar)
        }
//        if let randomNumbaeChar {
//            subscribeToNotifications(peripheral: peripheral, characteristic: randomNumbaeChar)
//           // readValue(characteristic: randomNumbaeChar)
//        }
            
         
        }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            // Handle error
            return
        }
        print(" \(characteristic.isNotifying) for")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            // Handle error
            return
        }
        guard let value = characteristic.value else {
            return
        }
        
        let numberOfImage = UInt8(bigEndian: value.withUnsafeBytes { $0.load(as: UInt8.self) })
        DispatchQueue.main.async {
            self.label1.isHidden = false
        }
        
        
        print("-----------------------")
        print("......\(numberOfImage).......")
        if Int(numberOfImage) == 0{
            DispatchQueue.main.async {
                self.label1.text = "Game Over"
            }
            return
        }
        Task{
            await imageDownloader.downloadImages(Int(numberOfImage)){
                var randomNumber = Int.random(in: 1...4)
                let data = Data(bytes: &randomNumber, count: MemoryLayout.size(ofValue: randomNumber))
                if let randomNumbaeChar = self.randomNumbaeChar{
                    
                    print("write number \(randomNumber)")
                    self.write(value: data, characteristic: randomNumbaeChar)
                }
            }
        }
        
        
        
    }
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("error in write")
            return
        }
        print("No error in write")
        // Successfully wrote value to characteristic
    }
    
    
    func peripheralIsReady(toSendWriteWithResponse peripheral: CBPeripheral) {
        // Called when peripheral is ready to send write without response again.
        // Write some value to some target characteristic.
     //   write(value: someValue!, characteristic: someCharacteristic!)
    }

}
                                          
                                          


extension BluetoothViewController {
    
    func showBluetoothPermissionAlert(){
        let alertController = UIAlertController(
               title: "Bluetooth Permission Required",
               message: "Your app needs Bluetooth access for Sending Image. Please give permission in settings.",
               preferredStyle: .alert
           )

           alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
               if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(settingsUrl)
               }
           }))

           present(alertController, animated: true, completion: nil)
    }
    
    
    func turnOnBluetoth(){
        
        let alertController = UIAlertController(
            title: "Bluetooth Off",
            message: "Please turn on Bluetooth to use send photos.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Turn On Bluetooth", style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }))

        present(alertController, animated: true, completion: nil)
        
    }
}




