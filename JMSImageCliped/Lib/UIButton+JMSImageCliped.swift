//
//  UIButton.swift
//  JMSRounedCorners
//
//  Created by James.xiao on 2017/7/26.
//  Copyright © 2017年 James. All rights reserved.
//

import UIKit

public extension UIButton {

    /// 使用指定的图片来填充各个状态
    ///
    /// - Parameters:
    ///     - parameter fillStateElements:  填充元素字典(Dictionary的Value可放对象为UIColor, UIImage, String或者Data)
    ///     - parameter backgroundColor:	背景色
    ///     - parameter cornerRadius:       圆角大小
    ///     - parameter rectCornerType:     填充角
    ///     - parameter borderWidth:        边框宽度
    ///     - parameter borderColor:        边框颜色
    /// - Returns Void
    public func jms_rc_setBtnImage(fillStateElements: Dictionary<UIControlState.RawValue, Any>, backgroundColor: UIColor? = nil, cornerRadius: CGFloat = 0, rectCornerType: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        self.layoutIfNeeded()
        
        let tempToSize = self.bounds.size
        self.backgroundColor = backgroundColor
        
        for (key, value) in fillStateElements {
            var image: UIImage?
            var isCliped: Bool = false

            if let tempString = value as? String {
                image = UIImage.init(named: tempString)
            }else if let tempImage = value as? UIImage {
                image = tempImage
            }else if let tempData = value as? Data {
                image = UIImage.init(data: tempData)
            }else if let tempColor = value as? UIColor {
                isCliped = true
                image = UIImage.jms_rc_image(fillColor: tempColor, toSize: tempToSize, cornerRadius: cornerRadius, rectCornerType: rectCornerType, borderWidth: borderWidth, borderColor: borderColor)
            }
            
            if !isCliped {
                image = image?.jms_rc_clipToSize(targetSize: tempToSize, backgroundColor: backgroundColor, cornerRadius: cornerRadius, rectCornerType: rectCornerType, borderWidth: borderWidth, borderColor: borderColor, isEqualScale: false, isCircle: false)
            }

            DispatchQueue.global().async { [weak self] in
                self?.updContentInMainThread(image, UIControlState.init(rawValue: key))
            }
        }
    }
    
    fileprivate func updContentInMainThread(_ clipedImage: UIImage?, _ forState: UIControlState) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.setImage(clipedImage, for: forState)
        }
    }
    
}
