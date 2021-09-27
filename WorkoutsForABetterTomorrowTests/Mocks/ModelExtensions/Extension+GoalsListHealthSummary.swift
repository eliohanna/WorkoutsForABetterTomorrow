//
//  Extension+GoalsListHealthSummary.swift
//  WorkoutsForABetterTomorrowTests
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation
@testable import WorkoutsForABetterTomorrow

extension GoalsListHealthSummary {
	static var mock: GoalsListHealthSummary {
		return .init(steps: Double.random(in: 1..<1000),
					 walkingDistance: Double.random(in: 1..<400),
					 runningDistance: Double.random(in: 1..<100))
	}
}
