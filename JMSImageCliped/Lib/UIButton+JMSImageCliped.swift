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
    ///     - parameter fillStateElements:  填充元素数组(state对应UIButton状态，item可放对象为UIColor, UIImage, String或者Data，isBackgroundImage标记是否是背景)
    ///     - parameter backgroundColor:	背景色
    ///     - parameter cornerRadius:       圆角大小
    ///     - parameter rectCornerType:     填充角
    ///     - parameter borderWidth:        边框宽度
    ///     - parameter borderColor:        边框颜色
    /// - Returns Void
    public func jms_rc_setBtnImage(fillStateElements: Array<(state: UIControlState, item: Any, isBackgroundImage: Bool)>, backgroundColor: UIColor? = nil, cornerRadius: CGFloat = 0, rectCornerType: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        self.layoutIfNeeded()
        
        let tempToSize = self.bounds.size
        self.backgroundColor = backgroundColor
        
        for (state, item, isBackgroundImage) in fillStateElements {
            if isBackgroundImage {
                self.setBackgroundImage(nil, for: state)
            }else {
                self.setImage(nil, for: state)
            }
            
            DispatchQueue.global().async { [weak self] in
                var image: UIImage?
                var isCliped: Bool = false
                
                if let tempString = item as? String {
                    image = UIImage.init(named: tempString)
                }else if let tempImage = item as? UIImage {
                    image = tempImage
                }else if let tempData = item as? Data {
                    image = UIImage.init(data: tempData)
                }else if let tempColor = item as? UIColor {
                    isCliped = true
                    image = UIImage.jms_rc_image(fillColor: tempColor, toSize: tempToSize, cornerRadius: cornerRadius, rectCornerType: rectCornerType, borderWidth: borderWidth, borderColor: borderColor)
                }
                
                if !isCliped {
                    image = image?.jms_rc_clipToSize(targetSize: tempToSize, backgroundColor: backgroundColor, cornerRadius: cornerRadius, rectCornerType: rectCornerType, borderWidth: borderWidth, borderColor: borderColor, isEqualScale: false, isCircle: false)
                }
                
                self?.updContentInMainThread(image, state, isBackgroundImage)
            }
        }
    }
    
    fileprivate func updContentInMainThread(_ clipedImage: UIImage?, _ forState: UIControlState, _ isBackgroudImage: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            if isBackgroudImage {
                self.setBackgroundImage(clipedImage, for: forState)
            }else {
                self.setImage(clipedImage, for: forState)
            }
        }
    }
    
}
