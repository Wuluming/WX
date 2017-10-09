//
//  WXToolBar.swift
//  WX
//
//  Created by PoetCoder on 2017/9/6.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit

class WXToolBar: UIToolbar {
    
    var itemBlock: ((UIBarButtonItem) ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let like = createTitle(title: "喜欢", imageName: "like", index: 0)
        let up = createTitle(title: "上一个", imageName: "up", index: 1)
        let rand = createTitle(title: "随机", imageName: "rand", index: 2)
        let down = createTitle(title: "下一个", imageName: "next", index: 3)
        let today = createTitle(title: "今日", imageName: "today", index: 4)
        
        let space:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        
        let arr = NSArray(array: [up,space,rand,space,down,space,today])
        
        self.setItems(arr as? [UIBarButtonItem], animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createTitle(title:NSString, imageName:NSString, index:NSInteger) -> UIBarButtonItem {
        
        let image = UIImage(named: imageName as String)?.withRenderingMode(.alwaysOriginal)
        let item = UIBarButtonItem(image:image, style: UIBarButtonItemStyle.plain, target: self, action:#selector(WXToolBar.itemClick(_:)))
        item.tag = index
        return item
    }
    
    func itemClick(_ item:UIBarButtonItem) {
        if (self.itemBlock != nil) {
            self.itemBlock!(item)
        }
    }
}






