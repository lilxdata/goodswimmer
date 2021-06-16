//
//  Utilities.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit


// JUNE 2021 TODO: The style functions here are fairly self explanatory,
// the biggest lingering need here is to map out how these should be done
// There isn't a uniform way that we use Textfields, Textview, Labels, etc.
// It may be helpful to go through the XD screens and see what similarities
// and differences elements have so that they can be styled in as automated
// way as possible. Everything that sort of changes like size can be inputs
// to create a specific element for a specfic use.

class Utilities {
    
    static func styleTextField(_ textfield: UITextField, size: Int) {
        // create bottom line detail
        let bottomLine = CALayer()
        let fontSize = CGFloat(size)
        bottomLine.frame = CGRect( x:0, y:textfield.frame.height + 5, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textfield.layer.addSublayer(bottomLine)
        textfield.textColor = UIColor.black
        textfield.font = UIFont(name: "Standard-Book", size: fontSize)
    }
    
    static func styleTextView(_ textView: UITextView, size: Int) {
        // create bottom line detail
        let bottomLine = CALayer()
        let fontSize = CGFloat(size)
        bottomLine.frame = CGRect( x:0, y:textView.frame.height + 5, width: textView.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textView.layer.addSublayer(bottomLine)
        textView.textColor = UIColor.black
        textView.font = UIFont(name: "Standard-Book", size: fontSize)
    }
    
    static func styleDisabledTextField(_ textfield: UITextField, size: Int) {
        // create bottom line detail
        let bottomLine = CALayer()
        let fontSize = CGFloat(size)
        bottomLine.frame = CGRect( x:0, y:textfield.frame.height + 5, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.systemGray2.cgColor
        textfield.layer.addSublayer(bottomLine)
        textfield.textColor = UIColor.black
        textfield.font = UIFont(name: "Standard-Book", size: fontSize)
    }
    
    static func styleDisabledTextView(_ textView: UITextView, size: Int) {
        // create bottom line detail
        let bottomLine = CALayer()
        let fontSize = CGFloat(size)
        bottomLine.frame = CGRect( x:0, y:textView.frame.height + 5, width: textView.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.systemGray2.cgColor
        textView.layer.addSublayer(bottomLine)
        textView.textColor = UIColor.black
        textView.font = UIFont(name: "Standard-Book", size: fontSize)
    }
    
    static func styleHeader(_ label: UILabel){
        label.font = UIFont(name: "Career_salle13_cursive", size: 20)
        label.textColor = UIColor.black
        label.text = label.text?.uppercased()
    }
    
    static func styleSubHeader(_ label:UILabel) {
        label.font = UIFont(name: "CutiveMono-Regular", size: 21)
        label.textColor = UIColor.black
    }
    
    static func styleLabel(_ label: UILabel, size: Int, uppercase: Bool){
        let fontSize = CGFloat(size)
        label.font = UIFont(name: "Standard-Book", size: fontSize)
        if uppercase {
            label.text = label.text?.uppercased()
        }
    }
    
    static func styleLabelBold(_ label: UILabel, size: Int, uppercase: Bool){
        let fontSize = CGFloat(size)
        label.font = UIFont(name: "Standard-Bold", size: fontSize)
        if uppercase {
            label.text = label.text?.uppercased()
        }
    }
    
    static func styleEventHeader(_ header: String) {
        let fontSize = CGFloat(15)
        header.uppercased()
    }
    
    static func styleButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont(name: "Standard-Book", size: 21)
        button.setTitle(button.title(for: .normal)?.uppercased(), for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        button.titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        button.titleEdgeInsets.top = 2 // This font at 21p needs this offset to be truly centered
        
    }
    
    static func styleError(_ label: UILabel) {
        styleSubHeader(label)
        label.textColor = getRedUI()
        label.numberOfLines = 0
    }
    
    /* password validation */
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    // Removes text from UITextField
    static func cleanData(_ field: UITextField) -> String {
        return field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Checks if UITextField is empty
    static func isFilledIn(_ fields: [UITextField]) -> Bool {
        for field in fields {
            if field == nil {
                print ("oops! you didn't fill everything in!")
                break
            } else {
                return true
            }
        }
        return false
    }
    
    // Function used to programatically format the UISearchController
    static func customizeSearchBar(_ controller: UISearchController){
        let bar = controller.searchBar
        bar.barTintColor = getRedUI()
        bar.tintColor = UIColor.white
        if let text = bar.value(forKey: "searchField") as? UITextField {
            text.textColor = UIColor.white
        }
    }
    
    // Get goodswimmer specific red color as a CGColor
    static func getRedCG() -> CGColor{
        return CGColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 1.0)
    }
    
    // Get goodswimmer specific red color as a UIColor
    static func getRedUI() -> UIColor{
        return UIColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 1.0)
    }
    
    // Get goodswimmer specific grey color as a CGColor
    static func getGreyCG() -> CGColor{
        return CGColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.0)
    }
    
    // Get goodswimmer specific grey color as a UIColor
    static func getGreyUI() -> UIColor{
        return UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.0)
    }
}

extension UIImageView {
    
    // Makes a UIImageView object rounded based on a given corner radius
    func makeRounded(_cornerRadius: CGFloat) {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = _cornerRadius/2
        self.clipsToBounds = true
    }
}

extension UIImage{
    
    // Makes a UIImage object rounded
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height 
        ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
