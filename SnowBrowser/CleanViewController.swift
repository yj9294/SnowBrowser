//
//  CleanViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/9.
//

import UIKit

class CleanViewController: BaseViewController {
    
    var adTimer: Timer?
    var afterTimer: Timer?
    
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
        
        if adTimer != nil {
            adTimer?.invalidate()
            adTimer = nil
        }
        
        if afterTimer != nil {
            afterTimer?.invalidate()
            afterTimer = nil
        }
        
        var progress = 0.0
        var duration = 2 / 0.6
        var isNeedShowAd = false
        
        adTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] t in
            if progress >= 1.0 {
                t.invalidate()
                GADHelper.share.show(.interstitial, from: self) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.stopAnimation()
                    }
                }
            } else {
                progress += 1.0 / (duration * 100)
            }
            
            if isNeedShowAd, GADHelper.share.isLoaded(.interstitial) {
                duration = 0.1
            }
        }
        
        afterTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { t in
            t.invalidate()
            isNeedShowAd = true
            duration = 16.0
        })
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if GADHelper.share.isADLimited {
                t.invalidate()
                self.stopAnimation()
            }
        }
        
        GADHelper.share.load(.interstitial)
        GADHelper.share.load(.native)
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
        adTimer?.invalidate()
        adTimer = nil
        
        afterTimer?.invalidate()
        afterTimer = nil
        
        dismissHandle?()
        dismiss(animated: true)
    }
}
