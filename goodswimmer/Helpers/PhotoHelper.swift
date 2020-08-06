//
//  PhotoHelper.swift
//  goodswimmer
//
//  Created by madi on 6/16/20.
//  Copyright © 2020 madi w/ help from makeschool All rights reserved.
//

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
    
    func presentImagePickerController(with sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType =  sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
    }
}

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
