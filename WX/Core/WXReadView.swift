//
//  WXReadView.swift
//  WX
//
//  Created by PoetCoder on 2017/9/6.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit

class WXReadView: UIView {
    var readData: WXReadData?
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        context?.textMatrix = CGAffineTransform.identity
        context?.translateBy(x: 0, y: self.bounds.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        if self.readData != nil {
            CTFrameDraw((self.readData?.ctFrame)!, context!)
        }
    }
}















