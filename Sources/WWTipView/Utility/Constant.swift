//
//  Constant.swift
//  WWTipView
//
//  Created by William.Weng on 2025/3/21.
//

import Foundation

// MARK: - 常數
public extension WWTipView {
    
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
    
    /// TipView圖示顯示的位置
    enum Position {
        
        case left(_ gap: CGFloat)
        case center(_ gap: CGFloat)
        case right(_ gap: CGFloat)
        
        static public let left = left(16)
        static public let center = center(0)
        static public let right = right(16)
    }
}
