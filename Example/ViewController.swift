//
//  ViewController.swift
//  Example
//
//  Created by Will on 2022/3/29.
//

import UIKit
import TabsPager

class ViewController: UIViewController {

    var tabsPager = TabsPager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabPager()
    }
    
    var tabs = ["Tab1", "Tab2Tab2Tab2", "Tab3", "Tab4", "Tab5", "Tab6", "Tab7"]

    
    private func setTabPager() {
        
        // 1. Set TabPager attributes if you want before assign viewControllers
//        tabPager.tabColor = .yellow
//        tabPager.tabLineColor = .green
//        tabPager.backgroundColor = .gray
//        tabPager.tabTitleColor = .red
//        tabPager.tabSelectedTitleColor = .brown
//        tabPager.sliderColor = .blue
//        tabPager.tabTextFont = .systemFont(ofSize: 18)
        
        // 2. Add tabPage to your view
        self.addChild(tabsPager)
        view.addSubview(tabsPager.view)
        tabsPager.view.fillSuperview()
        
        // 3. Set viewControlles
        setControllers()
    }
    
    private func setControllers() {
        
        var vcs: [ContentViewController] = [] // ViewController must inherit TabPagerContentVC
        for (i, title) in tabs.enumerated() {
            let vc = ContentViewController()
            vc.pageIndex = i // Override page index
            vc.tabTitle = title // Override tab title
            vcs.append(vc)
        }

        tabsPager.contentVCs = vcs
    }
}

