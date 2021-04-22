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

public var selectedColor = UIColor.init(red: 2/255, green: 138/255, blue: 75/255, alpha: 1)


func formatCalendar(calendar: FSCalendar, profile_vc: ProfileViewController){
    calendar.delegate = profile_vc
    calendar.dataSource = profile_vc
    calendar.scope = .month
    calendar.scrollDirection = .vertical
    
    calendar.backgroundColor = .white //trying to get black borders
    calendar.calendarHeaderView.isHidden = true
    calendar.calendarWeekdayView.isHidden = true
    //Don't want to show this?
    calendar.weekdayHeight = 0
    calendar.headerHeight = 0
    
    calendar.appearance.borderDefaultColor = .black
    calendar.appearance.borderSelectionColor = .black

    //Turn off current day highlight
    //calendar.today = nil
    
    //Make not all text black
    calendar.appearance.titleDefaultColor = .black
    calendar.appearance.titleTodayColor = .black
    calendar.appearance.titleSelectionColor = .black
    calendar.appearance.titleFont = UIFont(name: "Standard-Book", size: 12)
    calendar.appearance.titleOffset = CGPoint(x: 20, y: 11)
    //calendar.placeholderType = .none
    
    calendar.appearance.eventDefaultColor = .black
    calendar.appearance.eventSelectionColor = .black
    calendar.appearance.eventOffset = CGPoint(x: 0, y: 0)
    
    calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
    //I am trying to figure out how they color boxes
    //calendar.allowsMultipleSelection = true
    calendar.clipsToBounds = true

}


enum SelectionType {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CalendarCollectionViewCell: FSCalendarCell {

    weak var circleImageView: UIImageView?
    weak var selectionLayer: CAShapeLayer?
    weak var roundedLayer: CAShapeLayer?

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.lightGray.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel?.layer)
        self.selectionLayer = selectionLayer

        let roundedLayer = CAShapeLayer()
        roundedLayer.fillColor = UIColor.blue.cgColor
        roundedLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(roundedLayer, below: self.titleLabel?.layer)
        self.roundedLayer = roundedLayer

        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let selectionLayer = selectionLayer, let roundedLayer = roundedLayer else { return }
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer?.frame = self.contentView.bounds
        self.roundedLayer?.frame = self.contentView.bounds

        switch selectionType {
        case .middle:
            self.selectionLayer?.isHidden = false
            self.selectionLayer?.path = UIBezierPath(rect: selectionLayer.bounds).cgPath
            self.roundedLayer?.isHidden = true

        case .leftBorder:
            let selectionRect = selectionLayer.bounds.insetBy(dx: selectionLayer.frame.width / 4, dy: 0.0).offsetBy(dx: selectionLayer.frame.width / 4, dy: 0.0)
            self.selectionLayer?.isHidden = false
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

            let diameter: CGFloat = min(roundedLayer.frame.height, roundedLayer.frame.width)
            let rect = CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)
            self.roundedLayer?.isHidden = false
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath

        case .rightBorder:
            let selectionRect = selectionLayer.bounds.insetBy(dx: selectionLayer.frame.width / 4, dy: 0.0).offsetBy(dx: -selectionLayer.frame.width / 4, dy: 0.0)
            self.selectionLayer?.isHidden = false
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

            let diameter: CGFloat = min(roundedLayer.frame.height, roundedLayer.frame.width)
            let rect = CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)
            self.roundedLayer?.isHidden = false
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath

        case .single:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = false
            let diameter: CGFloat = min(roundedLayer.frame.height, roundedLayer.frame.width)
            self.roundedLayer?.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath

        case .none:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = true
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
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}


