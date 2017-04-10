//
//  FaceView.swift
//  FaceIt
//
//  Created by mvarxer on 17/4/4.
//  Copyright © 2017年 mvarxer. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    // Public API
    
    @IBInspectable
    var mouthCurvature:Double = 0.5 //1.0 is full smile and -1.0 is full frown
    
    @IBInspectable
    var eyesOpen:Bool = true { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale:CGFloat = 0.9 { didSet { setNeedsDisplay() } }

    
    @IBInspectable
    var lineWidth:CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color:UIColor = .blue { didSet { setNeedsDisplay() } }
    
    func changeScale(byReactingTo pinchRecognizer:UIPinchGestureRecognizer) {
        switch  pinchRecognizer.state {
        case .changed,.ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    
    
    private var skullRadius:CGFloat {
        return min(bounds.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter:CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        static let skullRadiusToEyeOffset:CGFloat = 3
        static let skullRadiusToEyeRadius:CGFloat = 10
        static let skullRadiusToMouthWidth:CGFloat = 1
        static let skullRadiusToMouthHeight:CGFloat = 3
        static let skullRadiustoMouthOffset:CGFloat = 3
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathforEye(_ eye:Eye)->UIBezierPath {
        
        func centerOfEye(_ eye:Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        let path:UIBezierPath
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        } else {
            path = UIBezierPath()
            path.move(to:CGPoint(x:eyeCenter.x - eyeRadius,y:eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiustoMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let path = UIBezierPath()
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = lineWidth
        return path
        
    }
    
    
    private func pathForSkull()-> UIBezierPath {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {
        color.set()
        pathForSkull().stroke()
        pathforEye(.left).stroke()
        pathforEye(.right).stroke()
        pathForMouth().stroke()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("--------------faceView->init?(coder aDecoder: )")
    }
    
    deinit {
        print("--------------faceView is deinitialized.-----------------")
    }
    


}
