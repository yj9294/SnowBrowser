//
//  TabViewController.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/6.
//

import UIKit

class TabViewController: BaseViewController {
    
    var willAppear = false
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.register(TabItemCell.classForCoder(), forCellWithReuseIdentifier: "TabItemCell")
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
    
    lazy var bottomAddButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "tab_new"), for: .normal)
        b.addTarget(self, action: #selector(newAction), for: .touchUpInside)
        return b
    }()
    
    lazy var backButton: UIButton = {
        let  b = UIButton()
        b.setTitle("Back", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            if let ad = noti.object as? NativeADModel, self?.willAppear == true {
                if Date().timeIntervalSince1970 - (GADHelper.share.tabNativeAdImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADHelper.share.tabNativeAdImpressionDate = Date()
                } else {
                    NSLog("[ad] 10s tab 原生广告刷新或数据填充间隔.")
                }
            } else {
                self?.adView.nativeAd = nil
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collection.frame = CGRect(x: 16, y: view.safeAreaInsets.top + 20, width: kWidth - 16 * 2, height: kHeight - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 20 - 66 - 20 - 120 * kRadioH)
        adView.frame = CGRect(x: 16, y: collection.frame.maxY + 20, width: view.frame.width - 32, height: 120 * kRadioH)
        
        
        bottomView.frame = CGRect(x: 0, y: adView.frame.maxY + 20, width: kWidth, height: 66 + view.safeAreaInsets.bottom)
        
        bottomAddButton.frame = CGRect(x: (kWidth - 36) / 2.0, y: 15, width: 36, height: 36)
        backButton.frame = CGRect(x: kWidth - 16 - 36, y: 23, width: 36, height: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        willAppear = true
        GADHelper.share.load(.native)
        GADHelper.share.load(.interstitial)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        willAppear = false
        
        GADHelper.share.close(.native)
    }
}


extension TabViewController {
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = UIColor.hex("#F5F7FA")
        
        view.addSubview(collection)
        view.addSubview(adView)
        view.addSubview(bottomView)
        bottomView.addSubview(bottomAddButton)
        bottomView.addSubview(backButton)
        
        FirebaseHelper.log(event: .tabShow)
    }
    
    @objc func newAction() {
        BrowserHelper.shared.add()
        dismiss(animated: true)
        FirebaseHelper.log(event: .tabNew, params: ["lig": "tab"])
    }
    
    @objc func backAction() {
        dismiss(animated: true)
    }
}

extension TabViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        BrowserHelper.shared.webItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabItemCell", for: indexPath)
        if let cell = cell as? TabItemCell {
            cell.item = BrowserHelper.shared.webItems[indexPath.row]
            cell.closeHandle = { [weak self] in
                BrowserHelper.shared.removeItem(cell.item!)
                self?.collection.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (kWidth - 16*2 - 12 - 10) / 2.0
        return CGSize(width: width, height: width * 200 / 158.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BrowserHelper.shared.webItems[indexPath.row]
        BrowserHelper.shared.select(item)
        self.backAction()
    }
}

class TabItemCell: UICollectionViewCell {
    
    var closeHandle: (()->Void)? = nil
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("#737373")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tab_icon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var close: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "tab_close"), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
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
        title.frame = CGRectMake(8, 8, self.frame.width - 16 - 16 - 10, 22)
        icon.bounds = CGRect(x: (frame.width - 80) / 2.0, y: (frame.width - 80) / 2.0 + 20, width: 80, height: 80)
        close.frame = CGRect(x: title.frame.maxX + 10, y: 8, width: 16, height: 16)
    }
    
    func setupUI() {
        backgroundColor = .white
        addSubview(icon)
        addSubview(close)
        addSubview(title)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
    var item: BrowserItem? {
        didSet {
            title.text = item?.webView.url?.absoluteString
            
            if item?.isSelect == true {
                self.layer.borderColor = UIColor.themeColor().cgColor
                self.layer.borderWidth = 2
            } else {
                self.layer.borderWidth = 0
            }
            
            if BrowserHelper.shared.webItems.count == 1 {
                close.isHidden = true
            } else {
                close.isHidden = false
            }
        }
    }
    
    @objc func closeAction() {
        closeHandle?()
    }
}
