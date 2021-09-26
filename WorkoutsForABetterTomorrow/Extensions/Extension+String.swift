//
//  Extension+String.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation

extension String {
	var camelCaseStringFromSnakeCase: String {
		return split(separator: "_").reduce("", { $0 + $1.capitalized })
	}
}
