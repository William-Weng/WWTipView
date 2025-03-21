//
//  WWTipView.swift
//  WWTipView
//
//  Created by William.Weng on 2025/3/21.
//

import UIKit

// MARK: - 簡單的提示框
open class WWTipView: UIView {
        
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var upperImageView: UIImageView!
    @IBOutlet weak var lowerImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var centerXConstraint: NSLayoutConstraint!
    
    public var text: String? { didSet { contentLabel.text = text }}
    public var textColor: UIColor = .black { didSet { contentLabel.textColor = textColor }}
    public var textFont: UIFont? = .systemFont(ofSize: 14.0) { didSet { contentLabel.font = textFont }}
    public var upperImage: UIImage? = .init(named: "UpperTriangle", in: .module, with: nil)
    public var lowerImage: UIImage? = .init(named: "LowerTriangle", in: .module, with: nil)
    
    public weak var delegate: Delegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        iniSetting()
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        delegate?.tipView(self, didTouched: true)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        iniSetting()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.tipView(self, didTouched: true)
    }
    
    deinit {
        delegate = nil
    }
}

// MARK: - 公開函式
public extension WWTipView {
    
    /// [顯示提示框](https://www.appcoda.com.tw/auto-layout-programmatically/)
    /// - Parameters:
    ///   - target: [在哪裡UIViewController上顯示](https://www.kodeco.com/277-auto-layout-visual-format-language-tutorial)
    ///   - view: [對齊哪個View](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html)
    ///   - direction: [顯示的位置](https://www.kodeco.com/277-auto-layout-visual-format-language-tutorial)
    ///   - centerXConstraint: 圖標置中對齊的偏移量
    ///   - renderingMode: 圖標渲染模式
    func display(target: UIViewController, at view: UIView, direction: Direction = .upper, centerXConstraint: CGFloat = 0, renderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        
        let views = ["self": self, "view": view]
        
        removeFromSuperview()
        target.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        layer.anchorPoint = direction.anchorPoint()
        
        middleView.backgroundColor = tintColor
        self.centerXConstraint.constant = centerXConstraint
        
        
        upperImageView.image = upperImage?.withRenderingMode(renderingMode)
        lowerImageView.image = lowerImage?.withRenderingMode(renderingMode)
        upperImageView.isHidden = (direction == .upper)
        lowerImageView.isHidden = (direction == .lower)
        
        visualFormats(at: view, direction: direction).forEach { format in
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: [.directionMask], metrics: nil, views: views)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    /// [移除提示框](https://www.kodeco.com/277-auto-layout-visual-format-language-tutorial)
    func dismiss() {
        removeFromSuperview()
    }
}

// MARK: - 小工具
private extension WWTipView {
    
    /// 初始化設定
    func iniSetting() {
        initViewFromXib()
        initViewSetting()
    }
    
    /// 讀取Nib畫面 => 加到View上面
    func initViewFromXib() {
        
        let bundle = Bundle.module
        let name = String(describing: WWTipView.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
    
    /// 畫面相關設定
    func initViewSetting() {
        isUserInteractionEnabled = true
        middleView.layer.cornerRadius = 8
        middleView.clipsToBounds = true
        contentLabel.text = nil
    }
    
    /// [定位的VFL處理 (左右對齊 / 高度自適應)](https://serpapi.com/google-autocomplete-api)
    /// - Parameters:
    ///   - view: UIView
    ///   - direction: Direction
    /// - Returns: [String]
    func visualFormats(at view: UIView, direction: Direction = .upper) -> [String] {
        
        let minHeight = contentLabel.font.pointSize + 8
        let visualFormat: String
        
        switch direction {
        case .upper: visualFormat = "V:[view]-(\(-view.bounds.height))-[self]"
        case .lower: visualFormat = "V:[view]-0-[self]"
        }
        
        return ["H:|-[self]-|", "\(visualFormat)", "V:[self(>=\(minHeight)@750)]"]
    }
}
