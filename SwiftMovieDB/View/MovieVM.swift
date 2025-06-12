//
//  MovieVM.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import UIKit

/*
 Practically speaking, this VM serves only as datastore of a single movie (the one user selected) and its data transformation functions.
 */
class MovieVM: NSObject {
		
	///Object to contain the user selected movie.
	var movie: Movie? = nil

	func subtitleString() -> String {
		var subtitle = ""
		subtitle.append(contentsOf: MDDate.shared.convertDateFormat(inputString: self.movie?.releaseDate, fromFormat: .original, toFormat: .formatted))
		
		let genres = "Add genre" //GenreController.getMovieGenres(self.movie)
		genres.isEmpty ? nil : subtitle.append(contentsOf: " • \(genres)")
		
		return subtitle
	}
	
	func releaseDateString() -> String {
		let formattedDate = MDDate.shared.convertDateFormat(inputString: self.movie?.releaseDate, fromFormat: .original, toFormat: .formatted)
		return "Release Date: \(formattedDate)"
	}
	
	func genresString() -> String {
		return "add genre" //GenreController.getMovieGenres(self.movie)
	}
	
	func ratingsString() -> String {
		var rating = ""
		rating.append(contentsOf: "⭐️ \(movie?.voteAverage.percentageString ?? "0")")
		rating.append(contentsOf: " • \(movie?.voteCount ?? 0) votes")
		return rating
	}
}
