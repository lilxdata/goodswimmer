//
//  MyTabBarController.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 2/25/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var searchViewControllerReference = SearchViewController()
    var createEventViewController = CreateEventViewController()
    var profileViewController = ProfileViewController()
    var homeViewController = HomeViewController()
    var hasSearchBeenLoaded = false
    var hasCreateBeenLoaded = false
    var hasProfileBeenLoaded = false
    var hasHomeBeenLoaded = true
    override func viewDidLoad() {
        self.delegate = self
        searchViewControllerReference = viewControllers![3] as! SearchViewController
        createEventViewController = viewControllers![2] as! CreateEventViewController
        profileViewController = viewControllers![1] as! ProfileViewController
        homeViewController = viewControllers![0] as! HomeViewController
        
        let photoid = Auth.auth().currentUser!.uid
        let imageRef = Storage.storage().reference().child(photoid+".jpg")
 
        imageRef.downloadURL { url, error in
            let profileImageView = UIImageView()
            var photoURL: URL
            if let error = error {
                // Handle any errors
                print(error)
                photoURL = URL(string: Constants.Placeholders.placeholderURL)!
            } else {
                
                //Get the Profile Image
                photoURL = url ?? URL(string: Constants.Placeholders.placeholderURL)!
            }
            profileImageView.sd_setImage(with: photoURL, completed:{ (image, error, cacheType, imageURL) in
                let size = 35
                //Resize the image for the tab bar
                profileImageView.image = self.resizeAsCircleImage(image: (profileImageView.image)!, newRadius: CGFloat(size/2))
                //Round the image
                self.tabBar.items?[1].image = profileImageView.image?.roundedImage
                //Set rendering to original so our photo shows up
                self.tabBar.items?[1].selectedImage = self.tabBar.items?[1].image!.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[1].image = self.tabBar.items?[1].image!.withRenderingMode(.alwaysOriginal)
           })
        }
        
        //Resizing Tab Bar Icons
        self.tabBar.items?[0].selectedImage = self.resizeImage(image: (self.tabBar.items?[0].selectedImage)!, newWidth: 30)
        self.tabBar.items?[0].image = self.tabBar.items?[0].selectedImage
        self.tabBar.items?[2].selectedImage = self.resizeImage(image: (self.tabBar.items?[2].selectedImage)!, newWidth: 30)
        self.tabBar.items?[2].image = self.tabBar.items?[2].selectedImage
        self.tabBar.items?[3].selectedImage = self.resizeImage(image: (self.tabBar.items?[3].selectedImage)!, newWidth: 40)
        self.tabBar.items?[3].image = self.tabBar.items?[3].selectedImage
        
        
        self.tabBar.tintColor = Utilities.getRedUI()
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem!) {
        if(item == self.tabBar.items![2]){
            createEventViewController.view.isHidden = false
            hasCreateBeenLoaded = true
        }
        else {
            if(hasCreateBeenLoaded){
                createEventViewController.view.isHidden = true
            }
        }
        if(item == self.tabBar.items![3]) {
            hasSearchBeenLoaded = true //Keep track that this view has been loaded
        }
        
        else {
            if(hasSearchBeenLoaded){
                searchViewControllerReference.searchController.isActive = false //We will get a null pointer exception if the
            }       //ViewController has not loaded
        }
        if(item == self.tabBar.items![1]) {
            if(hasProfileBeenLoaded){
                let profileC = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
                profileC.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let eventsQ = document.get("events") {
                            self.profileViewController.myEventsArr = eventsQ as! [String]
                        }
                    } else {
                        print("Error getting events")
                    }
                }
                profileViewController.isCurUser = true
                profileViewController.calendar.reloadData() //We will get a null pointer exception if the
            }
            hasProfileBeenLoaded = true //Keep track that this view has been loaded
        }
        if(item == self.tabBar.items![0]) {
            if(hasHomeBeenLoaded){
                var sortBy = ""
                if(homeViewController.sortBySwitch.isOn){ sortBy = "start_date"}
                else{ sortBy = "createdDate"}
                homeViewController.sortTableView(sortBy: sortBy) //We will get a null pointer exception if the
            }
            hasHomeBeenLoaded = true //Keep track that this view has been loaded
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected view controller")
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
}
