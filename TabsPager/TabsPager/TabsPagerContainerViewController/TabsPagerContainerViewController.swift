//
//  CustomTabPageViewController.swift
//  CAFFECOIN
//
//  Created by Will on 2021/8/12.
//  Copyright © 2021 DaidoujiChen. All rights reserved.
//

import UIKit

protocol TabsPagerContainerDelegate: NSObject {
    func updatePage(to row: Int)
    func movingPage(ratio: CGFloat, from currentIndex: Int, to index: Int)
}

class TabsPagerContainerViewController: UIPageViewController {

    var currentIndex : Int = 0
        
    weak var pageDelegate: TabsPagerContainerDelegate?
    
    var scrollable = true {
        didSet {
            if !scrollable {
                self.dataSource = nil
            }
        }
    }
    
    var controllers: [TabsPagerContentVC] = [] {
        didSet {
            setControllersContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
    }
  
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        for v in view.subviews{
            if v is UIScrollView {
                (v as! UIScrollView).delegate = self
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setControllersContent() {
        let startIndex = currentIndex
        if let startingVC = contentViewController(at: startIndex) {
            self.setViewControllers([startingVC], direction: .forward, animated: false, completion: nil)
            currentIndex = startIndex
        }
    }
    
    func contentViewController(at pageIndex: Int) -> TabsPagerContentVC? {
        guard (0..<controllers.count) ~= pageIndex else { return nil }
        return self.controllers[pageIndex]
    }
    
    func updatePage(to index: Int) {
        guard self.currentIndex != index else { return }
        
        let direction: NavigationDirection = (self.currentIndex < index) ? .forward : .reverse
        self.currentIndex = index
        if let vc = self.contentViewController(at: currentIndex) {
            self.setViewControllers([vc], direction: direction, animated: false, completion: nil)
        }
    }
}

extension TabsPagerContainerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetX = scrollView.contentOffset.x
        let width = scrollView.frame.size.width
        let progress = (contentOffsetX - width) / width
        if progress < 0 && currentIndex != 0 { // 不是第一個
            self.pageDelegate?.movingPage(ratio: progress * -1, from: currentIndex, to: currentIndex-1)
            return
        }
        
        if progress > 0 && currentIndex != controllers.count-1 { // 不是最後一個
            self.pageDelegate?.movingPage(ratio: progress, from: currentIndex, to: currentIndex+1)
            return
        }
    }
}

extension TabsPagerContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? TabsPagerContentVC {
            var pageIndex = vc.pageIndex
            pageIndex -= 1
            return contentViewController(at: pageIndex)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? TabsPagerContentVC {
            var pageIndex = vc.pageIndex
            pageIndex += 1
            return contentViewController(at: pageIndex)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let vc = pageViewController.viewControllers?.first as? TabsPagerContentVC {
                self.currentIndex = vc.pageIndex
                self.pageDelegate?.updatePage(to: vc.pageIndex)
            }
        }
    }

}
