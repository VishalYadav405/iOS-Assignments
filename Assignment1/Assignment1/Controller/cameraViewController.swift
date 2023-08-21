//
//  cameraViewController.swift
//  Assignment1
//
//  Created by Inito on 19/08/23.
//

import UIKit
import Photos


class cameraViewController: UIViewController {

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var textLabel: UILabel!

    @IBOutlet weak var timerLebel: UILabel!

    @IBOutlet weak var previewView: UIView!
    let cameraController = CameraController()
     var index = 0
    let exposures = [800, 400, 200, 100, 60, 30, 15, 7, 3]

    var middleImage: UIImage?
    
    let imageSender = SaveImageToBackend()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCameraController()
        styleCaptureButton()

        timerLebel.text = "2 second"

    }

    let semaphore = DispatchSemaphore(value: 1)



    @IBAction func onOffFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }

        else {
            cameraController.flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }

    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
                guard let image = image else {
                    print(error ?? "Image capture error")
                    return
                }
                
                try? PHPhotoLibrary.shared().performChangesAndWait {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
            }
        

        let timerTime = 2
        startTimer(for: timerTime)
    }




    func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }

            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }

    func styleCaptureButton() {
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2

        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
    }

}


extension cameraViewController{
    func startTimer(for time: Int){

        labelStackView.isHidden = false

//        do{
//            try cameraController.stopPreview()
//        }catch{
//            print("unable to stop preview")
//            return
//        }
        self.captureButton.isHidden = true
        self.flashButton.isHidden = true
        var secondsRemaining = time

        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsRemaining > 0 {

                secondsRemaining -= 1
                self.timerLebel.text = "\(secondsRemaining) second"


            } else {
                Timer.invalidate()
                self.timerLebel.text = "Done"

                self.clickImageWithDifferentExposureDurations()
            }
        }
    }
}



extension cameraViewController{
    
    func clickImageWithDifferentExposureDurations(){
        
        //        NSLayoutConstraint.activate([
        //            self.labelStackView.topAnchor.constraint(equalTo: self.previewView.topAnchor),
        //            self.labelStackView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor),
        //            self.labelStackView.leadingAnchor.constraint(equalTo: self.previewView.leadingAnchor),
        //            self.labelStackView.trailingAnchor.constraint(equalTo: self.previewView.trailingAnchor)
        //           ])
        timerLebel.isHidden = true
        //  print("sDZxcfvb")
        textLabel.font = UIFont.systemFont(ofSize: 15)
        //        DispatchQueue.global(qos: .background).async{
        //            self.cameraController.captureSession?.startRunning()
        //        }
        
        
        
        //        let serialQueue = DispatchQueue(label: "serialQueue", qos: .utility)
        //        for exposure in exposures {
        //
        //            Task{
        //                self.clickImage(exposure)
        //                semaphore.wait()
        //            }
        //
        //        }
        
       // let serialQueue = DispatchQueue(label: "serialQueue", qos: .utility)
        
     
        clickImage(exposures[index]){
        }
       
       

    }
    
    
    
//
//    func clickImage(_ exposure: Int) {
//        self.textLabel.text = "Clicking Photo for Exposure Duration 1/\(exposure)"
//
//        self.cameraController.setExposure(exposure) {
//            self.index += 1
//            print(self.index)
//
//            if self.index < self.exposures.count{
//                self.clickImage(self.exposures[self.index])
//            }
//        }
//
//    }
    
    func clickImage(_ exposure: Int, completion: @escaping () -> Void) {
        self.textLabel.text = "Clicking Photo for Exposure Duration 1/\(exposure)"

        self.cameraController.setExposure(exposure)
            
        
        self.cameraController.captureImage { (image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            if self.index == 4{
                self.middleImage = image
                
            }
    
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
       
           
            self.index += 1
            print(self.index)
            if self.index < self.exposures.count{
                self.clickImage(self.exposures[self.index]){
                    
                }
            }
            else{
                self.sendImage()
            }
            
        }

            
        

    }
    
    func sendImage(){
        if let middleImage = self.middleImage {
            print("go to backend")
            self.imageSender.sendImage(middleImage)
        }else{
            print("middle image is nil")
        }
    }
    


}


























//
//
//
////
////  cameraViewController.swift
////  Assignment1
////
////  Created by Inito on 19/08/23.
////
//
//import UIKit
//import Photos
//
//
//class cameraViewController: UIViewController {
//
//    @IBOutlet weak var captureButton: UIButton!
//    @IBOutlet weak var flashButton: UIButton!
//    @IBOutlet weak var labelStackView: UIStackView!
//    @IBOutlet weak var textLabel: UILabel!
//
//    @IBOutlet weak var timerLebel: UILabel!
//
//    @IBOutlet weak var previewView: UIView!
//    let cameraController = CameraController()
//     var index = 0
//    let exposures = [800, 400, 200, 100, 60, 30, 15, 7, 3]
//
//    var middleImage: UIImage?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureCameraController()
//        styleCaptureButton()
//
//        timerLebel.text = "2 second"
//
//    }
//
//    let semaphore = DispatchSemaphore(value: 1)
//
//
//
//    @IBAction func onOffFlash(_ sender: UIButton) {
//        if cameraController.flashMode == .on {
//            cameraController.flashMode = .off
//            flashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
//        }
//
//        else {
//            cameraController.flashMode = .on
//            flashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
//        }
//    }
//
//    @IBAction func captureImage(_ sender: UIButton) {
//        cameraController.captureImage {(image, error) in
//                guard let image = image else {
//                    print(error ?? "Image capture error")
//                    return
//                }
//
//                try? PHPhotoLibrary.shared().performChangesAndWait {
//                    PHAssetChangeRequest.creationRequestForAsset(from: image)
//                }
//            }
//
//
//        let timerTime = 2
//        startTimer(for: timerTime)
//    }
//
//
//
//
//    func configureCameraController() {
//        cameraController.prepare {(error) in
//            if let error = error {
//                print(error)
//            }
//
//            try? self.cameraController.displayPreview(on: self.previewView)
//        }
//    }
//
//    func styleCaptureButton() {
//        captureButton.layer.borderColor = UIColor.black.cgColor
//        captureButton.layer.borderWidth = 2
//
//        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
//    }
//
//}
//
//
//extension cameraViewController{
//    func startTimer(for time: Int){
//
//        labelStackView.isHidden = false
//
////        do{
////            try cameraController.stopPreview()
////        }catch{
////            print("unable to stop preview")
////            return
////        }
//        self.captureButton.isHidden = true
//        self.flashButton.isHidden = true
//        var secondsRemaining = time
//
//        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
//            if secondsRemaining > 0 {
//
//                secondsRemaining -= 1
//                self.timerLebel.text = "\(secondsRemaining) second"
//
//
//            } else {
//                Timer.invalidate()
//                self.timerLebel.text = "Done"
//
//                self.clickImageWithDifferentExposureDurations()
//            }
//        }
//    }
//}
//
//
//
//extension cameraViewController{
//
//    func clickImageWithDifferentExposureDurations(){
//
//        //        NSLayoutConstraint.activate([
//        //            self.labelStackView.topAnchor.constraint(equalTo: self.previewView.topAnchor),
//        //            self.labelStackView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor),
//        //            self.labelStackView.leadingAnchor.constraint(equalTo: self.previewView.leadingAnchor),
//        //            self.labelStackView.trailingAnchor.constraint(equalTo: self.previewView.trailingAnchor)
//        //           ])
//        timerLebel.isHidden = true
//        //  print("sDZxcfvb")
//        textLabel.font = UIFont.systemFont(ofSize: 15)
//        //        DispatchQueue.global(qos: .background).async{
//        //            self.cameraController.captureSession?.startRunning()
//        //        }
//
//
//
//        //        let serialQueue = DispatchQueue(label: "serialQueue", qos: .utility)
//        //        for exposure in exposures {
//        //
//        //            Task{
//        //                self.clickImage(exposure)
//        //                semaphore.wait()
//        //            }
//        //
//        //        }
//
//        let serialQueue = DispatchQueue(label: "serialQueue", qos: .utility)
//
//        //            for exposure in exposures {
//        //
//        //                semaphore.wait()
//        //               // serialQueue.sync {
//        //                    self.clickImage(exposure) {
//        //
//        //                        self.semaphore.signal()
//        //                    }
//        //              //  }
//        //               // self.semaphore.signal()
//        ////
//        //
//        //            }
//
//
//        //while true {
//        clickImage(exposures[index])
//        //  }
//
//        // func
//
//    }
//
//
//
//
//    func clickImage(_ exposure: Int) {
//        self.textLabel.text = "Clicking Photo for Exposure Duration 1/\(exposure)"
//
//        self.cameraController.setExposure(exposure) {
//            self.index += 1
//            print(self.index)
//
//            if self.index < self.exposures.count{
//                self.clickImage(self.exposures[self.index])
//            }
//        }
//
//    }
//
//
//
//
//    //    func clickImage(_ exposure: Int) {
//    //
//    //        self.textLabel.text = "Clicking Photo for Exposure Duration \(exposure)"
//    //
//    //        self.cameraController.setExposure(exposure)
//    //
//    //
//    //            self.cameraController.captureImage {(image, error) in
//    //                guard let image = image else {
//    //                    print(error ?? "Image capture error")
//    //                   // self.semaphore.signal()
//    //                    return
//    //                }
//    //
//    //                if exposure == 60 {
//    //                    self.sendImageToBackend()
//    //                }
//    //
//    //                try? PHPhotoLibrary.shared().performChangesAndWait {
//    //                    PHAssetChangeRequest.creationRequestForAsset(from: image)
//    //                }
//    //
//    //            }
//    //
//    //        self.semaphore.signal()
//    //
//    //
//    //    }
//
//
//}
//
//
//extension cameraViewController{
//
//    func sendImageToBackend(){
//
//    }
//}
//
//
