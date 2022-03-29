//
//  CustomTabViewController.swift
//  CAFFECOIN
//
//  Created by Will on 2021/8/12.
//  Copyright © 2021 DaidoujiChen. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width

let systemDefaultColor = UIColor.init(red: 173/225, green: 139/225, blue: 115/225, alpha: 1.0)


struct TabPosition {
    var width: CGFloat
    var centerX: CGFloat
    var cell: TabCell
}

public class TabPager: UIViewController {
    
    private var selectedTab: TabCell?
    
    private var tabs: [Int: TabPosition] = [:]
    
    private var pageIndex: Int = 0
    
    private var slider = TabPageSlider()
    
    private var pageViewController = TabContainerPageViewController()
    
    public var contentVCs: [TabPagerContentVC] = [] {
        didSet {
            pageViewController.controllers = contentVCs
            pageViewController.currentIndex = pageIndex
            tabCollectionView.reloadData()
            tabCollectionView.layoutIfNeeded()
            setSlider()
        }
    }
    
    lazy var tabCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        var collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(TabCell.self, forCellWithReuseIdentifier: String(describing: TabCell.self))
        collectionview.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .clear
        self.view.addSubview(collectionview)
        return collectionview
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    public var tabEqually = false
    
    public var sliderColor: UIColor?
    
    public var tabLineColor: UIColor? {
        didSet {
            if let color = tabLineColor {
                tabLineView.backgroundColor = color
            }
        }
    }
    
    lazy var tabView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var tabLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    public var tabTitleTextPadding: CGFloat?
    
    public var tabColor: UIColor? {
        didSet {
            if let color = tabColor {
                tabView.backgroundColor = color
            }
        }
    }
    
    public var tabTitleColor: UIColor = .darkGray
    
    public var tabSelectedTitleColor: UIColor = systemDefaultColor
    
    public var tabTextFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    public var backgroundColor: UIColor? {
        didSet {
            if let color = backgroundColor {
                view.backgroundColor = color
            }
        }
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageViewController()
        setViews()
    }
    
    private func setViews() {
        view.addSubview(tabView)
        tabView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        tabView.addSubview(tabCollectionView)
        tabCollectionView.anchor(top: tabView.topAnchor, leading: tabView.leadingAnchor, bottom: tabView.bottomAnchor, trailing: tabView.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0))

        tabCollectionView.anchorSize(h: 40)
        
        tabView.addSubview(tabLineView)
        tabLineView.anchorSize(h: 1)
        tabLineView.anchor(top: tabCollectionView.bottomAnchor, leading: tabView.leadingAnchor, bottom: nil, trailing:  tabView.trailingAnchor, padding: .init(top: -1.5, left: 0, bottom: 0, right: 0))
        
        view.addSubview(containerView)
        containerView.anchor(top: tabView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        tabView.bringSubviewToFront(tabCollectionView)
    }
    
    private func setupPageViewController() {
        pageViewController.pageDelegate = self
        self.addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        
    }

    private func switchTab(to index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        if let tabCell = selectedTab {
            tabCell.deselected()
        }
        
        tabCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if let tab = tabs[index] {
            slider.moveSlider(index: index, width: tab.width, x: tab.centerX)
            tab.cell.selected()
            selectedTab = tab.cell
            pageIndex = index
        }
    }
    
    func goPageAndSwitchTab(index: Int) {
        pageViewController.updatePage(to: index)
        switchTab(to: index)
    }
    
}

// MARK: TabContainerPageDelegate
extension TabPager: TabContainerPageDelegate {
    
    func updatePage(to row: Int) {
        switchTab(to: row)
    }
    
    func movingPage(ratio: CGFloat, from currentIndex: Int, to index: Int) {
        if let current = tabs[currentIndex],
           let destination = tabs[index] {
            slider.moving(ratio: ratio, from: (current.width, current.centerX), to: (destination.width, destination.centerX))
        }
    }
}


// MARK: Slider
extension TabPager {
    
    private func setSlider() {
        slider.sliderColor = sliderColor
        let index = pageIndex
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tabCollectionView.cellForItem(at: indexPath) {
            slider.setWidth(cell.frame.size.width)
            slider.setY(tabCollectionView.bounds.maxY-1.5)
            slider.addToView(in: tabCollectionView)
        }
        
        switchTab(to: index)
    }
}

// MARK: UICollectionViewDelegate
extension TabPager: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentVCs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: TabCell.self, for: indexPath)
        if pageIndex == indexPath.row {
            cell.selected()
            selectedTab = cell
        }
        cell.title = self.contentVCs[indexPath.row].tabTitle
        cell.titleFont = tabTextFont
        
        tabs[indexPath.row] = TabPosition(width: cell.bounds.width, centerX: cell.center.x, cell: cell)
        cell.titleDefaultColor = tabTitleColor
        cell.titleSelectedColor = tabSelectedTitleColor
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = self.contentVCs[indexPath.row].tabTitle
        let size = title.size(withAttributes: [.font: tabTextFont])
        let padding: CGFloat = tabTitleTextPadding ?? 20
        var width = size.width + padding
        

        if tabEqually {
            width = ScreenWidth / CGFloat(contentVCs.count)
        }
        
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        goPageAndSwitchTab(index: index)
    }
    
}
