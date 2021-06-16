//
//  PhotoHelper.swift
//  goodswimmer
//
//  Created by madi on 6/16/20.
//  Copyright © 2020 madi w/ help from makeschool All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
import UIKit

class PhotoHelper: NSObject {
    
    // MARK: - Properties
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    //takes a reference to a VC so we can show the view
    func presentActionSheet(from viewController: UIViewController) {
        
        // Initialize new pop-up alert controller
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        // if device has a camera, add take photo action to controller
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take photo", style: .default, handler: { [unowned self] action in
                self.presentImagePickerController(with: .camera, from: viewController)
                // stuff later
            })
            
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from library", style: .default, handler: { action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
                // do stuff
            })
            
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    // Function brings apple pop up asking to choose from camera roll or to take a new photo
    func presentImagePickerController(with sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType =  sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
    }
    
    
    // Helper function resize UIImage object
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        //UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


// Extension added to help bring up Apple "Select photo from what source" pop up
extension PhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
