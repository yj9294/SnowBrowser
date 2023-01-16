//
//  SettingView.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/6.
//

import UIKit
import MobileCoreServices

class SettingView: UIView {
    
    var newHandle:(()->Void)? = nil
    
    var privacyHandle: (()->Void)? = nil
    
    var termsHandle:(()->Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bg: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.hex("#000000", alpha: 0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1.0
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.layer.masksToBounds  = true
        return view
    }()
    
    lazy var new: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "setting_new"), for: .normal)
        b.addTarget(self, action: #selector(newAction), for: .touchUpInside)
        b.setTitle("New", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        b.titleEdgeInsets = UIEdgeInsets(top: 50, left: -36, bottom: 0, right: 0)
        return b
    }()
    
    lazy var share: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "setting_share"), for: .normal)
        b.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        b.setTitle("Share", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        b.titleEdgeInsets = UIEdgeInsets(top: 50, left: -36, bottom: 0, right: 0)
        return b
    }()
    
    lazy var copy: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "setting_copy"), for: .normal)
        b.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        b.setTitle("Copy", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        b.titleEdgeInsets = UIEdgeInsets(top: 50, left: -36, bottom: 0, right: 0)
        return b
    }()
    
    lazy var rate: SettingItem = {
        let item = SettingItem(frame: .zero)
        item.title = "Rate Us"
        item.addTarget(self, action: #selector(rateAction), for: .touchUpInside)
        return item
    }()
    
    lazy var privacy: SettingItem = {
        let item = SettingItem(frame: .zero)
        item.title = "Privacy Policy"
        item.addTarget(self, action: #selector(privacyAction), for: .touchUpInside)
        return item
    }()
    
    lazy var tems: SettingItem = {
        let item = SettingItem(frame: .zero)
        item.title = "Terms Of Use"
        item.addTarget(self, action: #selector(termsAction), for: .touchUpInside)
        return item
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bg.frame = self.bounds
        shadowView.frame = CGRect(x: 0, y: kHeight - 280 - safeAreaInsets.bottom, width: kWidth, height: 280 + safeAreaInsets.bottom)
        contentView.frame = CGRect(x: 0, y: kHeight - 280 - safeAreaInsets.bottom, width: kWidth, height: 280 + safeAreaInsets.bottom)
        
        let pandding = (kWidth - 40 * 3) / 4.0
        new.frame = CGRect(x: pandding, y: 20, width: 40, height: 72)
        share.frame = CGRect(x: new.frame.maxX + pandding, y: 20, width: 40, height: 72)
        copy.frame = CGRect(x: share.frame.maxX + pandding, y: 20, width: 40, height: 72)

        rate.frame = CGRect(x: 16, y: new.frame.maxY + 20, width: kWidth - 16*2, height: 44)
        privacy.frame = CGRect(x: 16, y: rate.frame.maxY + 8, width: kWidth - 16*2, height: 44)
        tems.frame = CGRect(x: 16, y: privacy.frame.maxY + 8, width: kWidth - 16*2, height: 44)

    }
}

extension SettingView {
    func setupUI() {
        self.backgroundColor = .clear
        addSubview(bg)
        addSubview(shadowView)
        addSubview(contentView)
        contentView.addSubview(new)
        contentView.addSubview(share)
        contentView.addSubview(copy)
        
        contentView.addSubview(rate)
        contentView.addSubview(privacy)
        contentView.addSubview(tems)
    }
}

extension SettingView {
    @objc func newAction() {
        dismiss()
        BrowserHelper.shared.add()
        newHandle?()
        FirebaseHelper.log(event: .tabNew, params: ["lig": "setting"])
    }
    
    @objc func shareAction() {
        dismiss()
        var url = "https://itunes.apple.com/cn/app/id"
        if !BrowserHelper.shared.webItem.isNavigation, let text = BrowserHelper.shared.webItem.webView.url?.absoluteString {
            url = text
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        rootVC?.present(vc, animated: true)
        FirebaseHelper.log(event: .shareClick)
    }
    
    @objc func copyAction() {
        dismiss()
        if !BrowserHelper.shared.webItem.isNavigation, let text = BrowserHelper.shared.webItem.webView.url?.absoluteString {
            UIPasteboard.general.setValue(text, forPasteboardType: kUTTypePlainText as String)
            rootVC?.alert("Copy successfully.")
        } else {
            UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
            rootVC?.alert("Copy successfully.")
        }
        FirebaseHelper.log(event: .copyClick)
    }
    
    @objc func rateAction() {
        dismiss()
        let url = URL(string: "https://itunes.apple.com/cn/app/id")
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func privacyAction() {
        dismiss()
        privacyHandle?()
    }
    
    @objc func termsAction() {
        dismiss()
        termsHandle?()
    }
    
    @objc func dismiss() {
        removeFromSuperview()
    }
}

class SettingItem: UIControl {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#333333")
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var arrow: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "setting_arrow")
        return image
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 16, y: (self.frame.height - 20) / 2.0, width: 200, height: 20)
        arrow.frame = CGRect(x: frame.width - 16 - 16, y: 14, width: 16, height: 16)
        button.frame = self.bounds
    }
    
    func setupUI(){
        self.backgroundColor = UIColor.hex("#6399ED", alpha: 0.1)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(titleLabel)
        addSubview(arrow)
        addSubview(button)
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
}
