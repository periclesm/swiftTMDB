//
//  Movie.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import Foundation

typealias MovieDataType = Array<Movie>

struct Movie: Codable, Identifiable {
	var id: Int
	var title: String?
	var overview: String?
	var releaseDate: String?
	var posterPath: String?
	var backdropPath: String?
	var popularity: Float
	var voteAverage: Float
	var voteCount: Int
}
