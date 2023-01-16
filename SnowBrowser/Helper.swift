//
//  Helper.swift
//  SnowBrowser
//
//  Created by yangjian on 2023/1/5.
//

import Foundation
import UIKit


var AppEnterbackground = false
var AppEnterbackgrounded = false
var sceneDelegate: SceneDelegate? = nil
var rootVC: RootViewController? = nil

let kWidth = sceneDelegate?.window?.bounds.width ?? 360.0
let kHeight = sceneDelegate?.window?.bounds.height ?? 750.0
let kRadioW = kWidth / 360.0
let kRadioH = kHeight / 750.0

extension UIColor {
    
     /**
      获取颜色，通过16进制色值字符串，e.g. #ff0000， ff0000
      - parameter hexString  : 16进制字符串
      - parameter alpha      : 透明度，默认为1，不透明
      - returns: RGB
      */
     static func hex(_ hex: String, alpha:CGFloat = 1) -> UIColor {
         // 去除空格等
         var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
         // 去除#
         if (cString.hasPrefix("#")) {
             cString = (cString as NSString).substring(from: 1)
         }
         // 必须为6位
         if (cString.count != 6) {
             return UIColor.gray
         }
         // 红色的色值
         let rString = (cString as NSString).substring(to: 2)
         let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
         let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
         // 字符串转换
         var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
         Scanner(string: rString).scanHexInt32(&r)
         Scanner(string: gString).scanHexInt32(&g)
         Scanner(string: bString).scanHexInt32(&b)
         
         return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
     }
    
    static func themeColor() -> UIColor {
        return self.hex("#5390EE")
    }
}

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}

extension UIViewController {
    func alert(_ message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak alertController] in
            alertController?.dismiss(animated: true)
        }
    }
}
