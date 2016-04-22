//
//  NovaPageControlView.swift
//  NovaViews
//

import UIKit

@IBDesignable public class NovaPageControlView: UIView {
    
    @IBInspectable public var activeColor: UIColor = UIColor.grayColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var currentPageColor: UIColor = UIColor.whiteColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var inactiveColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var numberOfPages: Int = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var currentPage: CGFloat = 0 {
        didSet {
            currentPage = max(0, min(CGFloat(numberOfPages - 1), currentPage))
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var strokeWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func drawRect(rect: CGRect) {
        if numberOfPages > 0 {
            let width = rect.size.width
            let radius = rect.size.height * 0.5 - strokeWidth
            let xIncrement = width / CGFloat(numberOfPages + 1)
            let yCenter = rect.size.height * 0.5
            
            if numberOfPages > 1 {
                if currentPage < CGFloat(numberOfPages - 1) {
                    let inactivePath = UIBezierPath()
                    inactivePath.moveToPoint(CGPoint(x: xIncrement + xIncrement * floor(currentPage) + radius, y: yCenter))
                    inactivePath.addLineToPoint(CGPoint(x: xIncrement + xIncrement * floor(currentPage + 1.0) - radius, y: yCenter))
                    inactiveColor.setStroke()
                    inactivePath.lineWidth = strokeWidth
                    inactivePath.lineJoinStyle = .Round
                    inactivePath.lineCapStyle = .Round
                    inactivePath.stroke()
                }
                let activePath = UIBezierPath()
                activePath.moveToPoint(CGPoint(x: xIncrement, y: yCenter))
                activePath.addLineToPoint(CGPoint(x: xIncrement + xIncrement * currentPage - radius, y: yCenter))
                activeColor.setStroke()
                activePath.lineWidth = strokeWidth
                activePath.lineJoinStyle = .Round
                activePath.lineCapStyle = .Round
                activePath.stroke()
            }        
            
            for page in 0..<numberOfPages {
                var stroke = strokeWidth
                let current = Int(floor(currentPage))
                if page < current {
                    activeColor.setFill()
                    activeColor.setStroke()
                    stroke = 0
                } else if page == current {
                    currentPageColor.setFill()
                    activeColor.setStroke()
                } else if page == current + 1 {
                    UIColor.clearColor().setFill()
                    inactiveColor.setStroke()
                } else {
                    inactiveColor.setFill()
                    inactiveColor.setStroke()
                    stroke = 0
                }
                
                let pagePath = UIBezierPath(arcCenter: CGPoint(x: xIncrement * CGFloat(page + 1), y: yCenter),
                    radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
                pagePath.lineWidth = stroke
                pagePath.fill()
                pagePath.stroke()
            }
        }

    }

}
