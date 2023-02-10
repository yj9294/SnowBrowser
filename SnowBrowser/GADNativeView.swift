//
//  GADNativeView.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/16.
//

import UIKit
import GoogleMobileAds

class GADNativeView: GADNativeAdView {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var placeholder: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ad_placeholder"))
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#333333")
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#737373")
        label.font = UIFont.systemFont(ofSize: 11.0)
        return label
    }()
    lazy var install: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.hex("#50A2FF")
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.isHidden = true
        return button
    }()
    lazy var adTag: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.hex("#FEB800")
        label.text = "AD"
        label.font = UIFont.systemFont(ofSize: 9.0)
        label.textColor = UIColor.white
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholder.frame = self.bounds
        
        icon.frame = CGRect(x: 16, y: 16 * kRadioH, width: 44, height: 44 * kRadioH)
        title.frame = CGRect(x: icon.frame.maxX + 12, y: 16 * kRadioH, width: frame.width - 25 - 24 - (icon.frame.maxX + 12), height: 14 * kRadioH)
        subTitle.frame = CGRect(x: title.frame.minX, y: title.frame.maxY + 8 * kRadioH, width: frame.width - title.frame.minX - 16, height: 14 * kRadioH)
        adTag.frame = CGRect(x: title.frame.maxX + 8, y: 16 * kRadioH, width: 25, height: 14 * kRadioH)
        install.frame = CGRect(x: 16, y: icon.frame.maxY + 8 * kRadioH, width: frame.width - 32, height: 36 * kRadioH)
    }
    
    func setupUI() {
        addSubview(placeholder)
        addSubview(icon)
        addSubview(title)
        addSubview(subTitle)
        addSubview(adTag)
        addSubview(install)
    }

    override var nativeAd: GADNativeAd? {
        didSet {
            if let nativeAd = nativeAd {
                
                self.icon.isHidden = false
                self.title.isHidden = false
                self.subTitle.isHidden = false
                self.install.isHidden = false
                self.adTag.isHidden = false
                self.placeholder.isHidden = true
                
                if let image = nativeAd.images?.first?.image {
                    self.icon.image =  image
                }
                self.title.text = nativeAd.headline
                self.subTitle.text = nativeAd.body
                self.install.setTitle(nativeAd.callToAction, for: .normal)
                self.install.setTitleColor(.white, for: .normal)
            } else {
                self.icon.isHidden = true
                self.title.isHidden = true
                self.subTitle.isHidden = true
                self.install.isHidden = true
                self.adTag.isHidden = true
                self.placeholder.isHidden = false
            }
            
            callToActionView = install
            headlineView = title
            bodyView = subTitle
            advertiserView = adTag
            iconView = icon
        }
    }
    
}
