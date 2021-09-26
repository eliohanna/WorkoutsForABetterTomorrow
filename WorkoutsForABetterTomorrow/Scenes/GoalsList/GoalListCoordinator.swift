//
//  GoalListCoordinator.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import UIKit

class GoalListCoordinator {
	private let window: UIWindow
	private weak var rootViewController: UIViewController?
	
	init(window: UIWindow) {
		self.window = window
	}
	
	func start() {
		guard let baseURL = Constants.baseURL else { return }
		let goalsUseCase = DefaultGoalsFetchingUseCase(baseURL: baseURL)
		let viewModel = GoalsListViewModel(coordinator: self,
										   goalsFetchingUseCase: goalsUseCase,
										   healthSummaryUseCase: DefaultHealthSummaryUseCase())
		
		let viewController = GoalsListViewController.create(viewModel: viewModel)
		rootViewController = viewController
		
		window.rootViewController = UINavigationController(rootViewController: viewController)
		window.makeKeyAndVisible()
	}
	
	func routeToGoalDetails(with goalDetails: Goal) {
		guard let rootViewController = rootViewController else { return }
		GoalDetailsCoordinator(rootViewController: rootViewController, goalDetails: goalDetails).start()
	}
}
