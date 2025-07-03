//
//  MoviesService.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 10/6/25.
//

enum ServiceMode {
	case search, top, upcoming, popular
}

import Foundation

class MoviesService: MovieListProtocol, @unchecked Sendable {
	private var movieService: Any
	
	init(service: ServiceMode) {
		switch service {
			case .search:
				movieService = SearchService()
				
			case .top:
				movieService = TopRatedService()
				
			case .upcoming:
				movieService = UpcomingService()
				
			case .popular:
				movieService = PopularService()
		}
	}
	
	//Data fetching functions per service
	
	func searchMovies(searchTerm: String, page: Int) async -> MovieList? {
		let service = movieService as! SearchService
		return await service.searchMovies(searchTerm: searchTerm, page: page)
	}
	
	func getTopRated(page: Int) async -> MovieList? {
		let service = movieService as! TopRatedService
		return await service.getTopRated(page: page)
	}
	
	func getUpcoming(page: Int) async -> UpcomingMovies? {
		let service = movieService as! UpcomingService
		return await service.getUpcoming(page: page)
	}
	
	func getPopular(page: Int) async -> MovieList? {
		let service = movieService as! PopularService
		return await service.getPopular(page: page)
	}
}
