//
//  Extension+Goal.swift
//  WorkoutsForABetterTomorrowTests
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation
@testable import WorkoutsForABetterTomorrow

extension GoalType: CaseIterable {
	public static var allCases: [GoalType] { [.step, .walkingDistance, .runningDistance] }
	
	static var randomElement: GoalType {
		return allCases[Int.random(in: 0..<allCases.count)]
	}
}

extension GoalTrophy: CaseIterable {
	public static var allCases: [GoalTrophy] { [.bronzeMedal, .silverMedal, .goldMedal, .zombieHand] }
	
	static var randomElement: GoalTrophy {
		return allCases[Int.random(in: 0..<allCases.count)]
	}
}

extension Goal {
	static var goal: Goal {
		return .init(id: Int.random(in: 1..<10000),
					 goal: Double.random(in: 1..<100),
					 description: "Goal description",
					 title: "Goal title",
					 type: .randomElement,
					 reward: .init(trophy: .randomElement,
								   points: Int.random(in: 1..<50)))
	}
	
	static var mockGoals: [Goal] {
		return Array(repeating: goal, count: Int.random(in: 1..<5))
	}
}
