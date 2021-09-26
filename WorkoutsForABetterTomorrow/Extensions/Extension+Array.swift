//
//  Extension+Array.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import Foundation

extension Array {
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
