//
//  SearchMoviesService.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import Foundation

class SearchService: MovieListProtocol, @unchecked Sendable {

	func searchMovies(searchTerm: String, page: Int) async -> MovieList? {		
		let api = DataAPI()
		let request = api.getRequest(url: api.getSearchEndoint(searchTerm: searchTerm, page: page))
		
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
	func getTopRated(page: Int) async -> MovieList? {
		return nil
	}
	
	func getUpcoming(page: Int) async -> UpcomingMovies? {
		return nil
	}
	
	func getPopular(page: Int) async -> MovieList? {
		return nil
	}
}
