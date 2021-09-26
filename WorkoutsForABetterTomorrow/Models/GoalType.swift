//
//  GoalType.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

enum GoalType: String {
	case step
	case walkingDistance = "walking_distance"
	case runningDistance = "running_distance"
	
	var image: UIImage? {
		switch self {
		case .step:
			return UIImage(named: "step")
		case .walkingDistance:
			return UIImage(named: "walking")
		case .runningDistance:
			return UIImage(named: "running")
		}
	}
}
