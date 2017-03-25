//
//  Extensions.swift
//  carmerBackground
//
//  Created by Xin Zou on 3/23/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import AVFoundation


// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func setupAVCapture() {
        session.sessionPreset = AVCaptureSessionPreset1280x720 //AVCaptureSessionPreset640x480
        
        // set using camera:
        guard let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera,
                                                         mediaType: AVMediaTypeVideo,
                                                         position: .back) //.front)
            else { return }
        
        captureDevice = device
        beginSession()
        isDone = true
    }
    
    func beginSession(){
        var err : NSError? = nil
        var deviceInput: AVCaptureDeviceInput?
        
        do {
            
            deviceInput = try AVCaptureDeviceInput(device: self.captureDevice)
            
        } catch let error as NSError {
            err  = error
            deviceInput = nil
        }
        if err != nil {
            print("===== get error when setting deviceInput: \(err!)")
        }
        
        if self.session.canAddInput(deviceInput){
            self.session.addInput(deviceInput)
        }
        
        // then setup output:
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
        
        videoDataOutput.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)
        
        if self.session.canAddOutput(self.videoDataOutput) {
            self.session.addOutput(self.videoDataOutput)
        }
        videoDataOutput.connection(withMediaType: AVMediaTypeVideo).isEnabled = true
        
        previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect // AVLayerVideoGravityResizeAspectFill
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft  //.portrait // ???????????
        
        
        let rootLayer: CALayer = self.preview.layer
        rootLayer.masksToBounds = true
        //self.previewLayer.frame = rootLayer.bounds
        self.previewLayer.frame = view.layer.bounds
        rootLayer.addSublayer(self.previewLayer)
        
        session.startRunning()
    }
    
    // capureOutput didOutputSampleBuffer
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        currentFrame = self.convertImageFromCMSampleBufferRef(sampleBuffer)
    }
    func convertImageFromCMSampleBufferRef(_ sampleBuffer: CMSampleBuffer) -> CIImage {
        let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        return ciImage
    }
    
    // clean up AVCapture
    func stopCamera(){
        session.stopRunning()
        isDone = false
    }
    
}





extension UIView {
    
    func addConstraints(_ left: NSLayoutXAxisAnchor? = nil,  _ top: NSLayoutYAxisAnchor? = nil, _ right: NSLayoutXAxisAnchor? = nil, _ bottom: NSLayoutYAxisAnchor? = nil, leftConstent: CGFloat? = 0, topConstent: CGFloat? = 0, rightConstent: CGFloat? = 0, bottomConstent: CGFloat? = 0, width: CGFloat? = 0, height: CGFloat? = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if left != nil {
            anchors.append(leftAnchor.constraint(equalTo: left!, constant: leftConstent!))
        }
        if top != nil {
            anchors.append(topAnchor.constraint(equalTo: top!, constant: topConstent!))
        }
        if right != nil {
            anchors.append(rightAnchor.constraint(equalTo: right!, constant: -rightConstent!))
        }
        if bottom != nil {
            anchors.append(bottomAnchor.constraint(equalTo: bottom!, constant: -bottomConstent!))
        }
        if let w = width, w > CGFloat(0) {
            anchors.append(widthAnchor.constraint(equalToConstant: w))
        }
        if let h = height, h > CGFloat(0) {
            anchors.append(heightAnchor.constraint(equalToConstant: h))
        }
        
        for constant in anchors {
            constant.isActive = true
        }
    }
    
    func addConstraintsForCenter(_ x: NSLayoutXAxisAnchor? = nil, _ y: NSLayoutYAxisAnchor? = nil, width: CGFloat? = 0, height: CGFloat? = 0){
        guard x != nil, y != nil else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: x!).isActive = true
        centerYAnchor.constraint(equalTo: y!).isActive = true
        if let w = width, w > CGFloat(0) {
            widthAnchor.constraint(equalToConstant: w).isActive = true
        }
        if let h = height, h > CGFloat(0) {
            heightAnchor.constraint(equalToConstant: height!).isActive = true
        }
    }
    
}

