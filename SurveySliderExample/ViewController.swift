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
        
        sliderView.sliderViewSelectAtIndex(3)
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
    func sliderViewDidSelect(didSelectAt index: Int)
    {
        print("Did Select : \(index)")
    }
}

extension ViewController:SliderViewDataSource {
    
    func sliderViewSpacingLeftRight() -> CGFloat {
        return 5
    }
    
    func sliderViewNumberMark() -> Int{
        return 5
    }

    func sliderViewSizeForMark() -> CGSize {
        return CGSizeMake(15, 15)
    }
    
    func sliderViewMarkViewAtIndex(index: Int) -> SliderMarkView? {
        let view = NSBundle.mainBundle().loadNibNamed("SurveyMarkView", owner: nil, options: nil).first as! SurveyMarkView
        var frame = view.frame
        frame.size.height = sliderView.bounds.height
        view.frame = frame
        
        switch index {
        case 0:
            view.lblInfo.text = "Kém"
        case 1:
            view.lblInfo.text = "Trung bình"
        case 2:
            view.lblInfo.text = "Tốt"
        case 3:
            view.lblInfo.text = "Khá"
        case 4:
            view.lblInfo.text = "Rất tốt"
        default:
            break
        }
        
        return view
    }
    
    func sliderViewHeightForTrack() -> CGFloat {
        return 5
    }
    
    func sliderViewColorForMinimum() -> UIColor {
        return UIColor.greenColor()
    }
    func sliderViewColorForNormal() -> UIColor{
        return UIColor.blueColor()
    }
}

