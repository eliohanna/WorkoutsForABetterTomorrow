//
//  Extension+UIViewController.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

protocol ViewControllerInstantiable: UIViewController {
	static var storyboardIdentity: String { get }
}

extension UIViewController: ViewControllerInstantiable {
	static var storyboardIdentity: String {
		return String(describing: self)
	}
}
