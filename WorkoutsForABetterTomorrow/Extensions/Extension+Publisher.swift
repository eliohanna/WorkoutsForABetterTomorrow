//
//  Extension+Publisher.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 26/09/2021.
//

import Foundation
import Combine

extension Publisher {
	public func assign(to subject: CurrentValueSubject<Self.Output, Self.Failure>) -> AnyCancellable {
		sink(receiveCompletion: { completion in
			subject.send(completion: completion)
		}, receiveValue: { value in
			subject.send(value)
		})
	}
}

extension Publisher where Self.Failure == Never {
	public func assignNoRetain<Root>(
		to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
		on object: Root
	) -> AnyCancellable where Root: AnyObject {
		sink { [weak object] (value) in
			object?[keyPath: keyPath] = value
		}
	}
}
