//
//  MockHealthSummaryUseCase.swift
//  WorkoutsForABetterTomorrowTests
//
//  Created by ElioHanna on 27/09/2021.
//

import Foundation
@testable import WorkoutsForABetterTomorrow
import Combine

class MockHealthSummaryUseCase: HealthSummaryUseCase {
	private var cancellableSet: Set<AnyCancellable> = Set()
	private let healthSummarySubject = CurrentValueSubject<GoalsListHealthSummary?, Error>(nil)
	var healthSummaryPublisher: AnyPublisher<GoalsListHealthSummary?, Error> { healthSummarySubject.eraseToAnyPublisher() }
	
	let expectedResult = CurrentValueSubject<GoalsListHealthSummary?, Error>(nil)
	
	func performFetch() {
		expectedResult
			.replaceError(with: nil)
			.sink(receiveValue: { [weak self] healthSummary in
				self?.healthSummarySubject.send(healthSummary)
			})
			.store(in: &cancellableSet)
	}
}
