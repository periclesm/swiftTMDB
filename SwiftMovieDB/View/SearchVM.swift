//
//  SearchVM.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import UIKit

enum MoviesMode {
	case search, top, upcoming, popular
}

class SearchVM: NSObject {
	
	private let service: MoviesService
	
	var mode: MoviesMode = .search
	
	///Array with all movies to be used in UITableView cells.
	private(set) var movies: MovieDataType = []
	
	///The current page index.
	var currentPage = 1
	var totalPages = 0
	var totalResults = 0
	
	var onDataUpdate: (() -> Void)?
	
	init(service: MoviesService) {
		self.service = service
	}
	
	///Clears all data from VM and DataStore and resets counters.
	func clearData() {
		movies.removeAll()
		currentPage = 1
		totalPages = 0
		totalResults = 0
	}
	
	/**
	 Performs the search and fills the movies array with results
	 Completion, if successful, will reload the UITableView and display what has been fetched.
	 */
	
	@MainActor
	func search(searchTerm: String?) async {
		guard let searchTerm else {
			assert(true, "OK listen! Although searchTerm is optional, make sure not to call this func when it's empty or nil, right?")
			return
		}
		
		if !searchTerm.isEmpty {
			mode = .search
			
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
	func top() async {
		mode = .top
		
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
	
	@MainActor
	func upcoming() async {
		mode = .upcoming
		
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
	
	@MainActor
	func popular() async {
		mode = .popular
		
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
	
	///Increments the pageIndex up to the count of total pages as reported in the API payload.
	func pageIncrement() {
		if currentPage < totalPages {
			currentPage += 1
		}
	}
}
