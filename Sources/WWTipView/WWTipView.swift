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
    
    @IBOutlet var centerXConstraints: [NSLayoutConstraint]!
    
    public var text: String? { didSet { contentLabel.text = text }}
    public var textColor: UIColor = .black { didSet { contentLabel.textColor = textColor }}
    public var textFont: UIFont? = .systemFont(ofSize: 14.0) { didSet { contentLabel.font = textFont }}
    public var upperImage: UIImage? = .init(named: "UpperTriangle", in: .module, with: nil)
    public var lowerImage: UIImage? = .init(named: "LowerTriangle", in: .module, with: nil)
    public var edgeInsets: UIEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
    
    public weak var delegate: Delegate?
    
    private weak var targetView: UIView?
    private weak var referenceView: UIView?
    
    private var position: Position?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        iniSetting()
    }
        
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        iniSetting()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.tipView(self, didTouched: true)
    }
        
    public override func layoutSubviews() {
        super.layoutSubviews()
        fixScreenRotationSetting()
    }
    
    deinit {
        delegate = nil
        targetView = nil
        referenceView = nil
    }
}

// MARK: - 公開函式
public extension WWTipView {
    
    /// [顯示提示框](https://www.appcoda.com.tw/auto-layout-programmatically/)
    /// - Parameters:
    ///   - target: [在哪裡UIViewController上顯示](https://www.kodeco.com/277-auto-layout-visual-format-language-tutorial)
    ///   - view: [對齊哪個View](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html)
    ///   - direction: [顯示的位置](https://www.kodeco.com/277-auto-layout-visual-format-language-tutorial)
    ///   - position: 圖標置中對齊的樣式
    ///   - renderingMode: 圖標渲染模式
    func display(target: UIViewController, at view: UIView, direction: Direction = .upper, position: Position = .center, renderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        
        let views = ["self": self, "view": view]
        
        removeFromSuperview()
        target.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        viewSetting(at: view, direction: direction, renderingMode: renderingMode)
        centerXConstraintSetting(targetView: target.view, referenceView: view, position: position, edgeInsets: edgeInsets)
        
        visualFormats(at: view, direction: direction, edgeInsets: edgeInsets).forEach { format in
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: [.directionMask], metrics: nil, views: views)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    /// [移除提示框](https://www.kodeco.com/277-auto-layout-visual-format-language-tutorial)
    func dismiss() {
        removeFromSuperview()
    }
}

// MARK: - @objc
private extension WWTipView {
    
    /// 點擊到時的反應
    /// - Parameter tap: UITapGestureRecognizer
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        delegate?.tipView(self, didTouched: true)
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
    
    /// 顯示畫面長相的基本設定
    /// - Parameters:
    ///   - view: UIView
    ///   - direction: Direction
    ///   - renderingMode: UIImage.RenderingMode
    func viewSetting(at view: UIView, direction: Direction, renderingMode: UIImage.RenderingMode) {
        
        layer.anchorPoint = direction.anchorPoint()
        
        middleView.backgroundColor = tintColor
        upperImageView.image = upperImage?.withRenderingMode(renderingMode)
        lowerImageView.image = lowerImage?.withRenderingMode(renderingMode)
        upperImageView.isHidden = (direction == .upper)
        lowerImageView.isHidden = (direction == .lower)
    }
    
    /// [設定圖示指標的位置](https://ithelp.ithome.com.tw/m/articles/10205322)
    /// - Parameters:
    ///   - targetView: UIView
    ///   - referenceView: UIView
    ///   - position: Position
    ///   - edgeInsets: 邊界間距
    func centerXConstraintSetting(targetView: UIView, referenceView: UIView, position: Position, edgeInsets: UIEdgeInsets) {
        
        let convertPoint = referenceView.convert(referenceView.bounds, to: targetView)
        let fixEdgeInsetGap = (edgeInsets.left - edgeInsets.right) * 0.5
        let constantGap: CGFloat
        
        switch position {
        case .center(let gap): constantGap = convertPoint.midX - targetView.bounds.midX + gap
        case .left(let gap): constantGap = convertPoint.minX - targetView.bounds.midX + gap
        case .right(let gap): constantGap = convertPoint.maxX - targetView.bounds.midX - gap
        }
        
        self.targetView = targetView
        self.referenceView = referenceView
        self.position = position

        centerXConstraints.forEach { $0.constant = constantGap  - fixEdgeInsetGap }
    }
    
    /// [定位的VFL處理 (左右對齊 / 高度自適應)](https://serpapi.com/google-autocomplete-api)
    /// - Parameters:
    ///   - view: UIView
    ///   - direction: Direction
    ///   - edgeInsets: 邊界間距
    /// - Returns: [String]
    func visualFormats(at view: UIView, direction: Direction = .upper, edgeInsets: UIEdgeInsets) -> [String] {
        
        let minHeight = contentLabel.font.pointSize + 8
        let visualFormat: String
        
        switch direction {
        case .upper: visualFormat = "V:[view]-(\(-edgeInsets.bottom-view.bounds.height))-[self]"
        case .lower: visualFormat = "V:[view]-(\(edgeInsets.top))-[self]"
        }
        
        return ["H:|-(\(edgeInsets.left))-[self]-(\(edgeInsets.right))-|", "\(visualFormat)", "V:[self(>=\(minHeight)@750)]"]
    }
    
    /// 修正畫面旋轉時定位點的設定
    func fixScreenRotationSetting() {
        
        guard let targetView,
              let referenceView,
              let position
        else {
            return
        }
        
        centerXConstraintSetting(targetView: targetView, referenceView: referenceView, position: position, edgeInsets: edgeInsets)
    }
}
