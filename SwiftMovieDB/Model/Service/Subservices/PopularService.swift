//
//  PopularService.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 11/6/25.
//

import Foundation

class PopularService: MovieListProtocol, @unchecked Sendable {
	
	/*
	 Fetching the service data. Checks for status code and errs if not 200(OK)
	 Data are returned decoded to the requested type.
	 */
	
	func getPopular(page: Int) async -> MovieList? {
		let api = DataAPI()
		let request = api.getRequest(url: api.getPopularEndpoint(page: page))
		
		do {
			let responseData: (Data, URLResponse) = try await URLSession.shared.data(for: request)
			if let statusCode = (responseData.1 as? HTTPURLResponse)?.statusCode {
				if statusCode == 200 {
					let data: MovieList? = try api.decodeJSON(responseData: responseData.0, strategy: .convertFromSnakeCase)
					return data
				}
				else {
					debugPrint("Service error: Status code: \(statusCode)")
				}
			}
		} catch {
			debugPrint("Error: \(error)")
		}
		
		return nil
	}
	
	//MARK: - Unused stubs
	func searchMovies(searchTerm: String, page: Int) async -> MovieList? {
		return nil
	}
	
	func getUpcoming(page: Int) async -> UpcomingMovies? {
		return nil
	}
	
	func getTopRated(page: Int) async -> MovieList? {
		return nil
	}
}
