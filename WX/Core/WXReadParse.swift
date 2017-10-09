//
//  WXReadParse.swift
//  WX
//
//  Created by PoetCoder on 2017/9/18.
//  Copyright © 2017年 PoetCoder. All rights reserved.
//

import UIKit

class WXReadParse: NSObject {

    
    public func attributeWithConfig(config:WXReadConfig) -> NSMutableDictionary {
        let fontSize: CGFloat = config.fontSize == nil ? 16 : config.fontSize!
        let font = UIFont.systemFont(ofSize: fontSize)
        let color = config.fontColor == nil ? UIColor.white : config.fontColor
        var lineSpacing = config.lineSpace == nil ? 8 : config.lineSpace
        var firstSpacing:CGFloat = 40
        var headIndent:CGFloat = 20
//        var tailIndent:CGFloat = 10
//        CTParagraphStyleSetting(spec: .tailIndent, valueSize: MemoryLayout<CGFloat>.size, value: &tailIndent)
        let setting:[CTParagraphStyleSetting] = [CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing!),
                                                 CTParagraphStyleSetting(spec: .maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),
                                                 CTParagraphStyleSetting(spec: .minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),
                                                 CTParagraphStyleSetting(spec: .firstLineHeadIndent, valueSize: MemoryLayout<CGFloat>.size, value: &firstSpacing),
                                                 CTParagraphStyleSetting(spec: .headIndent, valueSize: MemoryLayout<CGFloat>.size, value: &headIndent)]
        let paragraph = CTParagraphStyleCreate(setting, setting.count)
        
        let dict = NSMutableDictionary()
        
        dict[kCTFontAttributeName] = font
        dict[kCTForegroundColorAttributeName] = color
        dict[kCTParagraphStyleAttributeName] = paragraph
        return dict
    }

    public func parseAttributed(content:String, config:WXReadConfig) -> WXReadData {
        
        let attributes = self.attributeWithConfig(config: config)
        
        let attributrStr = NSMutableAttributedString(string: content)
        
        attributrStr.addAttributes(attributes as! [String : Any], range: NSMakeRange(0, attributrStr.length))
        
        //创建CTRramesetter
        let framesetter = CTFramesetterCreateWithAttributedString(attributrStr)
        
        //获取绘制区域的高度
        let restrictSize = CGSize(width: config.width!, height:
            CGFloat(MAXFLOAT))
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil)
        let textHeight = coreTextSize.height
        
        
        let path = CGMutablePath()
        path.addRect(CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: config.width!, height: textHeight)))
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        let data = WXReadData()
        data.ctFrame = frame
        data.height = textHeight
        
        return data
    }
}






















