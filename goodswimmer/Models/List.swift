//
//  List.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 12/28/20.
//  Copyright © 2020 madi. All rights reserved.
//
 
import Foundation
import FirebaseDatabase
import FirebaseFirestore

struct List {
    var username: String?
    var userId: String?
    var followers: [String?]
    var description: String?
    var events: [String?]
    var places: [String?]
    private var createdDate: Timestamp?
}


/// The following code was used to create a temporary list object in HomeViewController. Use
/// as a starting point or delete:

//let listMenuWidth = 320
//let listMenuHeight = 400
//let listMenuMargin = 20
//let listMenuRowWidth = CGFloat(listMenuWidth)*0.75
//let xPos = (self.view.frame.width)*0.1
//let yPos = (self.view.frame.height)*0.3
//let listMenuView = UIView(frame: CGRect(x: xPos, y: yPos, width:320, height:400))
//listMenuView.backgroundColor = Utilities.getRedUI()
//
//let listMenuViewTest = UIView(frame: CGRect(x: 0, y: 0, width:300, height:100))
//listMenuViewTest.backgroundColor = UIColor.black
//
//
//
//var addToListMenuTitle = UILabel(frame: CGRect(x: 0, y: Int(Double(listMenuHeight)*0), width:listMenuWidth, height:200))
//addToListMenuTitle.textAlignment = .center
//addToListMenuTitle.font = addToListMenuTitle.font.withSize(28)
//addToListMenuTitle.text = "Add to List"
//addToListMenuTitle.textColor = .white
//
//
//
//
//var createListButton = UIButton(type: UIButton.ButtonType.system)
//
//createListButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
//createListButton.setTitle("+ Create New List", for: .normal)
//createListButton.setTitleColor(UIColor.black, for: .normal)
//createListButton.contentHorizontalAlignment = .center
//
//
//var exitListMenuButton = UIButton(type: UIButton.ButtonType.system)
//
//exitListMenuButton.addTarget(self, action: #selector(closeAddTolistMenu), for: .touchUpInside)
//exitListMenuButton.setTitle("Close", for: .normal)
//exitListMenuButton.setTitleColor(UIColor.black, for: .normal)
//exitListMenuButton.contentHorizontalAlignment = .center
//
//
////Stack View
//let listMenuStackView   = UIStackView()
//listMenuStackView.frame = listMenuView.frame
//listMenuStackView.addArrangedSubview(addToListMenuTitle)
//for i in 0...maxButton-1 {
//    buttonArray[i] = UIButton(type: UIButton.ButtonType.custom)
//    setUpListMenuButton(button: buttonArray[i] )
//    listMenuStackView.addArrangedSubview(buttonArray[i] )
//
//}
//
//listMenuStackView.addArrangedSubview(createListButton)
//listMenuStackView.addArrangedSubview(exitListMenuButton)
//
//
//listMenuStackView.axis  = .vertical
//listMenuStackView.distribution  = UIStackView.Distribution.equalSpacing
//listMenuStackView.alignment = UIStackView.Alignment.center
//listMenuStackView.spacing   = 0.0
//listMenuStackView.translatesAutoresizingMaskIntoConstraints = false
//
//listMenuView.addSubview(listMenuStackView)
//listMenuStackView.addArrangedSubview(listMenuViewTest)
//self.view.addSubview(listMenuView)
//
//listMenuView.isHidden = true
//
//
//
//view.addConstraint(NSLayoutConstraint(item: listMenuStackView, attribute: .top, relatedBy: .equal, toItem: listMenuView, attribute: .top, multiplier: 1.0, constant: 0.0))
//view.addConstraint(NSLayoutConstraint(item: listMenuStackView, attribute: .leading, relatedBy: .equal, toItem: listMenuView, attribute: .leading, multiplier: 1.0, constant: 0.0))
//view.addConstraint(NSLayoutConstraint(item: listMenuStackView, attribute: .trailing, relatedBy: .equal, toItem: listMenuView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
//
//for listButton in buttonArray {
//    view.addConstraint(NSLayoutConstraint(item: listButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant:  listMenuRowWidth))
//}
//
//
//view.addConstraint(NSLayoutConstraint(item: createListButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: listMenuRowWidth))
//
////Make Buttons Have Firebase Connections
//let db = Firestore.firestore()
//db.collection("lists").whereField("username", arrayContains: Auth.auth().currentUser?.displayName).getDocuments() { (querySnapshot, err) in
//    if let err = err {
//        print("Error getting lists: \(err)")
//    } else {
//        for document in querySnapshot!.documents {
//            var listName = document.get("listName")
//            if(listName != nil) {
//                print(document.get("listName") as! String)
//                self.buttonArray[self.numOfLists].setTitle(document.get("listName") as! String, for: .normal)
//                self.buttonArray[self.numOfLists].isHidden = false
//                self.numOfLists = self.numOfLists + 1
//
//            }
//
//        }
//    }

//
//@objc func closeAddTolistMenu(_sender: UIButton!) {
//    _sender.superview?.superview?.isHidden = true
//}
//
//
//func setUpListMenuButton(button: UIButton){
//    button.backgroundColor = UIColor.white
//    button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
//    button.setTitle("Create your List!", for: .normal)
//    button.setTitleColor(UIColor.black, for: .normal)
//    button.contentHorizontalAlignment = .center
//    //List Row
//    let listRowCheckBoxFrame = CGRect(x: 0, y: 0, width:40, height:50)
//    
//    let listRowCheckBoxCG = CIContext().createCGImage(CIImage(color: .white), from: listRowCheckBoxFrame)!
//    
//    let listCheckBox = UIImage(cgImage: listRowCheckBoxCG)
//    button.setImage(self.notClicked, for: .normal)
//    button.setImage(self.animated, for: .selected)
//    button.layer.borderWidth = 1
//    button.layer.borderColor = UIColor.black.cgColor
//    button.contentHorizontalAlignment = .left
//    button.titleEdgeInsets.left = 10
//    button.isHidden = true
//    
//    
//}
