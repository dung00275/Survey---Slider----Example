//
//  SliderView.swift
//  SurveySliderExample
//
//  Created by Dung Vu on 5/17/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit


public protocol SliderMarkItemProtocol {
    var highlight: Bool {get set}
}

public class SliderMarkView:UIView,SliderMarkItemProtocol {
    private var _highlight: Bool = false
    
    public var highlight: Bool {
        get{
            return _highlight
        }
        set(newValue){
            _highlight = newValue
        }
    }
}

protocol SliderViewDelegate: class {
    func sliderViewDidSelect(didSelectAt index: Int)
}

protocol SliderViewDataSource: class {
    // General
    func sliderViewSpacingLeftRight() -> CGFloat
    func sliderViewHeightForTrack() -> CGFloat
    
    
    func sliderViewColorForMinimum() -> UIColor
    func sliderViewColorForNormal() -> UIColor
    
    // Mark
    func sliderViewSizeForMark() -> CGSize
    func sliderViewNumberMark() -> Int
    func sliderViewMarkViewAtIndex(index: Int) -> SliderMarkView?
}




public class SliderView: UIView {
    
    weak var delegate: SliderViewDelegate!
    weak var dataSource: SliderViewDataSource!
    
    private var trackLayer: CAShapeLayer!
    private var trackLayerMinimum: CAShapeLayer!
    
    private var arrayViewMark: [SliderMarkView] = []
    private var arrayShapeMark: [CAShapeLayer] = []
    
    private var spacing: CGFloat = 1
    private var currentIndex: Int = -1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public func reloadData() {
        // Remove all first
        self.layer.sublayers?.removeAll()
        self.subviews.forEach({$0.removeFromSuperview()})
        arrayViewMark.removeAll()
        arrayShapeMark.removeAll()
        currentIndex = -1
        guard dataSource != nil && delegate != nil else {
            fatalError("Need set delegate and datasource")
        }
        
        setNeedsDisplay()
        
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Track layer
        trackLayer = createTrackLayer(dataSource.sliderViewColorForNormal())
        trackLayerMinimum = createTrackLayer(dataSource.sliderViewColorForMinimum())
        trackLayerMinimum.strokeEnd = 0
        
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(trackLayerMinimum)
        
        let numberMark = dataSource.sliderViewNumberMark()
        let inset = dataSource.sliderViewSpacingLeftRight()
        let heightTrack = dataSource.sliderViewHeightForTrack()
        let sizeMark =  dataSource.sliderViewSizeForMark()

        let widthOffset = self.bounds.width - heightTrack * 2 - inset * 2
        let colorMark = dataSource.sliderViewColorForNormal()
        
        let space = (widthOffset - CGFloat(numberMark) * sizeMark.width) / (CGFloat(numberMark - 1))
        self.spacing = space
        
        var currentOffset = heightTrack + inset
        let yOffset = CGRectGetMidY(self.bounds) - sizeMark.width / 2
        
        for i in 0..<numberMark {
            let markShape = createMark(sizeMark, color: colorMark)
            markShape.frame = CGRect(origin: CGPointMake(currentOffset, yOffset), size: sizeMark)
            self.layer.addSublayer(markShape)
            arrayShapeMark.append(markShape)
            if let markView = dataSource.sliderViewMarkViewAtIndex(i) {
                arrayViewMark.append(markView)
                self.insertSubview(markView, atIndex: 0)
                let widthView = markView.frame.width
                let centerX = currentOffset + sizeMark.width / 2
                let offsetX = centerX - widthView / 2
                let newframe = CGRect(origin: CGPointMake(offsetX, 0), size: markView.frame.size)
                markView.frame = newframe
            }
            

            currentOffset += (space + sizeMark.width)
        }
        
        if currentIndex >= 0 {self.sliderViewSelectAtIndex(currentIndex)}
        
    }
    
    private func createMark(size: CGSize, color: UIColor) -> CAShapeLayer {
        let shape = CAShapeLayer()
        let benzierPath = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: size))
        benzierPath.closePath()
        shape.path = benzierPath.CGPath
        shape.fillColor = color.CGColor
        
        return shape
    }
    
    private func createTrackLayer(color: UIColor) -> CAShapeLayer {
        
        let height = dataSource.sliderViewHeightForTrack()
        
        let shape = CAShapeLayer()
        let frame = CGRect(origin: CGPointMake(0, CGRectGetMidY(self.bounds)), size: CGSizeMake(self.bounds.width, 1))
        shape.frame = frame
        
        let benzierPath = UIBezierPath()
        benzierPath.moveToPoint(CGPointMake(height, 0))
        benzierPath.addLineToPoint(CGPointMake(self.bounds.width - height, 0))
        benzierPath.lineCapStyle = .Round
        shape.path = benzierPath.CGPath
        
        shape.fillColor = UIColor.yellowColor().CGColor
        shape.lineCap = kCALineCapRound
        shape.lineWidth = height
        shape.strokeColor = color.CGColor

        return shape
    }
    
    
    public func sliderViewSelectAtIndex(index: Int) {
        currentIndex = index
        guard arrayViewMark.count > 0 && arrayShapeMark.count > 0 else {
            return
        }
        
        let colorNormal = dataSource.sliderViewColorForNormal()
        let colorHighlight =  dataSource.sliderViewColorForMinimum()
        // Reset first
        
        arrayViewMark.forEach{$0.highlight = false}
        arrayShapeMark.forEach({$0.fillColor = colorNormal.CGColor})
        
        let viewMark = arrayViewMark[index]
        let progress = calculateProgress(index)
        
        for i in 0...index{
            let otherShape = arrayShapeMark[i]
            otherShape.fillColor = colorHighlight.CGColor
        }
        
        viewMark.highlight = true
        trackLayerMinimum.strokeEnd = progress
    }
    
    private func calculateProgress(index: Int) -> CGFloat {
        var progess: CGFloat = 0
        if index == arrayShapeMark.count - 1
        {
            progess = 1
        }else {
            let shape = arrayShapeMark[index]
            if index == 0 {
                progess = shape.frame.origin.x  / (self.bounds.width)
            }else {
                let lineWidth = dataSource.sliderViewHeightForTrack()
                
                progess = (shape.frame.origin.x + (shape.frame.size.width - lineWidth)) / (self.bounds.width)
            }
        }
        
        return progess
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.locationInView(self)
        
        let containerRect = CGRect(origin: CGPointZero,
                                   size: CGSizeMake(point.x, self.bounds.height))
        let colorNormal = dataSource.sliderViewColorForNormal()
        let colorHighlight =  dataSource.sliderViewColorForMinimum()
        
        var indexMax = -1
        var maxOffset:CGFloat = -1
        for (index,shape) in arrayShapeMark.enumerate() {
            if CGRectContainsPoint(containerRect, shape.frame.origin) {
                indexMax = index
                maxOffset = shape.frame.origin.x
                shape.fillColor = colorHighlight.CGColor
            }else {shape.fillColor = colorNormal.CGColor}
            
            let viewMark = arrayViewMark[index]
            
            viewMark.highlight = false
        }
        
        if maxOffset > 0 && indexMax < arrayShapeMark.count - 1 {
            if point.x > (maxOffset + spacing / 2) {
                indexMax += 1
                let shape = arrayShapeMark[indexMax]
                shape.fillColor = colorHighlight.CGColor
            }
        }
        
        var progess: CGFloat = 0
        
        if indexMax >= 0 {
            progess = calculateProgress(indexMax)
            
            let viewMark = arrayViewMark[indexMax]
            
            viewMark.highlight = true
            
        }
        trackLayerMinimum.strokeEnd = progess
        delegate.sliderViewDidSelect(didSelectAt: indexMax)
        
    }
    
    
}