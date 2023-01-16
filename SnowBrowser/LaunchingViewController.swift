//
//  LaunchingViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/5.
//

import UIKit

class LaunchingViewController: BaseViewController {
    var progressTimer: Timer? = nil
    var progress: Double = 0.0 {
        didSet {
            progressContent.frame = CGRectMake(progressBg.frame.minX, progressBg.frame.minY, (kWidth - 40*2) * progress, 4)
            view.layoutIfNeeded()
        }
    }
    
    lazy var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "launch_icon"))
        return icon
    }()
    
    lazy var progressBg: UIView = {
        let progressBg = UIView()
        progressBg.backgroundColor = .white
        progressBg.layer.cornerRadius = 2
        progressBg.layer.masksToBounds = true
        return progressBg
    }()
    
    lazy var progressContent: UIView = {
        let progressContent = UIView()
        progressContent.backgroundColor = .themeColor()
        progressContent.layer.cornerRadius = 2
        progressContent.layer.masksToBounds = true
        return progressContent
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        icon.frame = CGRect(x: (kWidth - 90) / 2.0 , y: kHeight -  75 - view.safeAreaInsets.bottom - 105, width: 90, height: 105)
        progressBg.frame = CGRect(x: 40, y: icon.frame.maxY + 40, width: kWidth - 40*2, height: 4)
    }

}

extension LaunchingViewController {
    override func setupUI() {
        super.setupUI()
        
        let bg = UIImageView(image: UIImage(named: "launch_bg"))
        bg.contentMode = .scaleAspectFill
        bg.frame = view.bounds
        view.addSubview(bg)
        
        view.addSubview(icon)

        view.addSubview(progressBg)
        
        view.addSubview(progressContent)
    }
    
    func launching() {
        let duration = 2.5
        self.progress = 0.0
        if progressTimer != nil {
            progressTimer?.invalidate()
            progressTimer = nil
        }
        
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] t in
            guard let self  = self else { return }
            self.progress += 1.0 / (duration * 100)
            if self.progress >= 1.0 {
                t.invalidate()
                rootVC?.launched()
            }
        })
    }
}
