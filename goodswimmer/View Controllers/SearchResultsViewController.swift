//
//  SearchResultsViewController.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 3/11/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class SearchResultsViewController: UIViewController {
    

    override func viewDidLoad() {

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
}

extension SearchResultsViewController : UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! EventCell //cast as event cell
        
        //get event
        //let event = self.eventArray.events[indexPath.row]
        
        //customize cell
        //cell.displayEvent(event)
        
        // return cell
        return cell
    }
    
    //called everytime cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      /*
      //  self.performSegue(withIdentifier: "detailSegue2", sender: <#T##Any?#>)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC2") as? DetailViewController {
            vc.selectedEvent = self.eventArray.events[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        */
    }
}



