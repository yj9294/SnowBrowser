//
//  PrivacyViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/9.
//

import UIKit

class PrivacyViewController: BaseViewController {
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Policy"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        textView.text = """
This page is used to inform visitors of our policies regarding the collection, use and disclosure of personal information.
Downloading/our application implies acceptance of the terms of this privacy policy. If you do not agree to the installation of this privacy policy, please do not use our application.
We will not use your information or share your information with others except as described in this Privacy Policy.
Information collection
Usage Data: including, but not limited to, the type of mobile device, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you are using, device identifiers and other diagnostic data.
Information sent when accessing the Services: including, but not limited to, the email address you use to contact us, information that can be used to contact or identify you personally
Information usage
For understanding and analyzing how our applications are being used.
To improve our products and services.
To respond to you when you get in touch with us.
Our applications do contain advertisements and we may use the information we collect for advertising and marketing purposes.
Information sharing
We do not disclose your information to third parties outside of the scope of this Privacy Policy. We do not rent or sell your information. We do have third party service providers and partners who may collect information about you. We are not responsible for the actions of these third parties. Please familiarize yourself with their privacy policies if you so desire.
Links to the privacy policies of third-party service providers used by the app
google play services：https://policies.google.com/privacy
AdMob：https://support.google.com/admob
Google Analytics for Firebase：https://firebase.google.com/policies/analytics
Firebase Crashlytics：https://firebase.google.com/support/privacy/
Facebook：https://www.facebook.com/about/privacy/update/printable
Children's Privacy
We only serve the 17+ age group. If a group of people over 17 years old uses our services and provides information, please ask the guardian to contact us even though, we will promptly take necessary measures including removing the relevant information

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


extension PrivacyViewController {
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = UIColor.hex("#F5F7FA")
        view.addSubview(textView)
    }
    
    @objc func back() {
        navigationController?.popToRootViewController(animated: true)
    }
}
