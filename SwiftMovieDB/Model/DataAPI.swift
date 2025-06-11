//
//  DataAPI.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import UIKit

class DataAPI: NSObject {
	
	/*
	 Create an account in MovieDb (https://www.themoviedb.org/) and get your API Read Access (Bearer) token key from account settings.
	 Add your API key below to use the app.
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
	 - Parameter searchTerm: String The search string the user typed.
	 - Parameter page: Int The page of the search. Defaults to page 1 when the search is done for the first time.
	 - Returns: `URL` The url to be used in Network module.
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
	
	func decodeJSON<T: Decodable>(responseData: Data?, strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T? {
		guard let data = responseData else {
			//throw Error()
			return nil
		}
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = strategy
		
		do {
			return try decoder.decode(T.self, from: data)
		}
		catch let DecodingError.dataCorrupted(context) {
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
