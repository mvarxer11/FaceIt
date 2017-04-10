//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by mvarxer on 17/4/6.
//  Copyright © 2017年 mvarxer. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("EmotionsViewController->prepare(for segue:)")
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] {
                faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    private let emotionalFaces:Dictionary<String,FacialExpression> = [
        "sad" : FacialExpression(eyes: .closed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, mouth: .smirk)
    
    ]
    


}
