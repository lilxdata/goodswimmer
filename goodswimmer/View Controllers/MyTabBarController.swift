//
//  MyTabBarController.swift
//  goodswimmer
//
//  Created by Alex Echeverria on 2/25/21.
//  Copyright © 2021 madi. All rights reserved.
//

import Foundation
import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var searchViewControllerReference = SearchViewController()
    var hasSearchBeenLoaded = false
    override func viewDidLoad() {
        self.delegate = self
        searchViewControllerReference = viewControllers![3] as! SearchViewController
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem!) {
        if(item == self.tabBar.items![3]) {
            hasSearchBeenLoaded = true //Keep track that this view has been loaded
        }
        else {
            if(hasSearchBeenLoaded){
                searchViewControllerReference.searchController.isActive = false //We will get a null pointer exception if the
            }                                            //SearchViewController has not loaded
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected view controller")
    }
}
