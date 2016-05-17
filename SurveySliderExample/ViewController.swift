//
//  ViewController.swift
//  SurveySliderExample
//
//  Created by Dung Vu on 5/17/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sliderView: SliderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sliderView.delegate = self
        sliderView.dataSource = self
        
        sliderView.reloadData()
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:SliderViewDelegate {
    func sliderViewDidSelect(didSelectAt index: Int,
                                         item: SliderMarkItem?)
    {
        
    }
}

extension ViewController:SliderViewDataSource {
    
    func sliderViewSpacingLeftRight() -> CGFloat {
        return 5
    }
    
    func sliderViewNumberMark() -> Int{
        return 4
    }
    func sliderViewNeedShowTopBottom() -> Bool{
        return false
    }
    
    func sliderViewSizeForMark() -> CGSize {
        return CGSizeMake(15, 15)
    }
    
    func sliderViewMarkViewAtIndex(index: Int) -> SliderMarkItem?
    {
        return nil
    }
    
    func sliderViewColorForMarkHightLight() -> UIColor{
        return UIColor.greenColor()
    }
    func sliderViewColorForMarkNormal() -> UIColor{
        return UIColor.redColor()
    }
    
    func sliderViewHeightForTrack() -> CGFloat {
        return 8
    }
    
    func sliderViewColorForMinimum() -> UIColor {
        return UIColor.greenColor()
    }
    func sliderViewColorForNormal() -> UIColor{
        return UIColor.blueColor()
    }
}

