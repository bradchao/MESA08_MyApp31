//
//  ViewController.swift
//  MyApp31
//
//  Created by user22 on 2017/10/5.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var preview: UIView!
    
    @IBOutlet weak var photo: UIImageView!
    
    let session = AVCaptureSession()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    @IBAction func start(_ sender: Any) {
        
        session.startRunning()
        
    }
    
    @IBAction func stop(_ sender: Any) {
        session.stopRunning()
    }
    
    @IBAction func take(_ sender: Any) {
        print("ok0")
        let setting = AVCapturePhotoSettings()

        let formattype = setting.livePhotoVideoCodecType
        let format = [
            kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA),
            kCVPixelBufferWidthKey as String : photo.frame.size.width,
            kCVPixelBufferHeightKey as String : photo.frame.size.height
        ] as [String : Any]

        setting.previewPhotoFormat = format
        
        
        if let preview = setting.previewPhotoFormat?.first {
            print("ok2")
            let output = session.outputs.first as? AVCapturePhotoOutput
            output?.capturePhoto(with: setting, delegate: self)
        }else{
            print("error2")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        
//        let device = AVCaptureDevice.defaultDevice(withDeviceType: .buildWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        let input  = try? AVCaptureDeviceInput(device: device!)
        session.addInput(input!)
        
        let output = AVCapturePhotoOutput()
        session.addOutput(output)
        
        previewLayer.session = session
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        preview.layer.addSublayer(previewLayer)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil else {return}
        
        if let jpegData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!) {
            
            photo.image = UIImage(data: jpegData)
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        previewLayer.frame = preview.bounds
    }
    

}

