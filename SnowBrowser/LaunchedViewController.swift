//
//  LaunchedViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/5.
//

import UIKit
import WebKit
import AppTrackingTransparency

class LaunchedViewController: BaseViewController {
    
    enum Item: String, CaseIterable {
        case facebook, google, instagram, youtube, amazon, gmail, yahoo, twitter
        var url: String {
            return "https://\(self).com"
        }
        var icon: String {
            return "home_\(self)"
        }
    }
    
    var willAppear: Bool = false
    
    var startDate: Date? = nil
    
    var webView: WKWebView {
        BrowserHelper.shared.webItem.webView
    }
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let txf = UITextField()
        txf.delegate = self
        txf.placeholder = "Seaech or enter an address"
        txf.textColor = UIColor.hex("#000000", alpha: 0.87)
        txf.font = UIFont.systemFont(ofSize: 14.0)
        return txf
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_search"), for: .normal)
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_close"), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = UIColor.hex("#FFFFFF", alpha: 0.5)
        progressView.tintColor = .white
        progressView.isHidden = true
        return progressView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var contentIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "home_icon"))
        return view
    }()
    
    lazy var contentCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .white
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.register(LaunchedCell.classForCoder(), forCellWithReuseIdentifier: "LaunchedCell")
        return collection
    }()
    
    lazy var contentWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var adView: GADNativeView = {
        let view = GADNativeView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.hex("#000000", alpha: 0.3).cgColor
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1.0
        view.layer.cornerRadius = 20
//        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.hex("#000000", alpha: 0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1.0
        return view
    }()
    
    lazy var lastButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "home_last"), for: .normal)
        b.addTarget(self, action: #selector(lastAction), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    
    lazy var nextButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "home_next"), for: .normal)
        b.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    
    lazy var cleanButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "home_clean"), for: .normal)
        b.addTarget(self, action: #selector(cleanAction), for: .touchUpInside)
        return b
    }()
    
    lazy var tabButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "home_tab"), for: .normal)
        b.addTarget(self, action: #selector(tabAction), for: .touchUpInside)
        return b
    }()
    
    lazy var tabNum: UILabel = {
        let b = UILabel()
        b.text = "1"
        b.textColor = UIColor.hex("#000000")
        b.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return b
    }()
    
    lazy var settingButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "home_setting"), for: .normal)
        b.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            if let ad = noti.object as? NativeADModel, self?.willAppear == true {
                if Date().timeIntervalSince1970 - (GADHelper.share.homeNativeAdImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADHelper.share.homeNativeAdImpressionDate = Date()
                } else {
                    NSLog("[ad] 10s home 原生广告刷新或数据填充间隔.")
                }
            } else {
                self?.adView.nativeAd = nil
            }
        }
        ATTrackingManager.requestTrackingAuthorization { _ in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        webviewLayout()
        if rootVC?.state == .launced, willAppear == false {
            willAppear = true
            GADHelper.share.load(.interstitial)
            GADHelper.share.load(.native)
            
            FirebaseHelper.log(event: .homeShow)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        willAppear = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchView.frame = CGRect(x: 16, y: 20 + view.safeAreaInsets.top, width: kWidth - 16 * 2, height: 56 * kRadioH)
        searchTextField.frame =  CGRect(x: 16, y: 0, width: searchView.frame.width - 24 - 16*2 - 10, height: 56 * kRadioH)
        searchButton.frame = CGRect(x: searchTextField.frame.maxX + 10 , y: 16, width: 24, height: 24)
        closeButton.frame = searchButton.frame
        
        progressView.frame = CGRect(x: 0, y: searchView.frame.maxY + 2, width: kWidth, height: 4)
        
        contentView.frame = CGRect(x: 0, y: progressView.frame.maxY + 2, width: kWidth, height: kHeight - progressView.frame.maxY - 5 - 66 - view.safeAreaInsets.bottom)
        contentIcon.frame = CGRect(x: (kWidth - 160 * kRadioH) / 2.0, y: 20 * kRadioH, width: 160 * kRadioH, height: 160 * kRadioH)
        contentWhiteView.frame = CGRect(x: 0, y: contentIcon.frame.maxY + 20 * kRadioH, width: kWidth, height: contentView.frame.height - (160 - 20*2) * kRadioH )
        contentCollection.frame = CGRect(x: 0, y: 16, width: contentWhiteView.frame.width, height: (kWidth / 4.0 - 10) * 2 + 15)
        adView.frame = CGRect(x: 16, y: contentCollection.frame.maxY + 18, width: view.frame.width  - 32, height: 120 * kRadioH)
        
        bottomView.frame = CGRect(x: 0, y: contentView.frame.maxY, width: kWidth, height: 66 + view.safeAreaInsets.bottom)
        let padding = (kWidth - 18 * 2 - 32 * 5 ) / 4.0
        lastButton.frame = CGRect(x: 18, y: 17, width: 32, height: 32)
        nextButton.frame = CGRect(x: lastButton.frame.maxX + padding, y: 17, width: 32, height: 32)
        cleanButton.frame = CGRect(x: nextButton.frame.maxX + padding, y: 17, width: 32, height: 32)
        tabButton.frame = CGRect(x: cleanButton.frame.maxX + padding, y: 17, width: 32, height: 32)
        settingButton.frame = CGRect(x: tabButton.frame.maxX + padding, y: 17, width: 32, height: 32)
        
        tabNum.frame = CGRect(x: 17, y: 13, width: 15, height: 15)
        
        webView.frame = contentView.frame
    }
    
    func webviewLayout() {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        
        progressView.isHidden = !webView.isLoading
        searchTextField.text = webView.url?.absoluteString ?? ""
        searchButton.isHidden = webView.isLoading
        closeButton.isHidden = !webView.isLoading
        
        tabNum.text = "\(BrowserHelper.shared.webItems.count)"
         
        view.subviews.forEach {
            if $0 is WKWebView {
                $0.removeFromSuperview()
            }
        }
        if !BrowserHelper.shared.webItem.isNavigation, webView.url != nil {
            view.insertSubview(webView, aboveSubview: contentView)
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // url重定向
        if keyPath == #keyPath(WKWebView.url) {
            searchTextField.text = webView.url?.absoluteString
        }
        
        // 进度
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let progress: Float = Float(webView.estimatedProgress)
            debugPrint(progress)
            DispatchQueue.main.async {
                self.progressView.progress = progress
            }
            
            if progress == 0.1 {
                startDate = Date()
                searchButton.isHidden = true
                closeButton.isHidden = false
                
                FirebaseHelper.log(event: .webStart)
            }
            
            // 加载完成
            if progress == 1.0 {
                progressView.isHidden = true
                progressView.progress = 0.0
                searchButton.isSelected = false
                let time = Date().timeIntervalSince1970 - startDate!.timeIntervalSince1970
                FirebaseHelper.log(event: .webSuccess, params: ["lig": "\(ceil(time))"])

                
                if webView.url == nil {
                    if closeButton.isHidden == false {
                        self.alert("Load Failed.")
                    } else {
                        self.alert("Canceled.")
                    }
                    webView.removeFromSuperview()
                }
                
                searchButton.isHidden = false
                closeButton.isHidden = true
            } else {
                progressView.isHidden = false
            }
        }
    }

}

extension LaunchedViewController {
    override func setupUI() {
        super.setupUI()
        view.addSubview(searchView)
        searchView.addSubview(searchTextField)
        searchView.addSubview(searchButton)
        searchView.addSubview(closeButton)
        
        view.addSubview(progressView)
        
        view.addSubview(contentView)
        contentView.addSubview(contentIcon)
        contentView.addSubview(contentWhiteView)
        contentWhiteView.addSubview(contentCollection)
        contentWhiteView.addSubview(adView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(lastButton)
        bottomView.addSubview(nextButton)
        bottomView.addSubview(cleanButton)
        bottomView.addSubview(tabButton)
        tabButton.addSubview(tabNum)
        bottomView.addSubview(settingButton)
    }
    
    @objc func searchAction() {
        self.view.endEditing(true)
        guard let text = searchTextField.text else {
            alert("Please enter your search content.")
            return
        }
        if text.count == 0 {
            alert("Please enter your search content.")
            return
        }
        BrowserHelper.shared.loadUrl(text, from: self)
        
        FirebaseHelper.log(event: .navigaSearch, params: ["lig": text])
    }
    
    @objc func closeAction() {
        self.view.endEditing(true)
        BrowserHelper.shared.stopLoad()
        closeButton.isHidden = true
        searchButton.isHidden = false
    }
    
    @objc func lastAction() {
        self.view.endEditing(true)
        BrowserHelper.shared.goBack()
    }
    
    @objc func nextAction() {
        self.view.endEditing(true)
        BrowserHelper.shared.goForword()
    }
    
    @objc func cleanAction() {
        self.view.endEditing(true)
        let view = CleanAlertView()
        view.frame = self.view.bounds
        self.view.addSubview(view)
        view.confirmHandle = {
            self.willAppear = false
            GADHelper.share.close(.native)
            
            let vc = CleanViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.dismissHandle = {
                FirebaseHelper.log(event: .cleanSuccess)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if rootVC?.state == .launced {
                        self.alert("Cleaned successfully.")
                        FirebaseHelper.log(event: .cleanAlert)
                    }
                }
                BrowserHelper.shared.clean(from: self)
            }
            self.present(vc, animated: true)
        }
        
        FirebaseHelper.log(event: .cleanClick)
    }
    
    @objc func tabAction() {
        willAppear = false
        GADHelper.share.close(.native)
        
        self.view.endEditing(true)
        let vc = TabViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func settingAction() {
        self.view.endEditing(true)
        let view = SettingView()
        view.frame = self.view.bounds
        self.view.addSubview(view)
        
        view.newHandle = {
            self.webviewLayout()
        }
        
        view.privacyHandle = {
            self.privacyAction()
        }
        
        view.termsHandle = {
            self.termsAction()
        }
    }
    
    func privacyAction() {
        let vc = PrivacyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func termsAction() {
        let vc = TermsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LaunchedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Item.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchedCell", for: indexPath)
        if let cell = cell as? LaunchedCell {
            cell.item = Item.allCases[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kWidth / 4.0 - 10, height: kWidth / 4.0 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
}

extension LaunchedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        return true
    }
}

extension LaunchedViewController: WKUIDelegate, WKNavigationDelegate {
    /// 跳转链接前是否允许请求url
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    /// 响应后是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward

        webView.load(navigationAction.request)
        
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let text = Item.allCases[indexPath.row].url
        searchTextField.text = text

        guard let text = searchTextField.text else {
            alert("Please enter your search content.")
            return
        }
        if text.count == 0 {
            alert("Please enter your search content.")
            return
        }
        BrowserHelper.shared.loadUrl(text, from: self)
        
        FirebaseHelper.log(event: .navigaClick, params: ["lig": text])
    }
}

class LaunchedCell: UICollectionViewCell {
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        return icon
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
        icon.frame = self.bounds
    }
    
    func setupUI() {
        addSubview(icon)
    }
    
    var item: LaunchedViewController.Item = .facebook {
        didSet {
            icon.image = UIImage(named: item.icon)
        }
    }
}
