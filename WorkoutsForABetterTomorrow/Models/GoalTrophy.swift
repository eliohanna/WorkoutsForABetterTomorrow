//
//  GoalTrophy.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

enum GoalTrophy: String {
	case bronzeMedal = "bronze_medal"
	case silverMedal = "silver_medal"
	case goldMedal = "gold_medal"
	case zombieHand = "zombie_hand"
	
	var image: UIImage? {
		switch self {
		case .bronzeMedal:
			return UIImage(named: "bronze")
		case .silverMedal:
			return UIImage(named: "silver")
		case .goldMedal:
			return UIImage(named: "gold")
		case .zombieHand:
			return UIImage(named: "zombie")
		}
	}
}
