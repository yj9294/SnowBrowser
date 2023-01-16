//
//  BaseViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/5.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        debugPrint("-----------------\(self) deinit!-----------------")
    }

}

extension BaseViewController {
    @objc func setupUI() {
        view.backgroundColor = .themeColor()
    }
}
