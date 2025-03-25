//
//  TipContentView.swift
//  WWTipView
//
//  Created by William.Weng on 2025/3/25.
//

import UIKit

// MARK: - 簡單的提示框
class TipContentView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
}

// MARK: - 小工具
private extension TipContentView {
    
    /// 讀取Nib畫面 => 加到View上面
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: TipContentView.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
}
