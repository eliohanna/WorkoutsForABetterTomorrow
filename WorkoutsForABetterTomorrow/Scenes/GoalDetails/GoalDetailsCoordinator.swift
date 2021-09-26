//
//  GoalDetailsCoordinator.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit
import SwiftUI

class GoalDetailsCoordinator {

	weak var rootViewController: UIViewController?
	private let goalDetails: Goal
	
	init(rootViewController: UIViewController, goalDetails: Goal) {
		self.rootViewController = rootViewController
		self.goalDetails = goalDetails
	}
	
	func start() {
		let view = GoalDetailsView(viewModel: .init(healthSummaryUseCase: DefaultHealthSummaryUseCase(),
													currentGoal: self.goalDetails))
		let viewController = UIHostingController(rootView: view)
		rootViewController?.navigationController?.pushViewController(viewController, animated: true)
	}
}
