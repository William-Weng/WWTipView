//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/3/21.
//

import UIKit
import WWTipView

// MARK: - ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func displayTipView(_ sender: UIButton) {
        
        let tipView = WWTipView()
        
        tipView.tintColor = .black
        tipView.delegate = self
        tipView.text = "Oh my God, I was pressed..."
        tipView.textColor = .white
        tipView.edgeInsets = .init(top: 8, left: 56, bottom: 4, right: 20)
        tipView.display(target: self, at: sender, position: .center)
    }
    
    @IBAction func showTipView(_ sender: UIBarButtonItem) {
        
        let tipView = WWTipView()
        
        tipView.delegate = self
        tipView.tintColor = .white
        tipView.upperImage = UIImage(named: "flash")
        tipView.lowerImage = UIImage(named: "typhoon")
        tipView.text = "Intro to Swift Visual Formatting Language — The Good, The Bad, and The VFL"
        tipView.display(target: self, at: label, direction: .lower, position: .right, animation: .scale, renderingMode: .alwaysOriginal)
    }
}

// MARK: - WWTipView.Delegate
extension ViewController: WWTipView.Delegate {
    
    func tipView(_ tipView: WWTipView, didTouched: Bool) {
        if didTouched { tipView.dismiss(animation: .move) }
    }
    
    func tipView(_ tipView: WWTipView, status: WWTipView.AnimationStatusType) {
        print(status)
    }
}
