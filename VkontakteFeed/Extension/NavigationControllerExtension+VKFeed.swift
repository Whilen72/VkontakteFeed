//
//  NavigationControllerExtension+VKFeed.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 17.09.21.
//

import UIKit

extension UINavigationController {

    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
