//
//  UIView+JMSImageCliped.swift
//  JMSRounedCorners
//
//  Created by James.xiao on 2017/7/25.
//  Copyright © 2017年 James. All rights reserved.
//

import UIKit

public extension UIView {

    /// 生成指定图片来填充控件
    ///
    /// - Parameters:
    ///     - parameter fillElement:        填充元素(传入对象可以是UIColor, UIImage, String或者Data)
    ///     - parameter backgroundColor:	背景色
    ///     - parameter cornerRadius:       圆角大小
    ///     - parameter rectCornerType:     哪些圆角，多个圆角可用[.topLeft, .topRight, bottomLeft, .bottomRight]
    ///     - parameter borderWidth:        边框宽度
    ///     - parameter borderColor:        边框颜色
    /// - Returns Void
    public func jms_rc_setImage(fillElement: Any, backgroundColor: UIColor? = nil, cornerRadius: CGFloat = 0, rectCornerType: UIRectCorner = .allCorners,  borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        self.layoutIfNeeded()
        self.backgroundColor = backgroundColor
        
        let tempToSize = self.bounds.size
        var image: UIImage?
        var isCliped: Bool = false
        
        if let tempString = fillElement as? String {
            image = UIImage.init(named: tempString)
        }else if let tempImage = fillElement as? UIImage {
            image = tempImage
        }else if let tempData = fillElement as? Data {
            image = UIImage.init(data: tempData)
        }else if let tempColor = fillElement as? UIColor {
            isCliped = true
            image = UIImage.jms_rc_image(fillColor: tempColor, toSize: tempToSize, cornerRadius: cornerRadius, rectCornerType: rectCornerType, borderWidth: borderWidth, borderColor: borderColor)
        }
        
        if !isCliped {
            image = image?.jms_rc_clipToSize(targetSize: tempToSize, backgroundColor: backgroundColor, cornerRadius: cornerRadius, rectCornerType: rectCornerType, borderWidth: borderWidth, borderColor: borderColor, isEqualScale: false, isCircle: false)
        }
        
        DispatchQueue.global().async { [weak self] in
            self?.updContentInMainThread(image)
        }
    }
    
    fileprivate func updContentInMainThread(_ clipedImage: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
 
            if let tempClipedImage = clipedImage {
                if let tempImageView = self as? UIImageView {
                    tempImageView.image = tempClipedImage
                }else if let tempBtn = self as? UIButton {
                    tempBtn.setImage(tempClipedImage, for: .normal)
                }else {
                    self.layer.contents = tempClipedImage.cgImage
                }
            }
        }
    }
    
}
