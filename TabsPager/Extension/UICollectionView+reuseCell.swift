//
//  UICollectionView+reuseCell.swift
//  CAFFECOIN
//
//  Created by Will on 2021/5/10.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(type: T.Type, bundle: Bundle? = nil) {
        let cellId = String(describing: type)
        let nib = UINib(nibName: cellId, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    public func registerCell(types: [UICollectionViewCell.Type], bundle: Bundle? = nil) {
        types.forEach { registerCell(type: $0, bundle: bundle) }
    }
    
    func dequeueCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as! T
    }
}

extension UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
