//
//  FacialExpression.swift
//  FaceIt
//
//  Created by mvarxer on 17/4/4.
//  Copyright © 2017年 mvarxer. All rights reserved.
//

import Foundation

struct FacialExpression {
    
    enum Eyes:Int {
        case open
        case closed
        case squinting
    }
    
    enum  Mouth:Int {
        case frown  //皱眉
        case smirk  //不悦
        case neutral    //中性
        case grin   //露齿笑
        case smile  //
        
        var sadder:Mouth {
            return Mouth(rawValue:rawValue - 1) ?? .frown
        }
        var happier:Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
        
    }
    
    var sadder:FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier:FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    let eyes:Eyes
    let mouth:Mouth
    
}

