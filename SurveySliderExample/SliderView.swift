//
//  SliderView.swift
//  SurveySliderExample
//
//  Created by Dung Vu on 5/17/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

struct SliderMarkItem {
    let topView: UIView?
    let bottomView: UIView?
}

protocol SliderViewDelegate: class {
    func sliderViewDidSelect(didSelectAt index: Int,item: SliderMarkItem?)
}

protocol SliderViewDataSource: class {
    // General
    func sliderViewSpacingLeftRight() -> CGFloat
    func sliderViewHeightForTrack() -> CGFloat
    
    
    func sliderViewColorForMinimum() -> UIColor
    func sliderViewColorForNormal() -> UIColor
    
    // Mark
    func sliderViewSizeForMark() -> CGSize
    func sliderViewNeedShowTopBottom() -> Bool
    func sliderViewNumberMark() -> Int
    
    func sliderViewColorForMarkHightLight() -> UIColor
    func sliderViewColorForMarkNormal() -> UIColor
    
    func sliderViewMarkViewAtIndex(index: Int) -> SliderMarkItem?
}




public class SliderView: UIView {
    
    weak var delegate: SliderViewDelegate!
    weak var dataSource: SliderViewDataSource!
    
    private var trackLayer: CAShapeLayer!
    private var trackLayerMinimum: CAShapeLayer!
    
    private var arrayViewMark: [CAShapeLayer] = []
    private var arrayShapeMark: [CAShapeLayer] = []
    
    private var spacing: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public func reloadData() {
        guard dataSource != nil && delegate != nil else {
            fatalError("Need set delegate and datasource")
        }
        
        // Remove all first
        self.layer.sublayers?.removeAll()
        self.subviews.forEach({$0.removeFromSuperview()})
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
        let colorMark = dataSource.sliderViewColorForMarkNormal()
        
        let space = (widthOffset - CGFloat(numberMark) * sizeMark.width) / (CGFloat(numberMark - 1))
        self.spacing = space
        
        var currentOffset = heightTrack + inset
        let yOffset = CGRectGetMidY(self.bounds) - sizeMark.width / 2
        
        for _ in 0..<numberMark {
            let markShape = createMark(sizeMark, color: colorMark)
            markShape.frame = CGRect(origin: CGPointMake(currentOffset, yOffset), size: sizeMark)
            self.layer.addSublayer(markShape)
            arrayShapeMark.append(markShape)
            
            currentOffset += (space + sizeMark.width)
        }
        
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
        
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.locationInView(self)
        
    }
    
    
}