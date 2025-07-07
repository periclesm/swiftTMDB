//
//  MovieListView.swift
//  SwiftMovieDB SUI
//
//  Created by Pericles Maravelakis on 5/7/25.
//

import SwiftUI

struct MovieListView: View {
	var mode: ServiceMode
	
	@StateObject private var vm: MovieViewModel
	
	init(mode: ServiceMode) {
		self.mode = mode
		let service = MoviesService(service: mode)
		self._vm = StateObject(wrappedValue: MovieViewModel(service))
	}
	
	var body: some View {
		NavigationStack {
			if vm.movies.isEmpty {
				Spacer()
				VStack(spacing: 30) {
					Image(systemName: "popcorn")
						.resizable()
						.scaledToFit()
						.frame(width: 150, height: 150)
						.font(.system(size: 10, weight: .thin))
					Text(noItemsText())
						.font(.system(size: 20))
						.multilineTextAlignment(.center)
				}
				Spacer()
			} else {
				List {
					Section(header: Text(titleForHeader())) {
						ForEach(vm.movies.indices, id: \.self) { index in
							let movie = vm.movies[index]
							
							MovieItem(movie: movie, onSelect: {
								//do stuff here
							})
							.onAppear {
								fetchNextItems(at: index)
							}
						}
						.padding(.vertical, 6)
						
					}
				}
				.navigationTitle(viewTitle())
				.navigationBarTitleDisplayMode(.large)
			}
		}
		.task {
			await vm.fetchData(for: mode)
		}
	}
	
	private func viewTitle() -> String {
		switch mode {
			case .top: return "Top Rated Movies"
			case .upcoming: return "Upcoming Movies"
			case .popular: return "Popular Movies"
			case .search: return "Search"
			@unknown default: return "Movies"
		}
	}
	
	private func titleForHeader() -> String {
		if mode == .search {
			return "Total: \(vm.totalResults) movies"
		} else {
			return ""
		}
	}
	
	private func noItemsText() -> String {
		switch mode {
			case .search: return "WOOT?\nNo movies?\nGo on! Do a search!"
			default: return "No movies"
		}
	}
	
	private func fetchNextItems(at index: Int) {
		if (index == vm.movies.count-3) && (vm.movies.count < vm.totalResults) {
			vm.pageIncrement()
			switch mode {
				case .search: break
//					Task(priority: .userInitiated) {
//						if let searchTerm = searchController?.searchBar.text {
//							await vm.search(searchTerm: searchTerm)
//						}
//					}
					
				case .upcoming:
					Task(priority: .userInitiated) {
						await vm.upcoming()
					}
					
				case .top:
					Task(priority: .userInitiated) {
						await vm.top()
					}
					
				case .popular:
					Task(priority: .userInitiated) {
						await vm.popular()
					}
			}
		}
	}
}

#Preview {
	MovieListView(mode: .top)
}

struct MovieItem: View {
	let movie: Movie
	let onSelect: (() -> Void)?
	
	var body: some View {
		HStack {
			AsyncImage(url: posterURL(for: movie.posterPath)) { phase in
				switch phase {
					case .empty:
						ProgressView()
							.frame(width: 60, height: 90)
						
					case .success(let image):
						image
							.resizable()
							.scaledToFill()
							.frame(width: 60, height: 90)
							.clipped()
							.cornerRadius(4)

					case .failure(_):
						//set an error here
						Image("TMDB_poster")
							.resizable()
							.scaledToFill()
							.frame(width: 60, height: 90)
							.cornerRadius(4)
						
					@unknown default:
						Image("TMDB_poster")
							.resizable()
							.scaledToFill()
							.frame(width: 60, height: 90)
							.cornerRadius(4)
				}
			}
			
			VStack(alignment: .leading, spacing: 4) {
				Text(movie.title)
					.font(.system(size: 18, weight: .bold))
				Text("User Score: \(movie.voteAverage.percentageString) - Popularity: \(String(format: "%.1f", movie.popularity))")
					.font(.system(size: 14))
				Text("Released: \(MDDate.shared.convertDateFormat(inputString: movie.releaseDate, fromFormat: .original, toFormat: .short))")
					.font(.system(size: 13))
					.foregroundColor(.gray)
			}
			
			Spacer()
			Image(systemName: "chevron.right")
				.foregroundColor(.gray)
		}
	}
	
	private func posterURL(for posterPath: String?) -> URL? {
		guard let posterPath else { return nil }
		return DataAPI().getImageEndpoint(imagePath: posterPath, type: .poster)
	}
}
