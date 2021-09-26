//
//  NetworkService.swift
//  WorkoutsForABetterTomorrow
//
//  Created by ElioHanna on 25/09/2021.
//

import Foundation
import Combine

/// This is a simple `NetworkingService` for the purpose of this demo
/// This could be improved for more powerful customization, but for the sake of demo, a toned down version was created
class NetworkService {
	private let baseURL: URL
	
	init(baseURL: URL) {
		self.baseURL = baseURL
	}
	
	private func fullPath(to path: String) -> URL {
		baseURL.appendingPathComponent(path)
	}
	
	private func createUrlRequest(location: URL) -> URLRequest {
		URLRequest(url: location)
	}
	
	func dial<T: Decodable>(path: String) -> AnyPublisher<T, Error> {
		let location = fullPath(to: path)
		let request = createUrlRequest(location: location)
		return call(request)
	}
	
	private func call<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		let publisher = URLSession.shared.dataTaskPublisher(for: request)
			.map({ $0.data })
			.decode(type: T.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
		
		return publisher
	}
}
