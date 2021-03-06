//
//  ContentViewController.swift
//  Example
//
//  Created by Will on 2022/3/25.
//

import UIKit
import TabsPager

class ContentViewController: TabsPagerContentVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let indexLabel = UILabel()
        indexLabel.text = tabTitle
        indexLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        indexLabel.textColor = .darkGray
        view.addSubview(indexLabel)
        indexLabel.centerInSuperView()
    }
    

}
