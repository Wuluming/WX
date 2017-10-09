//
//  WXButton.swift
//  WX
//
//  Created by PoetCoder on 2017/9/6.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit

class WXButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let x:CGFloat = 0
        let w = contentRect.size.width
        let h = contentRect.size.height * 0.3
        let y:CGFloat = contentRect.size.height * 0.7
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let x:CGFloat = 0
        let y:CGFloat = 0
        let w = contentRect.size.width
        let h = contentRect.size.height * 0.7
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
