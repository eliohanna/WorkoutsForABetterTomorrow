//
//  Extension+UIView.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import UIKit

extension UIView {
	func addCornerRadius(_ radius: CGFloat = 3) {
		layer.cornerRadius = radius
		layer.masksToBounds = true
	}
}
