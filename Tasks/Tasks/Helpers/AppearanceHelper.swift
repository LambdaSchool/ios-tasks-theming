//
//  AppearanceHelper.swift
//  Tasks
//
//  Created by Nathan Hedgeman on 6/19/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import UIKit

enum ApperanceHelper{

    static var backgroundWhite = UIColor(displayP3Red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    static var myBoyBlues = UIColor(displayP3Red: 101/255, green: 116/255, blue: 181/255, alpha: 1)
    
    static func customFont(with textStyle: UIFont.TextStyle, pointSize: CGFloat) -> UIFont {
        
        let font = UIFont(name: "Courier Prime Code", size: pointSize)!
        
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    static func setBlueAppearance() {
        
        UILabel.appearance().textColor = myBoyBlues
        
        
        UISegmentedControl.appearance().tintColor = myBoyBlues
        
        UITextView.appearance().tintColor = myBoyBlues
        UITextField.appearance().tintColor = myBoyBlues
        
        let textAttributes = [NSAttributedString.Key.foregroundColor : backgroundWhite]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        
        UINavigationBar.appearance().barTintColor = myBoyBlues
        UIBarButtonItem.appearance().tintColor = backgroundWhite
        
        
    }
}
