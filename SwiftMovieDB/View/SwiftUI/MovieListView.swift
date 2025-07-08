//
//  MovieListView.swift
//  SwiftMovieDB SUI
//
//  Created by Pericles Maravelakis on 5/7/25.
//

import SwiftUI
import Kingfisher

struct MovieListView: View {
	
	var mode: ServiceMode
	@StateObject private var vm: MovieViewModel
	@State private var posterLoaded = false
	@State private var searchText: String = ""
	@State private var selectedMovie: Movie?
	
	init(mode: ServiceMode) {
		self.mode = mode
		let service = MoviesService(service: mode)
		self._vm = StateObject(wrappedValue: MovieViewModel(service))
	}
	
	var body: some View {
		VStack {
			List {
				Section(header: Text(titleForHeader())
					.font(.system(size: 13))
					.foregroundColor(.gray)) {
						ForEach(vm.movies.indices, id: \.self) { index in
							let movie = vm.movies[index]
							
							MovieItem(movie: movie, onSelect: {
								selectedMovie = movie
							})
							.onAppear {
								fetchNextItems(at: index)
							}
						}
						.padding(.vertical, 6)
					}
			}
			.listStyle(.insetGrouped)
			.navigationTitle(viewTitle())
			.navigationBarTitleDisplayMode(.large)
			.navigationDestination(item: $selectedMovie) { movie in
				MovieDetailView(movie: movie)
			}
			.if(mode == .search) { list in
				list
					.searchable(
						text: $searchText,
						placement: .navigationBarDrawer(displayMode: .always),
						prompt: "Search the Movie Database..."
					)
					.onSubmit(of: .search) {
						Task {
							vm.clearData()
							await vm.search(searchTerm: searchText)
						}
					}
					.onChange(of: searchText) { oldValue, newValue in
						if newValue.isEmpty {
							vm.clearData()
						}
					}
			}
		}
		.task(priority: .userInitiated) {
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
			return vm.movies.isEmpty ? "No results. Try another search..." : "Total: \(vm.totalResults) movies"
		} else {
			return ""
		}
	}
	
	private func fetchNextItems(at index: Int) {
		if (index == vm.movies.count-3) && (vm.movies.count < vm.totalResults) {
			vm.pageIncrement()
			switch mode {
				case .search:
					Task(priority: .userInitiated) {
						await vm.search(searchTerm: searchText)
					}
					
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
	@State private var posterLoading = true
	
	var body: some View {
		Button(action: {
			onSelect?() //Button action returns the annotation
		}) {
			HStack {
				ZStack {
					KFImage(posterURL(for: movie.posterPath))
						.placeholder {
							Image("TMDB_poster")
								.resizable()
								.scaledToFill()
								.cornerRadius(8)
						}
						.cacheOriginalImage()
						.waitForCache()
						.fade(duration: 0.5)
						.scaleFactor(UIScreen.main.scale)
						.loadDiskFileSynchronously()
						.onSuccess{ _ in posterLoading = false }
						.onFailure { error in
							posterLoading = false
							debugPrint("Error: \(error)")
						}
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(maxWidth: 60, maxHeight: 90)
						.cornerRadius(4)
						.clipped()
					
					if posterLoading {
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle(tint: .white))
					}
				}
				
				/*
				 Just leaving AsyncImage here for reference and compariston with Kingfisher.
				 Kingfisher is far superior (see caching? lol)
				 */
				
//				AsyncImage(url: posterURL(for: movie.posterPath)) { phase in
//					switch phase {
//						case .empty:
//							ZStack {
//								Image("TMDB_poster")
//									.resizable()
//									.scaledToFill()
//									.frame(width: 60, height: 90)
//									.cornerRadius(4)
//								ProgressView()
//									.progressViewStyle(CircularProgressViewStyle(tint: .white))
//							}
//							
//						case .success(let image):
//							image
//								.resizable()
//								.scaledToFill()
//								.frame(width: 60, height: 90)
//								.clipped()
//								.cornerRadius(4)
//								.opacity(posterLoaded ? 1 : 0)
//								.onAppear {
//									withAnimation(.easeInOut(duration: 0.75)) {
//										posterLoaded = true
//									}
//								}
//							
//						case .failure(_):
//							//set an error here
//							Image("TMDB_poster")
//								.resizable()
//								.scaledToFill()
//								.frame(width: 60, height: 90)
//								.cornerRadius(4)
//							
//						@unknown default:
//							Image("TMDB_poster")
//								.resizable()
//								.scaledToFill()
//								.frame(width: 60, height: 90)
//								.cornerRadius(4)
//					}
//				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text(movie.title)
						.font(.system(size: 18, weight: .bold))
						.foregroundColor(.primary)
					Text("User Score: \(movie.voteAverage.percentageString) - Popularity: \(String(format: "%.1f", movie.popularity))")
						.font(.system(size: 14))
						.foregroundColor(.primary)
					Text("Released: \(MDDate.shared.convertDateFormat(inputString: movie.releaseDate, fromFormat: .original, toFormat: .short))")
						.font(.system(size: 13))
						.foregroundColor(.gray)
				}
				
				Spacer()
				Image(systemName: "chevron.right")
					.foregroundColor(.gray)
			}
		}
	}
	
	private func posterURL(for posterPath: String?) -> URL? {
		guard let posterPath else { return nil }
		return DataAPI().getImageEndpoint(imagePath: posterPath, type: .poster)
	}
}

extension View {
	@ViewBuilder
	func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}

