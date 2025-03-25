//
//  CAAnimation.swift
//  WWTipView
//
//  Created by William.Weng on 2025/3/24.
//

import UIKit
import SceneKit

// MARK: - Collection (override function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - CATransform3D (static function)
extension CATransform3D {
    
    /// 建立CATransform3D
    /// - Parameters:
    ///   - angle: 角度 (-π ~ π)
    ///   - point3D: SCNVector3
    /// - Returns: CATransform3D
    static func _build(angle: CGFloat, point3D: SCNVector3) -> CATransform3D {
        return CATransform3DMakeRotation(angle, CGFloat(point3D.x), CGFloat(point3D.y), CGFloat(point3D.z))
    }
}

// MARK: - CAAnimation (static function)
extension CAAnimation {
    
    /// [Layer動畫產生器 (CABasicAnimation)](https://jjeremy-xue.medium.com/swift-說說-cabasicanimation-9be31ee3eae0)
    /// - Parameters:
    ///   - keyPath: [要產生的動畫key值](https://blog.csdn.net/iosevanhuang/article/details/14488239)
    ///   - delegate: [CAAnimationDelegate?](https://juejin.cn/post/6936070813648945165)
    ///   - fromValue: 開始的值
    ///   - toValue: 結束的值
    ///   - duration: 動畫時間
    ///   - repeatCount: 播放次數
    ///   - fillMode: [CAMediaTimingFillMode](https://juejin.cn/post/6991371790245183496)
    ///   - timingFunction: CAMediaTimingFunction?
    ///   - beginTime: CFTimeInterval
    ///   - autoreverses: 自動重複執行
    ///   - isRemovedOnCompletion: Bool
    /// - Returns: Constant.CAAnimationInformation
    static func _basicAnimation(keyPath: String, delegate: CAAnimationDelegate? = nil, fromValue: Any?, toValue: Any?, duration: CFTimeInterval = 5.0, repeatCount: Float = 1.0, fillMode: CAMediaTimingFillMode = .forwards, timingFunction: CAMediaTimingFunction? = nil, isRemovedOnCompletion: Bool = false) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: keyPath)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.fillMode = fillMode
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        animation.delegate = delegate
        animation.timingFunction = timingFunction
        
        return animation
    }
}
