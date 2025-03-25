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

// MARK: - 公開工具
extension TipContentView {
    
    /// 外型設定
    /// - Parameters:
    ///   - text: 文字
    ///   - index: Tag
    ///   - lines: 顯示行數
    ///   - underLineColor: 底線顏色
    func configure(text: String?, index: Int, numberOfLines lines: Int, underLineColor: UIColor) {
        
        contentLabel.text = text
        contentLabel.tag = index
        contentLabel.numberOfLines = lines
        contentLabel.isUserInteractionEnabled = true
        underLineView.backgroundColor = underLineColor
        contentLabel.textColor = .black
        
        if underLineColor == .clear { underLineView.isHidden = true }
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
