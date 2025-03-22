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
    
    private var direction: Direction?
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
    ///   - animation: 動畫類型
    ///   - position: 圖標置中對齊的樣式
    ///   - renderingMode: 圖標渲染模式
    func display(target: UIViewController, at view: UIView, direction: Direction = .upper, position: Position = .center, animation: AnimationType = .alpha, renderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        
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
        
        animationOption(status: .display, animation: animation) { [unowned self] in
        }
    }
    
    /// [移除提示框](https://www.kodeco.com/277-auto-layout-visual-format-language-tutorial)
    /// - Parameter animation: 動畫類型
    func dismiss(animation: AnimationType = .alpha) {
        
        animationOption(status: .dismiss, animation: animation) { [weak self] in
            self?.removeFromSuperview()
        }
    }
}

// MARK: 動畫效果
private extension WWTipView {
    
    /// 動畫選擇處理
    /// - Parameters:
    ///   - status: StatusType
    ///   - animation: AnimationType
    func animationOption(status: StatusType, animation: AnimationType, completion: (() -> Void)? = nil) {
        switch animation {
        case .alpha(let duration): alphaAnimation(status: status, duration: duration, completion: completion)
        case .scale(let duration, let dampingRatio): scaleAnimation(status: status, duration: duration, dampingRatio: dampingRatio, completion: completion)
        case .move(let duration, let axis, let value): moveAnimation(status: status, direction: direction, duration: duration, axis: axis, value: value, completion: completion)
        }
    }
    
    /// 透明度動畫
    /// - Parameters:
    ///   - status: StatusType
    ///   - duration: TimeInterval
    ///   - completion: (() -> Void)?
    func alphaAnimation(status: StatusType, duration: TimeInterval, completion: (() -> Void)? = nil) {
        
        let startAlpha = 0.0
        let endAlpha = 1.0
        let alpha: (from: CGFloat, to: CGFloat)
        
        switch status {
        case .display:
            alpha = (startAlpha, endAlpha)
            delegate?.tipView(self, status: .willDisplay)
        case .dismiss:
            alpha = (endAlpha, startAlpha)
            delegate?.tipView(self, status: .willDismiss)
        }
        
        contentView.alpha = alpha.from
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [unowned self] in
            contentView.alpha = alpha.to
        }
        
        animator.addCompletion { [weak self] position in
            
            guard let this = self else { return }
            
            switch position {
            case .start, .current: break
            case .end:
                completion?()
                switch status {
                case .display: this.delegate?.tipView(this, status: .didDisplay)
                case .dismiss: this.delegate?.tipView(this, status: .didDismiss)
                }
            }
        }
        
        animator.startAnimation()
    }
    
    /// 移動動畫
    /// - Parameters:
    ///   - status: StatusType
    ///   - direction: Direction?
    ///   - duration: TimeInterval
    ///   - completion: (() -> Void)?
    func moveAnimation(status: StatusType, direction: Direction?, duration: TimeInterval, axis: NSLayoutConstraint.Axis, value: CGFloat, completion: (() -> Void)? = nil) {
        
        guard let direction else { return }
        
        let value: CGFloat = (direction == .lower) ? -value : value
        let startTramform = (axis == .vertical) ? CGAffineTransform(translationX: 0, y: value) : CGAffineTransform(translationX: -value, y: 0)
        let endTramform = CGAffineTransform.identity
        let tramform: (from: CGAffineTransform, to: CGAffineTransform)
        
        switch status {
        case .display: tramform = (startTramform, endTramform)
        case .dismiss: tramform = (endTramform, startTramform)
        }
        
        contentView.transform = tramform.from
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [unowned self] in
            contentView.transform = tramform.to
        }
        
        animator.startAnimation()
        alphaAnimation(status: status, duration: duration, completion: completion)
    }
    
    /// 縮放動畫
    /// - Parameters:
    ///   - status: StatusType
    ///   - duration: TimeInterval
    ///   - ratio: CGFloat
    ///   - completion: (() -> Void)?
    func scaleAnimation(status: StatusType, duration: TimeInterval, dampingRatio ratio: CGFloat, completion: (() -> Void)? = nil) {
        
        let startTramform = CATransform3DMakeScale(0.1, 0.1, 1.0)
        let endTramform = CATransform3DIdentity
        let tramform: (from: CATransform3D, to: CATransform3D)
        
        switch status {
        case .display: tramform = (startTramform, endTramform)
        case .dismiss: tramform = (endTramform, startTramform)
        }
        
        contentView.layer.transform = tramform.from
        
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: ratio) { [unowned self] in
            contentView.layer.transform = tramform.to
        }
        
        animator.startAnimation()
        alphaAnimation(status: status, duration: duration, completion: completion)
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
        self.direction = direction
        
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
