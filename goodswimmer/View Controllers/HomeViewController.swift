//
//  HomeViewController.swift
//  goodswimmer_logincwc
//
//  Created by madi on 3/30/20.
//  Copyright © 2020 madi. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var zeroStateView: UIView!
    @IBOutlet weak var sortBySwitch: UISwitch!
    @IBOutlet weak var sortByLabel: UILabel!

    let eventArray = EventArray.sharedInstance
    let menu = Menu.sharedInstance
    
    
    var event = Event(eventDict: ["eventName" : "PlaceHolder"])
    let maxButton = 10
    var numOfLists = 0
    var buttonArray = [UIButton](repeating: UIButton(type: UIButton.ButtonType.custom), count: 10)
    let notClicked = UIImage.imageWithColor(color: .white, size: CGSize(width: 50, height: 50))
    let clicked = UIImage.imageWithColor(color: .black, size: CGSize(width: 50, height: 50))
    let animated = UIImage.imageWithColor(color: Utilities.getRedUI(), size: CGSize(width: 50, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        tableView.delegate = self
        tableView.dataSource = self

        
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        REGEX_TESTS.run_regex_date_test()
        REGEX_TESTS.run_regex_street_num_test()

        
        let listMenuWidth = 320
        let listMenuHeight = 400
        let listMenuMargin = 20
        let listMenuRowWidth = CGFloat(listMenuWidth)*0.75
        let xPos = (self.view.frame.width)*0.1
        let yPos = (self.view.frame.height)*0.3
        let listMenuView = UIView(frame: CGRect(x: xPos, y: yPos, width:320, height:400))
        listMenuView.backgroundColor = Utilities.getRedUI()
        
        let listMenuViewTest = UIView(frame: CGRect(x: 0, y: 0, width:300, height:100))
        listMenuViewTest.backgroundColor = UIColor.black
       
        
        
        var addToListMenuTitle = UILabel(frame: CGRect(x: 0, y: Int(Double(listMenuHeight)*0), width:listMenuWidth, height:200))
        addToListMenuTitle.textAlignment = .center
        addToListMenuTitle.font = addToListMenuTitle.font.withSize(28)
        addToListMenuTitle.text = "Add to List"
        addToListMenuTitle.textColor = .white
        
        
        
        
        var createListButton = UIButton(type: UIButton.ButtonType.system)
        
        createListButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        createListButton.setTitle("+ Create New List", for: .normal)
        createListButton.setTitleColor(UIColor.black, for: .normal)
        createListButton.contentHorizontalAlignment = .center

        
        var exitListMenuButton = UIButton(type: UIButton.ButtonType.system)
        
        exitListMenuButton.addTarget(self, action: #selector(closeAddTolistMenu), for: .touchUpInside)
        exitListMenuButton.setTitle("Close", for: .normal)
        exitListMenuButton.setTitleColor(UIColor.black, for: .normal)
        exitListMenuButton.contentHorizontalAlignment = .center
        
        
        //Stack View
        let listMenuStackView   = UIStackView()
        listMenuStackView.frame = listMenuView.frame
        listMenuStackView.addArrangedSubview(addToListMenuTitle)
        for i in 0...maxButton-1 {
            buttonArray[i] = UIButton(type: UIButton.ButtonType.custom)
            setUpListMenuButton(button: buttonArray[i] )
            listMenuStackView.addArrangedSubview(buttonArray[i] )
            
        }
        
        listMenuStackView.addArrangedSubview(createListButton)
        listMenuStackView.addArrangedSubview(exitListMenuButton)
        
        
        listMenuStackView.axis  = .vertical
        listMenuStackView.distribution  = UIStackView.Distribution.equalSpacing
        listMenuStackView.alignment = UIStackView.Alignment.center
        listMenuStackView.spacing   = 0.0
        listMenuStackView.translatesAutoresizingMaskIntoConstraints = false
        
        listMenuView.addSubview(listMenuStackView)
        listMenuStackView.addArrangedSubview(listMenuViewTest)
        self.view.addSubview(listMenuView)
        
        listMenuView.isHidden = true
        
        
        
        view.addConstraint(NSLayoutConstraint(item: listMenuStackView, attribute: .top, relatedBy: .equal, toItem: listMenuView, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: listMenuStackView, attribute: .leading, relatedBy: .equal, toItem: listMenuView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: listMenuStackView, attribute: .trailing, relatedBy: .equal, toItem: listMenuView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        for listButton in buttonArray {
            view.addConstraint(NSLayoutConstraint(item: listButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant:  listMenuRowWidth))
        }
        

        view.addConstraint(NSLayoutConstraint(item: createListButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: listMenuRowWidth))
    
        //Make Buttons Have Firebase Connections
        let db = Firestore.firestore()
        db.collection("lists").whereField("username", arrayContains: Auth.auth().currentUser?.displayName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting lists: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var listName = document.get("listName")
                    if(listName != nil) {
                        print(document.get("listName") as! String)
                        self.buttonArray[self.numOfLists].setTitle(document.get("listName") as! String, for: .normal)
                        self.buttonArray[self.numOfLists].isHidden = false
                        self.numOfLists = self.numOfLists + 1
                        
                    }
                    
                }
            }
        }
    }
    
    @objc func pressed(_sender: UIButton!) {
        print("I pressed")
        //_sender.isSelected = true
        if(_sender.image(for: .normal) == notClicked) {
            _sender.setImage(clicked, for: .normal)
        }
        else if(_sender.image(for: .normal) == clicked){
            _sender.setImage(notClicked, for: .normal)
            
        }
        
    }
    
    @objc func closeAddTolistMenu(_sender: UIButton!) {
        print("I am getting my parent")
        print(_sender.superview)
        _sender.superview?.superview?.isHidden = true
        
    }

    
    func setUpListMenuButton(button: UIButton){
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.setTitle("Create your List!", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .center
        //List Row
        let listRowCheckBoxFrame = CGRect(x: 0, y: 0, width:40, height:50)
        
        let listRowCheckBoxCG = CIContext().createCGImage(CIImage(color: .white), from: listRowCheckBoxFrame)!
        
        let listCheckBox = UIImage(cgImage: listRowCheckBoxCG)
        button.setImage(self.notClicked, for: .normal)
        button.setImage(self.animated, for: .selected)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets.left = 10
        button.isHidden = true
        
        
    }
    
    func setUpElements() {
        Utilities.styleHeader(headerLabel)
        Utilities.styleLabel(sortByLabel, size: 12, uppercase: false)
        sortByLabel.textAlignment = .right
        sortTableView(sortBy: "start_date")
        sortBySwitch.clipsToBounds = true
        sortBySwitch.layer.cornerRadius = 1 * sortBySwitch.frame.height / 2.0
        sortBySwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        sortBySwitch.onTintColor = Utilities.getRedUI()
        sortBySwitch.tintColor = Utilities.getRedUI()
        sortBySwitch.backgroundColor = Utilities.getRedUI()
    }
    
    @IBAction func inviteFriend(_ sender: Any) {
        print("invite friend button pressed")
    }
    
    @IBAction func addToList(_ sender: Any) {
        print("add to list button pressed")
    }
    
    @IBAction func addToCal(_ sender: Any) {
        print("add to calendar button pressed")
    }
    
    @IBAction func sortByUpdate(_ sender: Any) {
        if(sortBySwitch.isOn) {
            sortByLabel.text = "Event Date"
            sortTableView(sortBy: "start_date")
            sortBySwitch.onTintColor = .orange
            sortBySwitch.tintColor = .orange
            sortBySwitch.backgroundColor = .orange
        }
        else {
            sortByLabel.text = "Date Posted"
            sortTableView(sortBy: "createdDate")
            sortBySwitch.tintColor = .blue
            sortBySwitch.backgroundColor = .blue
        }
    }
    
    func sortTableView(sortBy: String){
        let db = Firestore.firestore()
        db.collection("users").whereField("username", isEqualTo: Auth.auth().currentUser?.displayName)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //let x = self.event?.username
                        var followers = document.get("followers") as! [String]
                        db.collection("events").order(by: sortBy).addSnapshotListener { (querySnapshot, error) in
                            if error == nil && querySnapshot != nil {
                                //clear event array to remove dupes
                                self.eventArray.events.removeAll()
                                for document in querySnapshot!.documents {
                                    let eventData = document.data()
                                    let eventDate = (document.get("start_date") as! Timestamp).dateValue()
                                    let currentDate = NSDate() as Date
                                    let eventUsername = document.get("username") as! String
                                    if(eventDate > currentDate && (followers.contains(eventUsername) || eventUsername == Auth.auth().currentUser?.displayName)){
                                        if let event = Event(eventDict: eventData) {
                                            self.eventArray.events.append(event)
                                        }
                                    }
                                }
                                self.tableView.reloadData()
                                if self.eventArray.events.count == 0 {
                                    self.zeroStateView.isHidden = false
                                }
                            }
                        }
                    }
                }
        }
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventArray.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell //cast as event cell
        
        //get event
        let event = self.eventArray.events[indexPath.row]
        
        //customize cell
        cell.displayEvent(event)
        
        // return cell
        return cell
    }
    
    //called everytime cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  self.performSegue(withIdentifier: "detailSegue2", sender: <#T##Any?#>)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC2") as? DetailViewController {
            vc.selectedEvent = self.eventArray.events[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}


extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

