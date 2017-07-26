//
//  UIImage.swift
//  JMSRounedCorners
//
//  Created by James.xiao on 2017/7/25.
//  Copyright © 2017年 James. All rights reserved.
//

import UIKit

public extension UIImage {

    /// 根据颜色生成带圆角图片
    ///
    /// - Parameters:
    ///     - parameter color:              待生成的图片颜色
    ///     - parameter targetSize:         生成的图片大小
    ///     - parameter cornerRadius:       圆角大小
    ///     - parameter rectCornerType:     哪些圆角，多个圆角可用[.topLeft, .topRight, bottomLeft, .bottomRight]
    ///     - parameter borderWidth:        边框宽度
    ///     - parameter borderColor:        边框颜色
    /// - Returns 带圆角图片对象
    public class func jms_rc_image(fillColor: UIColor, toSize: CGSize = .zero, cornerRadius: CGFloat = 0, rectCornerType: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(toSize, cornerRadius == 0, UIScreen.main.scale)
        
        var targetRect = CGRect.init(x: 0, y: 0, width: toSize.width, height: toSize.height)
        var finalImage: UIImage?
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(fillColor.cgColor)
        let halfBorderWidth = borderWidth / 2
        
        if cornerRadius == 0 {
            if borderWidth > 0 {
                context?.setStrokeColor(borderColor.cgColor)
                context?.setLineWidth(borderWidth)
                context?.fill(targetRect)
                
                targetRect = CGRect.init(x: halfBorderWidth, y: halfBorderWidth, width: toSize.width - borderWidth, height: toSize.height - borderWidth)
                context?.stroke(targetRect)
            }else {
                context?.fill(targetRect)
            }
        }else {
            targetRect = CGRect.init(x: halfBorderWidth, y: halfBorderWidth, width: toSize.width - borderWidth, height: toSize.height - borderWidth)
            
            let path = UIBezierPath.init(roundedRect: targetRect, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))

            context?.addPath(path.cgPath)
            
            if borderWidth > 0 {
                context?.setStrokeColor(borderColor.cgColor)
                context?.setLineWidth(borderWidth)
                context?.drawPath(using: .fillStroke)
            } else {
                context?.drawPath(using: .fill)
            }
        }
        
        finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    /// 裁剪图片为任意指定圆角(isCircle的优先级最高,其次是cornerRadius,最后才是corners.)
    ///
    /// - Parameters:
    ///     - parameter targetSize:      裁剪成指定的大小
    ///     - parameter backgroundColor: 背景颜色。比如整个背景是白色的，则应该传白色过来，与控件的背景颜色一致可解决图层混合问题
    ///     - parameter cornerRadius:    圆角大小
    ///     - parameter rectCornerType:  哪些圆角，多个圆角可用[.topLeft, .topRight, bottomLeft, .bottomRight]
    ///     - parameter borderWidth:     边框宽度，默认为0，当<=0时，不会添加边框
    ///     - parameter borderColor:     边框线的颜色，默认为UIColor.clear
    ///     - parameter borderPathWidth: 边框path, borderPathWidth > 2 * borderwidth时才会有效果
    ///     - parameter borderPathColor: 边框path颜色
    ///     - parameter isEqualScale:    是否是等比例压缩
    ///     - parameter isCircle:        是否剪裁成圆。优化级最高。若为true，生成的是圆形图片。
    /// - Returns 裁剪后的图片
    public func jms_rc_clipToSize(targetSize: CGSize, backgroundColor: UIColor? = nil, cornerRadius: CGFloat = 0, rectCornerType: UIRectCorner = .allCorners,   borderWidth: CGFloat = 0, borderColor: UIColor = .clear, borderPathWidth: CGFloat = 0, borderPathColor: UIColor = .clear, isEqualScale: Bool = false, isCircle: Bool = false) -> UIImage? {
        
        if targetSize.width <= 0 || targetSize.height <= 0 {
            return self
        }
        
        let imgSize = self.size
        var resultSize = targetSize
        
        if isEqualScale {
            let x = max(targetSize.width / imgSize.width, targetSize.height / imgSize.height)
            resultSize = CGSize.init(width: x * imgSize.width, height: x * imgSize.height)
        }
        
        var targetRect = CGRect.init(x: 0, y: 0, width: resultSize.width, height: resultSize.height)
        
        if isCircle {
            let width = min(resultSize.width, resultSize.height)
            targetRect = CGRect.init(x: 0, y: 0, width: width, height: width)
        }
        
        let halfBorderWidth     = borderWidth / 2
        let halfBorderPathWidth = borderPathWidth / 2

        if borderPathWidth > 0 && borderWidth > 0 && (isCircle || cornerRadius == 0) {
            UIGraphicsBeginImageContextWithOptions(targetRect.size,
                                                   backgroundColor != nil,
                                                   UIScreen.main.scale)
            
            let context = UIGraphicsGetCurrentContext()
            
            if backgroundColor != nil {
                backgroundColor?.setFill()
                context?.fill(targetRect)
            }
            
            var rect = targetRect
            var rectImage = rect
            
            rectImage.origin.x      += borderPathWidth
            rectImage.origin.y      += borderPathWidth
            rectImage.size.width    -= borderPathWidth * 2.0
            rectImage.size.height   -= borderPathWidth * 2.0
            
            if isCircle {
                context?.addEllipse(in: rect)
            }else {
                context?.addRect(rect)
            }
            
            context?.clip()
            self.draw(in: rectImage)
            
            // 添加内线和外线
            rectImage.origin.x      -= halfBorderWidth
            rectImage.origin.y      -= halfBorderWidth
            rectImage.size.width    += borderWidth
            rectImage.size.height   += borderWidth
            
            rect.origin.x           += halfBorderWidth
            rect.origin.y           += halfBorderWidth
            rect.size.width         -= borderWidth
            rect.size.height        -= borderWidth
            
            context?.setStrokeColor(borderColor.cgColor)
            context?.setLineWidth(borderWidth)
            
            if isCircle {
                context?.strokeEllipse(in: rectImage)
                context?.strokeEllipse(in: rect)
            }else if cornerRadius == 0 {
                context?.stroke(rectImage)
                context?.stroke(rect)
            }
            
            let centerPathWidth = borderPathWidth - borderWidth * 2.0
            
            if centerPathWidth > 0 {
                context?.setLineWidth(centerPathWidth)
                context?.setStrokeColor(borderPathColor.cgColor)
                
                rectImage.origin.x      -= halfBorderWidth + centerPathWidth / 2.0
                rectImage.origin.y      -= halfBorderWidth + centerPathWidth / 2.0
                rectImage.size.width    += borderWidth + centerPathWidth
                rectImage.size.height   += borderWidth + centerPathWidth
                
                if isCircle {
                    context?.strokeEllipse(in: rectImage)
                }else if cornerRadius == 0 {
                    context?.stroke(rectImage)
                }
            }
        }else if borderPathWidth > 0 && borderWidth > 0 && cornerRadius > 0 && !isCircle {
            UIGraphicsBeginImageContextWithOptions(targetRect.size,
                                                   backgroundColor != nil,
                                                   UIScreen.main.scale)
            
            let context = UIGraphicsGetCurrentContext()
            
            if backgroundColor != nil {
                backgroundColor?.setFill()
                context?.fill(targetRect)
            }
            
            var rect = targetRect
            var rectImage = rect
            
            rectImage.origin.x      += borderPathWidth
            rectImage.origin.y      += borderPathWidth
            rectImage.size.width    -= borderPathWidth * 2.0
            rectImage.size.height   -= borderPathWidth * 2.0

            let path1 = UIBezierPath.init(roundedRect: targetRect, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
            context?.addPath(path1.cgPath)
            context?.clip()
            self.draw(in: rectImage)
            
            // 添加内线和外线
            rectImage.origin.x      -= halfBorderWidth
            rectImage.origin.y      -= halfBorderWidth
            rectImage.size.width    += borderWidth
            rectImage.size.height   += borderWidth
            
            rect.origin.x           += halfBorderWidth
            rect.origin.y           += halfBorderWidth
            rect.size.width         -= borderWidth
            rect.size.height        -= borderWidth
            
            context?.setStrokeColor(borderColor.cgColor)
            context?.setLineWidth(borderWidth)
            
            let path2 = UIBezierPath.init(roundedRect: rectImage, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: cornerRadius - halfBorderPathWidth, height: cornerRadius - halfBorderPathWidth))
            context?.addPath(path2.cgPath)
            
            let path3 = UIBezierPath.init(roundedRect: rect, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: cornerRadius + halfBorderPathWidth, height: cornerRadius + halfBorderPathWidth))
            context?.addPath(path3.cgPath)
            
            context?.strokePath()
            
            let centerPathWidth = borderPathWidth - borderWidth * 2.0
            
            if centerPathWidth > 0 {
                context?.setLineWidth(centerPathWidth)
                context?.setStrokeColor(borderPathColor.cgColor)
                
                rectImage.origin.x      -= halfBorderWidth + centerPathWidth / 2.0
                rectImage.origin.y      -= halfBorderWidth + centerPathWidth / 2.0
                rectImage.size.width    += borderWidth + centerPathWidth
                rectImage.size.height   += borderWidth + centerPathWidth
                
                let path4 = UIBezierPath.init(roundedRect: rectImage, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
                context?.addPath(path4.cgPath)
                
                context?.strokePath()
            }
        }else if borderPathWidth <= 0 && borderWidth > 0 && (cornerRadius > 0 || isCircle) {
            let rect = targetRect
            var rectImage = rect
            
            rectImage.origin.x      += halfBorderWidth
            rectImage.origin.y      += halfBorderWidth
            rectImage.size.width    -= borderWidth
            rectImage.size.height   -= borderWidth
            
            if let tempImage = self.jms_scaleToSize(rectImage.size, backgroundColor) {
                UIGraphicsBeginImageContextWithOptions(targetRect.size,
                                                       false,
                                                       UIScreen.main.scale)
                
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(UIColor.init(patternImage: tempImage).cgColor)
                
                var path: UIBezierPath?
                if !isCircle {
                    path = UIBezierPath.init(roundedRect: rectImage, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: cornerRadius - halfBorderWidth, height: cornerRadius - halfBorderWidth))
                }else {
                    let tempWidth = rectImage.size.width / 2
                    path = UIBezierPath.init(roundedRect: rectImage, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: tempWidth, height: tempWidth))
                }
                
                context?.setStrokeColor(borderColor.cgColor)
                context?.setLineWidth(borderWidth)
                context?.addPath(path!.cgPath)
                context?.drawPath(using: .fillStroke)
            }
        }else {
            UIGraphicsBeginImageContextWithOptions(targetRect.size,
                                                   backgroundColor != nil,
                                                   UIScreen.main.scale)
            
            let context = UIGraphicsGetCurrentContext()
            
            if backgroundColor != nil {
                backgroundColor?.setFill()
                context?.fill(targetRect)
            }

            if isCircle {
                let path = UIBezierPath.init(roundedRect: targetRect, cornerRadius: targetRect.width / 2)
                context?.addPath(path.cgPath)
            }else if cornerRadius > 0 {
                let path = UIBezierPath.init(roundedRect: targetRect, byRoundingCorners: rectCornerType, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
                context?.addPath(path.cgPath)
                context?.clip()
            }
            
            self.draw(in: targetRect)
        }
    
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage
    }
    
    fileprivate func jms_scaleToSize(_ size: CGSize, _ backgroundColor: UIColor?) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        if backgroundColor != nil {
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(backgroundColor!.cgColor)
            context?.addRect(rect)
            /// 根据坐标绘制路径
            context?.drawPath(using: .fillStroke)
        }
        
        self.draw(in: rect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
}
