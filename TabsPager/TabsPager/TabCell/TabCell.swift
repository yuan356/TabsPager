//
//  TabCell.swift
//  CAFFECOIN
//
//  Created by Will on 2021/8/12.
//  Copyright © 2021 DaidoujiChen. All rights reserved.
//

import UIKit

class TabCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleDefaultColor: UIColor? {
        didSet {
            titleLabel.textColor = titleDefaultColor
        }
    }
    
    var titleFont: UIFont! {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var titleSelectedColor: UIColor?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(titleLabel)
        titleLabel.centerInSuperView()
    }
    
    var title: String! {
        didSet { titleLabel.text = title }
    }
    
    func selected() {
        titleLabel.textColor = titleSelectedColor
    }
    
    func deselected() {
        titleLabel.textColor = titleDefaultColor ?? UIColor.darkGray
    }
    
    override func prepareForReuse() {
        deselected()
    }
    
}
