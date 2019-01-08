//
//  AppearanceHelper.swift
//  UIAppearanceAndAnimation
//
//  Created by Spencer Curtis on 8/21/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

enum AppearanceHelper {
    
    static var lambdaRed = UIColor(red: 212.0/255.0, green: 87.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    static var backgroundGray = UIColor(red: 45.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1.0)

    static func typerighterFont(with textStyle: UIFont.TextStyle, pointSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "RM Typerighter medium", size: pointSize) else { fatalError("Font is nil. Check the name of the font.") }
        return UIFontMetrics(forTextStyle: .callout).scaledFont(for: font)
    }
    
    static func setDarkAppearance() {
        
        UILabel.appearance().textColor = .white
        UINavigationBar.appearance().barTintColor = backgroundGray
        
        UISegmentedControl.appearance().tintColor = lambdaRed
        UIBarButtonItem.appearance().tintColor = lambdaRed
        
        UITableViewCell.appearance().backgroundColor = .lightGray
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
        UITextField.appearance().tintColor = lambdaRed
        UITextView.appearance().tintColor = lambdaRed
    
        UITextField.appearance().keyboardAppearance = .dark
    }
    
    static func style(button: UIButton) {
        
        button.titleLabel?.font = AppearanceHelper.typerighterFont(with: .body, pointSize: 30)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = lambdaRed
        
        button.layer.cornerRadius = 8
    }
}
