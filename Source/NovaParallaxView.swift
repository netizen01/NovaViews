//
//  NovaParallaxView.swift
//  NovaViews
//

import UIKit

public class NovaParallaxView: UIView {
    
    private var origins = [UIView : CGPoint]()
    
    private func updateParallax() {
        if let scrollView = superview as? UIScrollView {
            if CGRectIntersectsRect(frame, scrollView.bounds) {
                let contentOffset = scrollView.contentOffset
                let myOffset = frame.origin
                var position = CGPoint(x: myOffset.x - contentOffset.x, y: myOffset.y - contentOffset.y)
                
                position.x = position.x / frame.size.width
                position.y = position.y / frame.size.height
                
                for subview in subviews {
                    if let origin = origins[subview] {
                        let parallaxRatio = CGFloat(subview.tag) / 100.0
                        let newOrigin = CGPoint(
                            x: origin.x + (parallaxRatio * position.x * frame.size.width),
                            y: origin.y + (parallaxRatio * position.y * frame.size.height)
                        )
                        subview.frame = CGRect(origin: newOrigin, size: subview.frame.size)
                    }
                }
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        origins.removeAll()
        for subview in subviews {
            origins[subview] = subview.frame.origin
        }
        updateParallax()
    }
    
    private var myContext = 0
    override public func willMoveToSuperview(newSuperview: UIView?) {
        if let scrollView = superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: "contentOffset", context: &myContext)
        }
        if let scrollView = newSuperview as? UIScrollView {
            scrollView.addObserver(self, forKeyPath: "contentOffset", options:.New, context: &myContext)
            
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            updateParallax()            
        }
    }
    
}
