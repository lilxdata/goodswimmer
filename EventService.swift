//
//  EventService.swift
//  goodswimmer
//
//  Created by madi on 4/28/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

//TODO
struct EventService {
    
    //TODO: image is being written before event is created -- do we want to wait until event is created to write the image to FB storage? 

    static func createEvent(for image: UIImage) {
        //TODO: make unique identifier for image, otherwise it will be overwritten
        let imageRef = Storage.storage().reference().child("test_image.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            let urlString = downloadURL.absoluteString
            print("image URL: \(urlString)")
        }
    }
    
}
