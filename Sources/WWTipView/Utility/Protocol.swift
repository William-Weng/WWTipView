//
//  Protocol.swift
//  WWTipView
//
//  Created by William.Weng on 2025/3/21.
//

import Foundation

// MARK: - WWTipView.Delegate
public extension WWTipView {
    
    protocol Delegate: AnyObject {
        
        /// 被點擊到時的回應
        /// - Parameters:
        ///   - tipView: WWTipView
        ///   - index: 點到哪一個
        func tipView(_ tipView: WWTipView, didTouched index : Int)
        
        /// 動畫狀態
        /// - Parameters:
        ///   - tipView: WWTipView
        ///   - status: AnimationStatusType
        func tipView(_ tipView: WWTipView, status: AnimationStatusType)
    }
}
