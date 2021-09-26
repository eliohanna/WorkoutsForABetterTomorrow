//
//  Extension+UITableView.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import UIKit

extension UITableView {
	func register(cellNib cell: TableViewCellIdentifiable.Type) {
		register(cell.xib, forCellReuseIdentifier: cell.identifier)
	}
	
	func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
		return dequeueReusableCell(withIdentifier: T.identifier) as? T
	}
}
