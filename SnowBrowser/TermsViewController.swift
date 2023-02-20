//
//  TermsViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/9.
//

import UIKit

class TermsViewController: BaseViewController {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = .clear
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Terms of Use"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        textView.text = """
Use of the application
1. You accept that we will use your information for the purposes required by law and regulation.
2. You accept that you may not use our applications for unlawful purposes.
3. You accept that we may stop providing our products and services at any time without prior notice to you.


Update
We may update this page from time to time. We recommend that you check this page regularly for updates.
Contact us
If you have any questions about this Privacy Policy, please contact us
timelock0987@outlook.com

"""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = CGRect(x: 16, y: 16, width: kWidth - 32, height: kHeight - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 32)
    }
}


extension TermsViewController {
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = UIColor.hex("#F5F7FA")
        view.addSubview(textView)
    }
    
    @objc func back() {
        navigationController?.popToRootViewController(animated: true)
    }
}
