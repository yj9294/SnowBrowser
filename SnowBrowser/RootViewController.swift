//
//  RootViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/5.
//

import UIKit
import AppTrackingTransparency

class RootViewController: BaseViewController {
    
    enum State {
        case launching, launced
    }
    
    lazy var launchingVC: LaunchingViewController = {
        LaunchingViewController()
    }()
    
    lazy var launchedNaviVC: UINavigationController = {
        UINavigationController(rootViewController: launchedVC)
    }()

    lazy var launchedVC: LaunchedViewController = {
       LaunchedViewController()
    }()
    
    var state: State = .launching
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(launchedNaviVC)
        addChild(launchingVC)
        
        FirebaseHelper.log(property: .local)
        FirebaseHelper.log(event: .open)
        FirebaseHelper.log(event: .openCold)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewLayoutMarginsDidChange()
        launchingVC.view.frame = view.bounds
        launchedNaviVC.view.frame = view.bounds
    }
    
}

extension RootViewController {
    override func setupUI() {
        super.setupUI()
        view.addSubview(launchedNaviVC.view)
        view.addSubview(launchingVC.view)
    }
    
    func launched() {
        state = .launced
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization { _ in
            }
        }
        view.bringSubviewToFront(launchedNaviVC.view)
        
        launchedVC.willAppear = true
        GADHelper.share.load(.interstitial)
        GADHelper.share.load(.native)
        
        FirebaseHelper.log(event: .homeShow)
    }
    
    func launching() {
        state = .launching
        launchingVC.launching()
        view.bringSubviewToFront(launchingVC.view)
    }
}
