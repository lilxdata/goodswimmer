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

    static func createEvent(for image: UIImage) {
        print("in create event, pre uploading image")
        let imageRef = Storage.storage().reference().child("test_image.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                print("in guard")
                return
            }
            let urlString = downloadURL.absoluteString
            print("image URL: \(urlString)")
        }
    }
    
}
