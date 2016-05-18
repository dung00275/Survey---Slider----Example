//
//  SurveyMarkView.swift
//  SurveySliderExample
//
//  Created by Dung Vu on 5/18/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

class SurveyMarkView: SliderMarkView {
    
    private var colorNormal: UIColor = UIColor.clearColor()
    
    private var colorTextHighLight = UIColor.whiteColor()
    private var backgroundTextHighLight = UIColor.blueColor()
    
    @IBOutlet weak var lblInfo: UILabel!
    
    override var highlight: Bool {
        didSet{
            if highlight == true {
                lblInfo.textColor = colorTextHighLight
                lblInfo.backgroundColor = backgroundTextHighLight
            }else {
                lblInfo.textColor = colorNormal
                lblInfo.backgroundColor = colorNormal
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}