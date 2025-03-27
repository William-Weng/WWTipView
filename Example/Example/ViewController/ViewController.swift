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
        let textSetting: WWTipView.TextSetting = (textColor: .white, underLineColor: .clear, tintColor: .black, font: .systemFont(ofSize: 14.0), lines: 0)
        
        tipView.tag = 101
        tipView.delegate = self
        tipView.texts = ["Oh my God, I was pressed...", "Oh my God, I was pressed..."]
        tipView.edgeInsets = .init(top: 8, left: 56, bottom: 4, right: 20)
        tipView.display(target: self, at: sender, position: .center, animation: .move, textSetting: textSetting)
    }
    
    @IBAction func showTipView(_ sender: UIBarButtonItem) {
                
        let tipView = WWTipView()
        
        tipView.tag = 201
        tipView.delegate = self
        tipView.upperImage = UIImage(named: "flash")
        tipView.lowerImage = UIImage(named: "typhoon")
        tipView.text = "Intro to Swift Visual Formatting Language — The Good, The Bad, and The VFL"
        tipView.display(target: self, at: label, direction: .lower, position: .center, animation: .rotate, renderingMode: .alwaysOriginal)
    }
}

// MARK: - WWTipView.Delegate
extension ViewController: WWTipView.Delegate {
    
    func tipView(_ tipView: WWTipView, didTouchedIndex index: Int) {
                
        if (tipView.tag == 201) {
            tipView.selectedColor(with: [index])
            tipView.dismiss(animation: .rotate)
        } else {
            tipView.selectedColor(.red, with: [index])
            tipView.dismiss(animation: .move)
        }
    }
    
    func tipView(_ tipView: WWTipView, status: WWTipView.AnimationStatusType) {
        print(status)
    }
}
