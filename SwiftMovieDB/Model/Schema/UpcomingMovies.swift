//
//  UpcomingMovies.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 10/6/25.
//

import Foundation

struct UpcomingMovies: Codable {
	var dates: UpcomingMoviesDates
	var page: Int?
	var results: MovieDataType?
	var totalPages: Int?
	var totalResults: Int?
}

struct UpcomingMoviesDates: Codable {
	var maximum: String?
	var minimum: String?
}
