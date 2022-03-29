//
//  TabPageSlider.swift
//  CAFFECOIN
//
//  Created by Will on 2021/8/18.
//  Copyright © 2021 DaidoujiChen. All rights reserved.
//

import UIKit
import AnchorLayout

class TabsPagerSlider {
                
    var slider = UIView()
    
    let sliderHeight: CGFloat = 3
    
    var sliderColor: UIColor? {
        didSet {
            slider.backgroundColor = sliderColor ?? systemDefaultColor
        }
    }
        
    init() {
        slider.layer.cornerRadius = 2
        slider.frame.size.height = sliderHeight
    }
    
    func moveSlider(index: Int, width: CGFloat, x: CGFloat, animated: Bool = true) {
        let duration = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            self.setWidth(width)
            self.slider.center.x = x
        }
    }
    
    func setWidth(_ width: CGFloat) {
        slider.frame.size.width = width
    }
    
    func setY(_ y: CGFloat) {
        slider.center.y = y
    }
    
    func addToView(in view: UIView) {
        view.addSubview(slider)
    }
    
    func moving(ratio: CGFloat, from a: (width: CGFloat, x: CGFloat), to b: (width: CGFloat, x: CGFloat)) {
        let distanceDiff = (b.x - a.x) * ratio
        let widthDiff = (b.width - a.width) * ratio
        slider.center.x = a.x + distanceDiff
        slider.frame.size.width = a.width + widthDiff
    }
}
