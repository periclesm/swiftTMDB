//
//  MovieListVM.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 2/7/25.
//

import Foundation

class MovieViewModel: NSObject {
	
	private let service: MoviesService
	
	///Fallback closure on View Controller to update data on tableview.
	var onDataUpdate: (() -> Void)?
	
	///Dataset for all movies to be displayed. THis may contain search movie results, top-rated movies etc.
	private(set) var movies: MovieDataType = []
	
	///The current page index.
	var currentPage = 1
	
	///Total number of pages as returned by TMDB.
	var totalPages = 0
	
	///Total number of results (movies) as returned by TMDB.
	var totalResults = 0
	
	init(_ service: MoviesService) {
		self.service = service
	}
	
	//MARK: - Data Functions
	
	///Clears all data from datastore and resets counters.
	func clearData() {
		movies.removeAll()
		currentPage = 1
		totalPages = 0
		totalResults = 0
	}
	
	///Performs the search with the given term.
	@MainActor
	func search(searchTerm: String?) async {
		guard let searchTerm else {
			assert(true, "OK listen! Although searchTerm is optional, make sure not to call this func when it's empty or nil, OK?")
			return
		}
		
		if !searchTerm.isEmpty {
			debugPrint("Searching for \(searchTerm) on page \(currentPage)...")
			let data = await service.searchMovies(searchTerm: searchTerm, page: currentPage)
			/**
			 Note: tmdb does not sort results. In order to do so, some caching needs to be done, sorting and selecting data to present
			 */
			if let movieData = data?.results/*.sorted(by: { $0.popularity > $1.popularity })*/ {
				totalPages = data?.totalPages ?? 0
				totalResults = data?.totalResults ?? 0
				movies.append(contentsOf: movieData)
				
				await MainActor.run {
					onDataUpdate?()
				}
			}
		}
	}
	
	@MainActor
	func fetchData(for service: ServiceMode) async {
		switch service {
			case .top:
				await top()
				
			case .upcoming:
				await upcoming()
				
			case .popular:
				await popular()
				
			case .search:
				//no need to fetch data at start here
				break
				
			@unknown default:
				fatalError("Unknown service mode!")
		}
	}
	
	///Returns the Top-Voted movies from TMDB.
	@MainActor
	func top() async {
		let data = await service.getTopRated(page: currentPage)
		if let movieData = data?.results {
			totalPages = data?.totalPages ?? 0
			totalResults = data?.totalResults ?? 0
			movies.append(contentsOf: movieData)
			
			await MainActor.run {
				onDataUpdate?()
			}
		}
	}
	
	///Returns upcoming movies from TMDB.
	@MainActor
	func upcoming() async {
		let data = await service.getUpcoming(page: currentPage)
		if let movieData = data?.results {
			totalPages = data?.totalPages ?? 0
			totalResults = data?.totalResults ?? 0
			movies.append(contentsOf: movieData)
			
			await MainActor.run {
				onDataUpdate?()
			}
		}
	}
	
	///Returns popular movies.
	@MainActor
	func popular() async {
		let data = await service.getPopular(page: currentPage)
		if let movieData = data?.results {
			totalPages = data?.totalPages ?? 0
			totalResults = data?.totalResults ?? 0
			movies.append(contentsOf: movieData)
			
			await MainActor.run {
				onDataUpdate?()
			}
		}
	}
	
	///Increments the pageIndex up to the count of total pages as reported by the API.
	func pageIncrement() {
		if currentPage < totalPages {
			currentPage += 1
		}
	}
}
