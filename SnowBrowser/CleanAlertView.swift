//
//  CleanAlertView.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/9.
//

import UIKit

class CleanAlertView: UIView {
    
    var confirmHandle: (()->Void)? = nil
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "clean_icon")
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Close Tabs and Clear Data"
        label.textColor = UIColor.hex("#000000", alpha: 0.87)
        return label
    }()
    
    lazy var confirm: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.hex("#50A2FF")
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.setTitle("Confirm", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 24.0
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return b
    }()
    
    lazy var cancel: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.hex("#E6E6E6")
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.setTitle("Cancel", for: .normal)
        b.setTitleColor(UIColor.hex("#000000", alpha: 0.87), for: .normal)
        b.layer.cornerRadius = 24.0
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor.hex("#000000", alpha: 0.87)
        addSubview(contentView)
        contentView.addSubview(icon)
        contentView.addSubview(title)
        contentView.addSubview(confirm)
        contentView.addSubview(cancel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: 20, y: (kHeight - 237) / 2.0, width: kWidth - 40, height: 237)
        icon.frame = CGRect(x: (contentView.frame.width - 80) / 2.0, y: 20, width: 80, height: 80)
        title.frame = CGRect(x: 0, y: icon.frame.maxY + 16, width: contentView.frame.width, height: 20)
        
        let width = (contentView.frame.width  - 32 - 8) / 2.0
        confirm.frame = CGRect(x: 16, y: title.frame.maxY + 20, width: width, height: 48)
        cancel.frame = CGRect(x: confirm.frame.maxX + 8, y: confirm.frame.minY, width: width, height: 48)
    }

    @objc func confirmAction() {
        self.removeFromSuperview()
        confirmHandle?()
    }
    
    @objc func cancelAction() {
        self.removeFromSuperview()
    }
}
