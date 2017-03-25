//
//  ViewController.swift
//  carmerBackground
//
//  Created by Xin Zou on 3/23/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var preview : UIView! // for carmer view at background
    let boxview : UIView = { // for upper layer
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.alpha = 0.5
        return v
    }()

    lazy var playerView : PlayerView = {
        let v = PlayerView(frame: self.view.frame)
        return v
    }()
    
    let frontSight : UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "front sight_lighter"))
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    
    //Camera Capture requiered properties
    var videoDataOutput : AVCaptureVideoDataOutput!
    var previewLayer :    AVCaptureVideoPreviewLayer!
    var captureDevice :   AVCaptureDevice!
    let session =         AVCaptureSession()
    var currentFrame:     CIImage!
    var videoDataOutputQueue: DispatchQueue!
    var isDone = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // add camera view
        //preview = UIView(frame: CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        preview = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        preview.contentMode = .scaleAspectFit
        view.addSubview(preview)

        // add boxview
        //view.addSubview(boxview)
        //boxview.addConstraints(view.leftAnchor, view.topAnchor, view.rightAnchor, view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        // add player's items
        view.addSubview(frontSight)
        frontSight.addConstraintsForCenter(view.centerXAnchor, view.centerYAnchor, width: 40, height: 40)
        
        view.addSubview(playerView)
        playerView.addConstraints(nil, nil, view.rightAnchor, view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: view.bounds.width, height: view.bounds.height)
        print(view.bounds, playerView.bounds)
        
        self.setupAVCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isDone {
            session.startRunning()
        }else{
            session.stopRunning()
        }
    }
    
    override var shouldAutorotate: Bool {
        let curOri = UIDevice.current.orientation
        if curOri == UIDeviceOrientation.landscapeLeft || curOri == UIDeviceOrientation.landscapeRight { // || curOri == UIDeviceOrientation.unknown {
            if curOri == UIDeviceOrientation.landscapeLeft {
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            }else{
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            }
            //return false
            return true
        }else{
            return false // true
        }
    }
    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


