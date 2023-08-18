//
//  StyleLibrary.swift
//  DigitalHorizonTaksThree
//
//  Created by PGK Shiva Kumar on 06/09/22.
//

import Foundation
import UIKit

public enum SystemTextStyle {
    
    case headline, largeTitle, title, subtitle, content, small , meta
    
    fileprivate func fontSizeAndWeight() -> (CGFloat, UIFont.Weight) {
        
        switch self {
        
        case .headline:
            return Device.isPhone ?  (36, .bold)    : (39, .bold)
            
        case .largeTitle:
            return Device.isPhone ?  (26, .bold)    : (29, .bold)
            
        case .title:
            return Device.isPhone ?  (21, .medium)  : (24, .medium)
            
        case .subtitle:
            return Device.isPhone ?  (18, .medium)  : (21, .medium)
            
        case .content:
            return Device.isPhone ?  (16, .regular) : (18, .regular)
            
        case .small:
            return Device.isPhone ?  (14, .regular) : (16, .regular)
            
        case .meta:
            return Device.isPhone ?  (12, .regular) : (14, .regular)
            
        }
    }
}

public class StyleLibrary {
    
    public let appColor = UIColor.init(red: 56/255, green: 186/255, blue: 208/255, alpha: 1)
    
    public let inMsgBgColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    
    public let inMsgBdColor = UIColor.init(red: 233/255, green: 202/255, blue: 225/255, alpha: 1)
    
    public let outMsgBgColor = UIColor.init(red: 216/255, green: 241/255, blue: 246/255, alpha: 1)
    
    public let outMsgBdColor = UIColor.init(red: 240/255, green: 235/255, blue: 191/255, alpha: 1)
    
    public init() { }
    
}

public extension UILabel {
    
    func showStyle(with style: SystemTextStyle, weight: UIFont.Weight? = nil, color: UIColor = .label) {
        let styleSize = style.fontSizeAndWeight().0
        let styleWeight = style.fontSizeAndWeight().1
        
        textColor = (style == .meta && color == .label) ? .darkGray : color
        
        if let fontWeight = weight {
            font = UIFont.systemFont(ofSize: styleSize, weight: fontWeight)
        } else {
            font = UIFont.systemFont(ofSize: styleSize, weight: styleWeight)
        }
    }
    
    func customFontStyle(name: String = "Avenir", size: CGFloat = UIFont.systemFontSize, color: UIColor = .label) {
        textColor = color
        font = UIFont(name: name, size: Device.isPhone ? size : size + 3)
    }
}

public extension UIButton {
    
    func showStyle(with style: SystemTextStyle, weight: UIFont.Weight? = nil, textColor: UIColor = .systemBlue, bgColor: UIColor? = nil, needCircularCorners: Bool) {
        let styleSize = style.fontSizeAndWeight().0
        let styleWeight = style.fontSizeAndWeight().1
        
        setTitleColor((style == .meta && textColor == .systemBlue) ? .darkGray : textColor, for: .normal)
        layer.cornerRadius = needCircularCorners ? frame.height/2 : 5
        backgroundColor = bgColor
        
        if let fontWeight = weight {
            titleLabel?.font = UIFont.systemFont(ofSize: styleSize, weight: fontWeight)
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: styleSize, weight: styleWeight)
        }
    }
    
    func customFontStyle(name: String = "Avenir", size: CGFloat = UIFont.systemFontSize, textColor: UIColor = .systemBlue, bgColor: UIColor? = nil, needCircularCorners: Bool) {
        setTitleColor(textColor, for: .normal)
        layer.cornerRadius = needCircularCorners ? frame.height/2 : 5
        backgroundColor = bgColor
        titleLabel?.font = UIFont(name: name, size: Device.isPhone ? size : size + 3)
    }
}

public extension UIBarButtonItem {
    
    func showStyle(with style: SystemTextStyle, weight: UIFont.Weight? = nil, color: UIColor = .systemBlue) {
        let styleSize = style.fontSizeAndWeight().0
        let styleWeight = style.fontSizeAndWeight().1
        
        tintColor = (style == .meta && color == .systemBlue) ? .darkGray : color
        
        setTitleTextAttributes([.font : UIFont.systemFont(ofSize: styleSize, weight: weight != nil ? weight! : styleWeight)],
                               for: .normal)
    }
    
    func customFontStyle(name: String = "Avenir", size: CGFloat = UIFont.systemFontSize,  color: UIColor = .systemBlue) {
        
        tintColor = color
        setTitleTextAttributes([.font : UIFont(name: name, size: Device.isPhone ? size : size + 3) ?? UIFont.systemFont(ofSize: size)],
                               for: .normal)
    }
}

public extension UITextField {
    
    func showStyle(with style: SystemTextStyle, weight: UIFont.Weight? = nil, color: UIColor = .label) {
        let styleSize = style.fontSizeAndWeight().0
        let styleWeight = style.fontSizeAndWeight().1
        
        textColor = (style == .meta && color == .label) ? .darkGray : color
        
        if let fontWeight = weight {
            font = UIFont.systemFont(ofSize: styleSize, weight: fontWeight)
        } else {
            font = UIFont.systemFont(ofSize: styleSize, weight: styleWeight)
        }
    }
    
    func customFontStyle(name: String = "Avenir", size: CGFloat = UIFont.systemFontSize, color: UIColor = .label) {
        textColor = color
        font = UIFont(name: name, size: Device.isPhone ? size : size + 3)
    }
}

public extension UITextView {
    
    func showStyle(with style: SystemTextStyle, weight: UIFont.Weight? = nil, color: UIColor = .label, bgColor: UIColor? = nil) {
        let styleSize = style.fontSizeAndWeight().0
        let styleWeight = style.fontSizeAndWeight().1
        
        textColor = (style == .meta && color == .label) ? .darkGray : color
        backgroundColor = bgColor
        
        if let fontWeight = weight {
            font = UIFont.systemFont(ofSize: styleSize, weight: fontWeight)
        } else {
            font = UIFont.systemFont(ofSize: styleSize, weight: styleWeight)
        }
    }
    
    func customFontStyle(name: String = "Avenir", size: CGFloat = UIFont.systemFontSize, color: UIColor = .label, bgColor: UIColor? = nil) {
        textColor = color
        backgroundColor = bgColor
        font = UIFont(name: name, size: Device.isPhone ? size : size + 3)
    }
}

public extension UITabBarController {
    
    func showStyle(color: UIColor = .systemBlue, with style: SystemTextStyle = .meta, weight: UIFont.Weight? = nil, needIndicator: Bool = false, tabBar: UITabBar? = nil) {
        let styleSize = style.fontSizeAndWeight().0
        let styleWeight = style.fontSizeAndWeight().1
        
        UITabBar.appearance().tintColor = color
        let attributesFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: styleSize, weight: weight != nil ? weight! : styleWeight)]
        UITabBarItem.appearance().setTitleTextAttributes(attributesFont, for: .normal)
        
        if needIndicator {
            addTabIndicator(color: color, tabBar: tabBar)
        }
    }
    
    func customStyle(color: UIColor = .systemBlue, name: String = "Avenir", size: CGFloat = UIFont.systemFontSize, needIndicator: Bool = false, tabBar: UITabBar? = nil) {
        
        UITabBar.appearance().tintColor = color
        let attributesFont = [NSAttributedString.Key.font: UIFont(name: name, size: Device.isPhone ? size : size + 3) ?? UIFont.systemFont(ofSize: size)]
        UITabBarItem.appearance().setTitleTextAttributes(attributesFont, for: .normal)
        
        if needIndicator {
            addTabIndicator(color: color, tabBar: tabBar)
        }
    }
    
    private func addTabIndicator(color: UIColor, tabBar: UITabBar?) {
        guard let numberOfTabs = tabBar?.items?.count else { return }
        let numberOfTabsFloat = CGFloat(numberOfTabs)
        let imageSize = CGSize(width: (tabBar?.frame.width ?? 0) / numberOfTabsFloat,
                               height: tabBar?.frame.height ?? 0)
        
        let indicatorImage = UIImage.imageWithColor(color: color, size: imageSize)
        tabBar?.selectionIndicatorImage = indicatorImage
    }
}

public extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: 2)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIView {
    
    func styleWithShadow(cornerRadius: CGFloat = 10) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width:0, height: 1)
        layer.shadowRadius = 2
    }
    
    func addDashedBorder() {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.darkGray.cgColor
        layer.lineJoin = CAShapeLayerLineJoin.round
        layer.lineDashPattern = [6, 3]
        layer.frame = self.bounds
        layer.fillColor = nil
        layer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
        self.layer.addSublayer(layer)
    }
}
