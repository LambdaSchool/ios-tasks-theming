//
//  AppearanceHelper.swift
//  Tasks
//
//  Created by Dillon McElhinney on 10/1/18.
//  Copyright © 2018 Andrew R Madsen. All rights reserved.
//

import UIKit

enum Appearance {
    static let darkBackground = UIColor(red: 0.125, green: 0.125, blue: 0.145, alpha: 1)
    static let criticalPriorityColor = UIColor(red: 122/255, green: 40/255, blue: 38/255, alpha: 1)
    static let highPriorityColor = UIColor(red: 168/255, green: 96/255, blue: 43/255, alpha: 1)
    static let normalPriorityColor = UIColor(red: 166/255, green: 136/255, blue: 43/255, alpha: 1)
    static let lowPriorityColor = UIColor(red: 65/255, green: 58/255, blue: 171/255, alpha: 1)
    
    static func setupDarkTheme() {
        
        UINavigationBar.appearance().barTintColor = darkBackground
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white, .font: applicationFont(with: .title1, at: 16)]
        
        UITableView.appearance().backgroundColor = darkBackground
        UITableViewCell.appearance().backgroundColor = darkBackground
        
        UITextView.appearance().textColor = .white
        UITextView.appearance().backgroundColor = colorForPosition(color: darkBackground, position: 1)
        UITextField.appearance().textColor = .white
        UITextField.appearance().backgroundColor = colorForPosition(color: darkBackground, position: 1)
        UITextField.appearance().keyboardAppearance = .dark
        
        UILabel.appearance().textColor = .white
    }
    
    static func applicationFont(with textStyle: UIFontTextStyle, at pointSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Roboto Slab", size: pointSize) else {
            fatalError("Couldn't make the font. Make sure it is spelled right.")
        }
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    static func colorForPosition(color: UIColor, position: Int) -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let multiplier: CGFloat = 0.04 * CGFloat(position)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness + multiplier, alpha: alpha)
    }
}
