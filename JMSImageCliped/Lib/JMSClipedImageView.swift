//
//  UIImageView+rcExtension.swift
//  JMSRounedCorners
//  加载网络图片的UIImageView圆角处理
//  Created by James.xiao on 2017/7/26.
//  Copyright © 2017年 James. All rights reserved.
//

import UIKit

private let jms_def_Image = "image"
private let kProcessedImage: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "jms_rc_processedImage".hashValue)

public class JMSClipedImageView: UIImageView {

    private(set) var hadAddObserver: Bool   = false

    public var jms_cornerRadius: CGFloat        = 0
    public var jms_rectCornerType: UIRectCorner = .allCorners
    public var jms_borderWidth: CGFloat         = 0
    public var jms_borderColor: UIColor         = .clear

    /// 生成指定图片来填充控件
    ///
    /// - Parameters:
    ///     - parameter frame:              控件大小
    ///     - parameter cornerRadius:       圆角大小
    ///     - parameter backgroundColor:	背景色
    ///     - parameter borderWidth:        边框宽度
    ///     - parameter borderColor:        边框颜色
    ///     - parameter rectCornerType:     填充角
    /// - Returns Void
    public init(frame: CGRect = .zero, cornerRadius: CGFloat = 0, backgroundColor: UIColor? = nil, borderWidth: CGFloat = 0, borderColor: UIColor = .clear, rectCornerType: UIRectCorner = .allCorners) {
        super.init(frame: frame)
        
        self.backgroundColor        = backgroundColor
        self.jms_cornerRadius       = cornerRadius
        self.jms_borderWidth        = borderWidth
        self.jms_borderColor        = borderColor
        self.jms_rectCornerType     = rectCornerType

        if !self.hadAddObserver {
            /// kvo
            self.addObserver(self, forKeyPath: jms_def_Image, options: .new, context: nil)
            self.hadAddObserver = true
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: jms_def_Image)
    }
    
    // MARK: - KVO
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == jms_def_Image {
            if let tempImage = change?[.newKey] as? UIImage {
                if (objc_getAssociatedObject(tempImage, kProcessedImage) as? String ?? "0") != "1" {
                    self.layoutIfNeeded()

                    let newImage = tempImage.jms_rc_clipToSize(targetSize: self.bounds.size, backgroundColor: nil, cornerRadius: self.jms_cornerRadius, rectCornerType: self.jms_rectCornerType, borderWidth: self.jms_borderWidth, borderColor: self.jms_borderColor, isEqualScale: false, isCircle: false)
                    
                    if newImage != nil {
                        objc_setAssociatedObject(newImage, kProcessedImage, "1", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    }
                    
                    self.image = newImage
                }
            }
        }
    }
    
}
