//
//  MovieListProtocol.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import Foundation

protocol MovieListProtocol {
	func searchMovies(searchTerm: String, page: Int) async -> MovieList?
	func getTopRated(page: Int) async -> MovieList?
	func getUpcoming(page: Int) async -> UpcomingMovies?
	func getPopular(page: Int) async -> MovieList? 
}

/*
 The following extension is to make protocol functions optional.
 Two choices here:
 a) either uncomment the following and add the necessary protocol functions manually (warning: mistakes can easily be made) or
 b) leave the extension commented and add all 3 stubs where needed. Return [] where the function is not necessary. (mistakes averted this way)
 */

//extension MovieListProtocol {
//	func getMovies(searchTerm: String?, page: Int) async -> MovieDataType { return [] }
//	func getTopRated() {}
//	func getUpcoming() {}
//}
