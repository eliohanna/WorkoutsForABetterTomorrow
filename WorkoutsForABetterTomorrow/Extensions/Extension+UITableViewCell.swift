//
//  Extension+UITableViewCell.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import UIKit

protocol TableViewCellIdentifiable: UITableViewCell {
	static var identifier: String { get }
	static var xib: UINib { get }
}

extension UITableViewCell: TableViewCellIdentifiable {
	static var identifier: String {
		return String(describing: self)
	}
	
	static var xib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
}
