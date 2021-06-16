//
//  CalendarModel.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 4/21/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import FSCalendar
import UIKit

// This class is used to format the FSCalendar used in the profile view controller.

public var selectedColor = UIColor.init(red: 2/255, green: 138/255, blue: 75/255, alpha: 1)

func formatCalendar(calendar: FSCalendar, profile_vc: ProfileViewController){
    // Because this is not in the profile view controller we need to
    // set the delegate so swift knows which one we are trying to modify
    calendar.delegate = profile_vc
    calendar.dataSource = profile_vc
    calendar.scope = .month
    calendar.scrollDirection = .vertical
    
    calendar.backgroundColor = .white //trying to get black borders
    
    // Set height to zero to not display it
    calendar.weekdayHeight = 0
    
    calendar.appearance.borderDefaultColor = .black
    calendar.appearance.borderSelectionColor = .black
    calendar.select(Date())
    
    // Set Text Colors
    calendar.appearance.titleDefaultColor = .black
    calendar.appearance.titleTodayColor = .black
    calendar.appearance.titleSelectionColor = .black
    calendar.appearance.titleFont = UIFont(name: "Standard-Book", size: 12)
    calendar.appearance.titleOffset = CGPoint(x: 20, y: 11)
    calendar.appearance.eventDefaultColor = Utilities.getRedUI()
    calendar.appearance.eventSelectionColor = Utilities.getRedUI()
    calendar.appearance.eventOffset = CGPoint(x: -15, y: -25)
    
    // Register the DIYCalendarCell so the FSCalendar uses it
    calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
    calendar.allowsMultipleSelection = false
    calendar.clipsToBounds = true
    
}

enum SelectionType {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}



// This class is responsible for editing the way the a calendar cell looks in
// a profile's calendar
class DIYCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleImageView = UIImageView(image: UIImage(named: "circle"))
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.borderColor = UIColor.black.cgColor
        selectionLayer.borderWidth = 1
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.white
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
        }
    }
}

