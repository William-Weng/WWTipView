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
        ///   - didTouched: Bool
        func tipView(_ tipView: WWTipView, didTouched: Bool)
    }
}
