//
//  ViewController.swift
//  FaceIt
//
//  Created by mvarxer on 17/4/8.
//  Copyright © 2017年 mvarxer. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    
    var expression = FacialExpression(eyes:.open,mouth:.grin) {
        didSet {
            updateUI()
        }
    }
    
    
    @IBOutlet weak var faceView: FaceView!
        {
        didSet {
            let handler = #selector(faceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTouchesRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            let swipUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipUpRecognizer.direction = .up
            let swipDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipUpRecognizer)
            faceView.addGestureRecognizer(swipDownRecognizer)
            updateUI()
        }
    }
    
    func increaseHappiness() {
        expression = expression.happier
    }
    
    func decreaseHappiness() {
        expression = expression.sadder
    }
    
    
    
    func toggleEyes(byReactingTo tapRecognizer:UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes :FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    
    
    
    private func updateUI() {
        
        print("What happened?",faceView?.eyesOpen ?? "???")
        
        // 下面的faceView没有“？”号会crash
        //没有？号在第五讲里，单个ViewController中运行没问题
        //但第六讲多重MVC去掉问号就不行了，疑惑中？？？
        switch  expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        
        faceView?.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
        
    }
    
    private let mouthCurvature = [FacialExpression.Mouth.frown:-1,.smirk:-0.5,.neutral:0,.grin:0.5,.smile:1]   //一个dictionary
    



}

