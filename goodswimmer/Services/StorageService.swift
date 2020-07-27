//
//  StorageService.swift
//  goodswimmer
//
//  Created by madi on 6/17/20.
//  Copyright © 2020 madi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageService {
    
    //method to upload images to FB Storage
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // change image from UIImage to Data type
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }
        //upload data
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            //get URL ref to image
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
        })
    })
    
}
}
