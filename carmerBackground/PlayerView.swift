//
//  PlayerView.swift
//  carmerBackground
//
//  Created by Xin Zou on 3/24/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class PlayerView : UIView {
    
    lazy var trigger : UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.addTarget(self, action: #selector(fireGun), for: .touchUpInside)
        return b
    }()
    
    var gunRightAnchor : NSLayoutXAxisAnchor?
    var gunBottomAnchor: NSLayoutYAxisAnchor?
    let gun : UIImageView = {
        let v = UIImageView(image: #imageLiteral(resourceName: "gun01"))
        v.contentMode = .scaleToFill
        return v
    }()
    
    let gunFlame : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear // .white
        v.alpha = 0.2
        return v
    }()
    
    var bulletTraceWidthAnchor : NSLayoutConstraint?
    let bulletTrace : UIImageView = {
        let v = UIImageView(image: #imageLiteral(resourceName: "bulletTrace"))
        v.contentMode = .scaleToFill
        v.alpha = 0
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = frame.width, h = frame.height
        addSubview(bulletTrace)
        bulletTrace.addConstraints(leftAnchor, topAnchor, nil, nil, leftConstent: w * 0.5, topConstent: h * 0.5, rightConstent: 0, bottomConstent: 0, width: w * 0.5, height: h * 0.5)
        //print(bulletTrace.constraints)
        bulletTraceWidthAnchor = bulletTrace.constraints[0] // get width

        addSubview(gunFlame)
        gunFlame.addConstraints(nil, nil, rightAnchor, bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w * 0.5, height: h * 0.5)
        
        addSubview(gun)
        gun.addConstraints(nil, nil, rightAnchor, bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: -10, bottomConstent: -10, width: w * 0.5, height: h * 0.5)
        //print(gun.constraints)
        gunRightAnchor = gun.rightAnchor
        gunBottomAnchor = gun.bottomAnchor
        
        addSubview(trigger)
        trigger.addConstraints(nil, nil, gun.rightAnchor, gun.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w * 0.4, height: w * 0.4)
        
        
        
    }
    
    func fireGun(){
        bulletTrace.alpha = 1
        
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bulletTrace.alpha = 0

        }) { (finished) in

        }
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
