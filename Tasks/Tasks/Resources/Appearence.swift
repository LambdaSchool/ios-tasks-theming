//
//  Appearence.swift
//  Tasks
//
//  Created by Farhan on 10/1/18.
//  Copyright © 2018 Andrew R Madsen. All rights reserved.
//

import UIKit

enum Appearence {
    
    // MARK :- Properties
    static var darkGreen = UIColor(red: 110.0/255.0, green: 200.0/255.0, blue: 90.0/255.0, alpha: 1.0)
    static var lightGreen = UIColor(red: 73.0/255.0, green: 193.0/255.0, blue: 90.0/255.0, alpha: 1.0)
    
    static func titleFont(with textStyle: UIFontTextStyle, pointSize: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: "Hemi Head", size: pointSize) else {fatalError("font not found")}
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    static func applicationFont(with textStyle: UIFontTextStyle, pointSize: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: "Good Times", size: pointSize) else {fatalError("font not found")}
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    // MARK :- Functions
    
    static func setAppearence(){
        
        // NavBar
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = lightGreen
        let attributes = [NSAttributedString.Key.font: self.titleFont(with: .title1, pointSize: 45), NSAttributedString.Key.foregroundColor: lightGreen]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().largeTitleTextAttributes = attributes
        
        //Segmented View Controller
        UISegmentedControl.appearance().tintColor = darkGreen
        
        //tableView
        UITableView.appearance().backgroundColor = darkGreen
        
    }

    
    static func setCellStyle(for cell: UITableViewCell){
    
        cell.backgroundColor = darkGreen
        
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        
        cell.textLabel?.font = self.applicationFont(with: .caption1, pointSize: 15)
        cell.detailTextLabel?.font = self.applicationFont(with: .caption2, pointSize: 10)
        
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
        
        
        
    }
    
    
    
}
