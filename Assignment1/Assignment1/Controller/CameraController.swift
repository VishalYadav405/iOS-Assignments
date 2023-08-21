//
//  CameraController.swift
//  Assignment1
//
//  Created by Inito on 19/08/23.
//


import Foundation
import UIKit
import AVFoundation
import Photos

 

class CameraController: NSObject{
    
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var flashMode = AVCaptureDevice.FlashMode.off
    
   // var exposure: Int?
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevicesAndDiviceInput() throws {
            
            //1
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            //let cameras = (session.devices.compactMap { $0 })
            guard let camera = session.devices.first else{
                throw CameraControllerError.noCamerasAvailable
            }

            
//            if let exposure {
//                setExposure(exposure)
//            }
            try camera.lockForConfiguration()
            //camera.focusMode = .continuousAutoFocus
            
           // camera.focusMode = AVCaptureDevice.FocusMode(rawValue: 1)!
           // camera.exposureDuration = CMTime(1/800)
            camera.unlockForConfiguration()
            
            
            
            let input = try AVCaptureDeviceInput(device: camera)
            
            guard let captureSession = captureSession else{
                print("error in capturing session")
                return
            }
            
            captureSession.addInput(input)
        }
        func configurePhotoOutput() throws {
            
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
             
                self.photoOutput = AVCapturePhotoOutput()
                self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
             
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
             
                captureSession.startRunning()
            
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevicesAndDiviceInput()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
        
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    
    
    
    
    
    
    func displayPreview(on view: UIView) throws {
        
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
         
            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.previewLayer?.connection?.videoOrientation = .portrait
         
            view.layer.insertSublayer(self.previewLayer!, at: 0)
            self.previewLayer?.frame = view.frame
    }
    
    
   
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
     
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
     
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    
    func stopPreview() throws{
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        captureSession.stopRunning()
        
    }
    
    
//    func setExposure(_ exposure: Int, completion: @escaping () -> Void)  {
//
//            guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
//            if device.isExposureModeSupported(.custom) {
//                do{
//                    try device.lockForConfiguration()
//                    device.setExposureModeCustom(duration: CMTime(value: 1, timescale: CMTimeScale(exposure) ), iso: device.activeFormat.minISO) { (_) in
//                        print("Done Esposure")
//                    }
//                    device.unlockForConfiguration()
//                }
//                catch{
//                    print("ERROR: \(String(describing: error.localizedDescription))")
//                }
//            }
//
//
//        self.captureImage { (image, error) in
//
//
//            guard let image = image else {
//                print(error ?? "Image capture error")
//                return
//            }
//            if(exposure == 60){
//                sendImageToBackend()
//            }
//
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
//           // print(exposure)
//            completion()
//        }
//
//
//    }
    
    
    
    func setExposure(_ exposure: Int)  {
       
            guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
            if device.isExposureModeSupported(.custom) {
                do{
                    try device.lockForConfiguration()
                    device.setExposureModeCustom(duration: CMTime(value: 1, timescale: CMTimeScale(exposure) ), iso: device.activeFormat.minISO) { (_) in
                        print("Done Esposure")
                    }
                    device.unlockForConfiguration()
                }
                catch{
                    print("ERROR: \(String(describing: error.localizedDescription))")
                }
            }

        
    }
    
}




extension CameraController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}


extension CameraController {
    enum CameraControllerError: Swift.Error {
            case captureSessionAlreadyRunning
            case captureSessionIsMissing
            case inputsAreInvalid
            case invalidOperation
            case noCamerasAvailable
            case unknown
    }
    
}


