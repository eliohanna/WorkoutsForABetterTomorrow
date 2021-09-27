//
//  MockGoalsFetchingUseCase.swift
//  WorkoutsForABetterTomorrowTests
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation
import Combine
@testable import WorkoutsForABetterTomorrow

class MockGoalsFetchingUseCase: GoalsFetchingUseCase {
	private var cancellableSet: Set<AnyCancellable> = Set()
	private let goalsSubject = CurrentValueSubject<[Goal], Error>([])
	var goalsPublisher: AnyPublisher<[Goal], Error> { goalsSubject.eraseToAnyPublisher() }
	
	let expectedResult = CurrentValueSubject<[Goal], Error>([])
	
	func performFetch() {
		expectedResult
			.replaceError(with: [])
			.sink(receiveValue: { [weak self] goals in
				self?.goalsSubject.send(goals)
			})
			.store(in: &cancellableSet)
	}
}
