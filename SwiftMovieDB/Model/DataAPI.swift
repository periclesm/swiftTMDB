//
//  DataAPI.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import UIKit

/**
 Contains tha necessary information and functions to connect with the Movie Database API and retrieve data.
 It constructs the URL to call in order to fetch the required dataset (search, top rated, upcoming etc) by adding required query items.
 It also creates the URLRequest, setting the cache policy and the header containing the authentication information.
 Also includes a decode function for the request response data to be parsed and used in the app.
 */

class DataAPI: NSObject {
	
	/*
	 Create a free account in MovieDb (https://www.themoviedb.org/) and get your API Read Access (Bearer) token key from account settings.
	 Add your API key below to run the app.
	 */
	
	var token = <#T##Insert your API KEY here#>
	
	func getRequest(url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.timeoutInterval = 10
		request.cachePolicy = .reloadRevalidatingCacheData
		request.allHTTPHeaderFields = [
			"accept": "application/json",
			"Authorization": "Bearer \(token)"
		]
		
		return request
	}
	
	/**
	 Creates the search movie API endpoint.
	 - Parameter searchTerm: **`String`** The movie title to be used for the search.
	 - Parameter page: **`Int`** The page of the search. Defaults to page 1 when the search is done for the first time.
	 - Returns: **`URL`** The url to be used in Network module.
	 */
	func getSearchEndoint(searchTerm: String, page: Int = 1) -> URL {		
		let url = URL(string: "https://api.themoviedb.org/3/search/movie")!
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "include_adult", value: "false"),
			URLQueryItem(name: "language", value: "en-US"),
			URLQueryItem(name: "page", value: "\(page)"),
			URLQueryItem(name: "query", value: "\(searchTerm)"),
		]
		
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
		return components.url!
	}
	
	/**
	 Creates the Top Rated movies API endpoint.
	 - Parameter page: **`Int`** The page of the search. Defaults to page 1 when the search is done for the first time.
	 - Returns: **`URL`** The url to be used in Network module.
	 */
	func getTopRatedEndpoint(page: Int = 1) -> URL {
		let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated")!
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "language", value: "en-US"),
			URLQueryItem(name: "page", value: "\(page)"),
		]
		
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
		return components.url!
	}
	
	/**
	 Creates the upcoming movies API endpoint.
	 - Parameter page: **`Int`** The page of the search. Defaults to page 1 when the search is done for the first time.
	 - Returns: **`URL`** The url to be used in Network module.
	 */
	func getUpcomingEndpoint(page: Int = 1) -> URL {
		let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming")!
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "language", value: "en-US"),
			URLQueryItem(name: "page", value: "\(page)"),
		]
		
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
		return components.url!
	}
	
	/**
	 Creates the popular movies API endpoint.
	 - Parameter page: **`Int`** The page of the search. Defaults to page 1 when the search is done for the first time.
	 - Returns: **`URL`** The url to be used in Network module.
	 */
	func getPopularEndpoint(page: Int = 1) -> URL {
		let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "language", value: "en-US"),
			URLQueryItem(name: "page", value: "\(page)"),
		]
		
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
		return components.url!
	}
	
	/**
	 Creates the image API endpoint.
	 TMDB provides only the image filename so to retrieve the actual image, the root URL must be appended.
	 
	 w(number) determines the width of the image. By selecting only the width it scales the image AND keeps the proper ratio.
	 
	 - Parameter imagePath: String The path (/) and the filename of the requested image.
	 - Parameter type: Int Specifies whether the image is a movie poster or a backdrop.
	 - Returns: `URL` The url to be used in Network module.
	 */
	func getImageEndpoint(imagePath: String, type: ImageType? = .poster) -> URL? {
		var endpoint = ""
		
		switch type {
		case .backdrop:
			endpoint = String(format: "https://www.themoviedb.org/t/p/w780%@", imagePath)
			
		default:
			endpoint = String(format: "https://www.themoviedb.org/t/p/w342%@", imagePath)
		}
			
		return URL(string: endpoint)
	}
	
	/**
	 This is a utility function that decodes input `Data` into the type specified when callingit i.e. `let list: Array<Object> = decodeJSON(responseData: data).
	 It will also debug print the error if decoding is not possible giving a heads up on what causes the decoder to fail (example, having a nil value assigned on a required property).
	 */
	func decodeJSON<T: Decodable>(responseData: Data?, strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T? {
		guard let data = responseData else {
			//throw Error()
			return nil
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = strategy
		
		do {
			return try decoder.decode(T.self, from: data)
		} catch let DecodingError.dataCorrupted(context) {
			debugPrint(context)
		} catch let DecodingError.keyNotFound(key, context) {
			debugPrint("Key '\(key)' not found:", context.debugDescription)
			debugPrint("codingPath:", context.codingPath)
		} catch let DecodingError.valueNotFound(value, context) {
			debugPrint("Value '\(value)' not found:", context.debugDescription)
			debugPrint("codingPath:", context.codingPath)
		} catch let DecodingError.typeMismatch(type, context) {
			debugPrint("Type '\(type)' mismatch:", context.debugDescription)
			debugPrint("codingPath:", context.codingPath)
		} catch {
			debugPrint("Error decoding JSON: \(error)")
			//throw error
		}
		
		return nil
	}
}
