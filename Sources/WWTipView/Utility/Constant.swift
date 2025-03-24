//
//  Constant.swift
//  WWTipView
//
//  Created by William.Weng on 2025/3/21.
//

import UIKit

// MARK: - 常數
public extension WWTipView {
        
    /// 顯示狀態
    enum StatusType {
        case display
        case dismiss
    }
    
    /// 動畫顯示狀態
    enum AnimationStatusType {
        case willDisplay
        case willDismiss
        case didDisplay
        case didDismiss
    }
    
    /// TipView圖示顯示的位置
    enum Position {
        
        case left(_ gap: CGFloat)
        case center(_ gap: CGFloat)
        case right(_ gap: CGFloat)
        
        static public let left = left(0)
        static public let center = center(0)
        static public let right = right(0)
    }
        
    /// 動畫類型
    enum AnimationType {
        
        case alpha(_ duration: TimeInterval)
        case scale(_ duration: TimeInterval, _ dampingRatio: CGFloat)
        case move(_ duration: TimeInterval, _ axis: NSLayoutConstraint.Axis, _ value: CGFloat)
        case rotate(_ duration: TimeInterval, _ type: RotationType)
        
        static public let alpha = alpha(0.5)
        static public let scale = scale(0.5, 0.5)
        static public let move = move(0.5, .vertical, 20)
        static public let rotate = rotate(0.5, .left)
    }
    
    /// TipView圖示顯示的方向
    enum Direction {
        case upper
        case lower
        
        /// 取得對齊的基準點 (錨點)
        /// - Returns: CGPoint
        func anchorPoint() -> CGPoint {
            switch self {
            case .upper: return .init(x: 0.5, y: 1.5)
            case .lower: return .init(x: 0.5, y: 0.5)
            }
        }
    }
    
    /// 旋轉狀態
    enum RotationType {
        case left
        case right
    }
}
