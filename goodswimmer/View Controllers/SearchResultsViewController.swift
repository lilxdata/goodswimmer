//
//  SearchResultsViewController.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 3/11/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var searchResultsLabel: UILabel!
    @IBOutlet weak var searchResults: UITableView!
    let db = Firestore.firestore()
    var userArray = [User]()
    var userId = ""
    
    override func viewDidLoad() {
        searchResults.delegate = self
        searchResults.dataSource = self
        loadUsers()
    
        
        func numberOfSections(in searchResults: UITableView) -> Int {
            return 1
        }
        
        let photoid = Auth.auth().currentUser!.uid
        let imageRef = Storage.storage().reference().child(photoid+".jpg")
 
        imageRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
            print(error)
          } else {
                let profileImageView = UIImageView()
                //Get the Profile Image
                profileImageView.sd_setImage(with: url, completed:{ (image, error, cacheType, imageURL) in
                    let size = 35
                    //Resize the image for the tab bar
                    profileImageView.image = self.resizeAsCircleImage(image: (profileImageView.image)!, newRadius: CGFloat(size/2))

               })
          }
        }

        
    }


    /*This function resizes an image with same scale as original*/
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
    
    /* This function resizes an image as a circle, does not keep all of the orignal image*/
    func resizeAsCircleImage(image: UIImage, newRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newRadius*2, height: newRadius*2))
        image.draw(in: CGRect(x: 0, y: 0, width: newRadius*2, height: newRadius*2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func loadUsers(){
        let users = db.collection("users").order(by: "username")
        print(users)
        users.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {

                    let userURL_q = document.get("photoURL")

                    let userURL:String
                    if userURL_q == nil {
                        userURL = Constants.Placeholders.placeholderURL
                    }
                    else {
                        userURL = userURL_q as! String
                    }
                    let userBio = document.get("bio") as! String
                   
                    
                    let userEvents = document.get("events") as! [String]
                    let userFollowers = document.get("followers") as! [String]
                    let userFollowing = document.get("following") as! [String]
                    let userId = document.get("userId") as! String
                    let userUsername = document.get("username") as! String
                    
                    let user = User(username: userUsername, userId: userId, following:userFollowing, followers:userFollowers, bio: userBio, photoURL: userURL, events: userEvents)
                    self.userArray.append(user)
                
                    
                }
            }
            print(self.userArray)
            self.searchResults.reloadData()
        }
    }
}

extension SearchResultsViewController : UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a cell
        let cell:UserSearchCell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell //cast as user cell
        
        
        //get user
        let user = userArray[indexPath.row]

        //customize cell
        cell.displayUser(user)
        
        // return cell
        return cell
    }
    
    //called everytime cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I tapped a cell")
        let profile_view  = storyboard!.instantiateViewController(withIdentifier: "profile_vc") as! ProfileViewController
        profile_view.profileOwner = self.userArray[indexPath.row]
        profile_view.myEventsArr = self.userArray[indexPath.row].events as [String]
        if(profile_view.profileOwner.userId == Auth.auth().currentUser?.uid){
            profile_view.isCurUser = true
        }
        else {profile_view.isCurUser = false}
        self.present(profile_view, animated: true, completion: nil)
    }
}



