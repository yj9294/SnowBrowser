//
//  BrowserHelper.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/6.
//

import Foundation
import UIKit
import WebKit

class BrowserHelper: NSObject {
    static let shared = BrowserHelper()
    var webItems:[BrowserItem] = [.navgationItem]
    
    var webItem: BrowserItem {
        webItems.filter {
            $0.isSelect == true
        }.first ?? .navgationItem
    }
    
    func removeItem(_ item: BrowserItem) {
        if item.isSelect {
            webItems = webItems.filter {
                $0 != item
            }
            webItems.first?.isSelect = true
        } else {
            webItems = webItems.filter {
                $0 != item
            }
        }
    }
    
    func clean(from vc: UIViewController) {
        webItems.filter {
            !$0.isNavigation && $0.isSelect
        }.compactMap {
            $0.webView
        }.forEach {
            $0.removeFromSuperview()
            if $0.observationInfo != nil {
                $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress))
                $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.url))
            }
        }
        webItems = [.navgationItem]
    }
    
    func add(_ item: BrowserItem = .navgationItem) {
        webItems.forEach {
            $0.isSelect = false
        }
        webItems.insert(item, at: 0)
    }
    
    func select(_ item: BrowserItem) {
        if !webItems.contains(item) {
            return
        }
        webItems.forEach {
            $0.isSelect = false
        }
        item.isSelect = true
    }
    
    func goBack() {
        webItem.webView.goBack()
    }
    
    func goForword() {
        webItem.webView.goForward()
    }
    
    func loadUrl(_ url: String, from vc: UIViewController) {
        webItem.loadUrl(url, from: vc)
    }
    
    func stopLoad() {
        webItem.stopLoad()
    }

}

class BrowserItem: NSObject {
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    var webView: WKWebView
    
    var isNavigation: Bool {
        webView.url == nil
    }
    var isSelect: Bool
    
    func loadUrl(_ url: String, from vc: UIViewController) {
        if url.isUrl, let Url = URL(string: url) {
            // 移出 view
            BrowserHelper.shared.webItems.filter({
                !$0.isNavigation
            }).compactMap({
                $0.webView
            }).forEach {
                $0.removeFromSuperview()
                if $0.observationInfo != nil {
                    $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress))
                    $0.removeObserver(vc, forKeyPath: #keyPath(WKWebView.url))
                }
            }
            // 添加 view
            vc.view.addSubview(webView)
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.url), context: nil)
            let request = URLRequest(url: Url)
            webView.load(request)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.loadUrl(reqString, from: vc)
        }
    }
    
    func stopLoad() {
        webView.stopLoading()
    }
    
    static var navgationItem: BrowserItem {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.clipsToBounds = true
        return BrowserItem(webView: webView, isSelect: true)
    }
}
