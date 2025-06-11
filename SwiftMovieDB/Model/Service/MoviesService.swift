//
//  MoviesService.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 10/6/25.
//

import Foundation

class MoviesService: MovieListProtocol, @unchecked Sendable {
	private let searchMovies: SearchService
	private let topRated: TopRatedService
	private let upcoming: UpcomingService
	private let popular: PopularService
	
	init(searchMovies: SearchService, topRated: TopRatedService, upcoming: UpcomingService, popular: PopularService) {
		self.searchMovies = searchMovies
		self.topRated = topRated
		self.upcoming = upcoming
		self.popular = popular
	}
	
	func searchMovies(searchTerm: String, page: Int) async -> MovieList? {
		return await searchMovies.searchMovies(searchTerm: searchTerm, page: page)
	}
	
	func getTopRated(page: Int) async -> MovieList? {
		return await topRated.getTopRated(page: page)
	}
	
	func getUpcoming(page: Int) async -> UpcomingMovies? {
		return await upcoming.getUpcoming(page: page)
	}
	
	func getPopular(page: Int) async -> MovieList? {
		return await popular.getPopular(page: page)
	}
}
