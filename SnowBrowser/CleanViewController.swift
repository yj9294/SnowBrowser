//
//  CleanViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/9.
//

import UIKit

class CleanViewController: BaseViewController {
    
    var timer: Timer?
    
    var dismissHandle: (()->Void)? = nil
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "clean_animation")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cleaning…"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(stopAnimation), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        starAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        icon.frame = CGRect(x: 50 , y: view.safeAreaInsets.top + 160, width: 260, height: 260)
        titleLabel.frame = CGRect(x: (kWidth - 80) / 2.0, y: icon.frame.maxY + 16, width: 80, height: 20)
    }

}

extension CleanViewController {
    override func setupUI() {
        super.setupUI()
        view.addSubview(icon)
        view.addSubview(titleLabel)
    }
    
    func starAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 5
        rotateAnimation.repeatCount = .infinity
        icon.layer.add(rotateAnimation, forKey: "animation")
    }
    
    @objc func stopAnimation() {
        icon.layer.removeAllAnimations()
        timer?.invalidate()
        timer = nil
        dismissHandle?()
        dismiss(animated: true)
    }
}
