//
//  ViewController.swift
//  JMSImageCliped
//
//  Created by James.xiao on 2017/7/26.
//  Copyright © 2017年 James.xiao. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ViewController: UIViewController {

    private lazy var cView: UIView = {
        let tempView = UIView.init(frame: CGRect.init(x: 0, y: 50, width: 80, height: 30))
        
        return tempView
    }()
    
    private lazy var snpkitLabel: UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.textColor = UIColor.black
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        
        return tempLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let tempImageView = UIImageView.init()
        tempImageView.contentMode = .scaleAspectFill
        
        return tempImageView
    }()
    
    private lazy var btn: UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("按钮", for: .normal)
        tempBtn.setTitleColor(UIColor.black, for: .normal)
        
        return tempBtn
    }()
    
    private lazy var networkImageView: JMSClipedImageView = {
        let tempImageView = JMSClipedImageView.init(cornerRadius: 40, backgroundColor: nil, borderWidth: 1, borderColor: .blue, rectCornerType: .allCorners)
        //        tempImageView.contentMode = .scaleAspectFill
        
        return tempImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI
    private func setupViews() {
        self.view.addSubview(self.cView)
        
        var tempCenter = self.cView.center
        tempCenter.x = self.view.center.x
        self.cView.center = tempCenter
        
        self.cView.jms_rc_setImage(fillElement: UIColor.white, cornerRadius: 15, rectCornerType: [.topLeft, .bottomRight], borderWidth: 1, borderColor: .green)
        
        /// Snapkit使用
        self.view.addSubview(self.snpkitLabel)
        
        self.snpkitLabel.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        
        self.snpkitLabel.jms_rc_setImage(fillElement: UIColor.groupTableViewBackground, cornerRadius: 15, borderWidth: 1, borderColor: .black)
        self.snpkitLabel.textColor = UIColor.blue
        self.snpkitLabel.text = "Label圆角"
        
        /// UIImageView
        self.view.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(150)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        
        self.imageView.jms_rc_setImage(fillElement: UIColor.yellow, cornerRadius: 15, borderWidth: 1, borderColor: .green)
        
        self.view.addSubview(btn)
        
        self.btn.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        
        self.btn.setTitle("测试", for: .normal)
        self.btn.jms_rc_setBtnImage(fillStateElements:  [(UIControlState.normal, UIColor.red, true), (UIControlState.highlighted, UIColor.green, true)], cornerRadius: 15)
        
        /// 网络图片
        self.view.addSubview(self.networkImageView)
        
        self.networkImageView.snp.makeConstraints { (make) in
            make.top.equalTo(250)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }

        self.networkImageView.kf.setImage(with: URL.init(string: "http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=6922953cb6315c60579863ace5d8a166/35a85edf8db1cb13c088053ad754564e92584b31.jpg"), placeholder: UIImage.init(named: "dog"))
    }

}

