//
//  MovieList.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 10/6/25.
//

import Foundation

struct MovieList: Codable {
	var page: Int
	var results: MovieDataType
	var totalPages: Int
	var totalResults: Int
}
