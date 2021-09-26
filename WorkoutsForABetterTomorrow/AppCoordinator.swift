//
//  AppCoordinator.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

class AppCoordinator {
	private let window: UIWindow
	
	init(window: UIWindow) {
		self.window = window
	}
	
	func start() {
		GoalListCoordinator(window: window).start()
	}
}
