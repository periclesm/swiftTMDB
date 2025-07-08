//
//  MovieDetailView.swift
//  SwiftMovieDB SUI
//
//  Created by Pericles Maravelakis on 8/7/25.
//

import SwiftUI

struct MovieDetailView: View {
	var movie: Movie?
	@State private var posterLoaded = false
	@State private var backdropLoaded = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			
			//Top Backdrop
			AsyncImage(url: posterURL(for: movie?.backdropPath)) { phase in
				switch phase {
					case .empty:
						ZStack {
							Image("TMDB_backdrop")
								.resizable()
								.scaledToFill()
								.frame(maxWidth: .infinity, maxHeight: 220)
								.aspectRatio(16/9, contentMode: .fit)
								.cornerRadius(8)
								.clipped()
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle(tint: .white))
								.scaleEffect(1.5)
						}
						
					case .success(let image):
						image
							.resizable()
							.scaledToFill()
							.frame(maxWidth: .infinity, maxHeight: 220)
							.aspectRatio(16/9, contentMode: .fit)
							.cornerRadius(8)
							.clipped()
							.opacity(backdropLoaded ? 1 : 0)
							.onAppear {
								withAnimation(.easeInOut(duration: 0.75)) {
									backdropLoaded = true
								}
							}
						
					case .failure(_):
						//set an error here
						Image("TMDB_backdrop")
							.resizable()
							.scaledToFill()
							.frame(maxWidth: .infinity, maxHeight: 220)
							.aspectRatio(16/9, contentMode: .fit)
							.cornerRadius(8)
							.clipped()
						
					@unknown default:
						Image("TMDB_backdrop")
							.resizable()
							.scaledToFill()
							.frame(maxWidth: .infinity, maxHeight: 220)
							.aspectRatio(16/9, contentMode: .fit)
							.cornerRadius(8)
							.clipped()
				}
			}
			
			HStack(alignment: .center, spacing: 10) {
				
				//Movie poster
				AsyncImage(url: posterURL(for: movie?.posterPath)) { phase in
					switch phase {
						case .empty:
							ZStack {
								Image("TMDB_poster")
									.resizable()
									.scaledToFill()
									.frame(width: 80, height: 120)
									.cornerRadius(8)
								ProgressView()
									.progressViewStyle(CircularProgressViewStyle(tint: .white))
							}
							
						case .success(let image):
							image
								.resizable()
								.scaledToFill()
								.frame(width: 80, height: 120)
								.clipped()
								.cornerRadius(8)
								.opacity(posterLoaded ? 1 : 0)
								.onAppear {
									withAnimation(.easeInOut(duration: 0.75)) {
										posterLoaded = true
									}
								}
							
						case .failure(_):
							//set an error here
							Image("TMDB_poster")
								.resizable()
								.scaledToFill()
								.frame(width: 80, height: 120)
								.cornerRadius(8)
							
						@unknown default:
							Image("TMDB_poster")
								.resizable()
								.scaledToFill()
								.frame(width: 80, height: 120)
								.cornerRadius(4)
					}
				}
				
				VStack (alignment: .leading, spacing: 5) {
					Text("\(movie?.title ?? "Title")")
						.font(.system(size: 28, weight: .bold))
					Text(releaseDateString())
						.font(.system(size: 15))
					Text(ratingsString())
						.font(.system(size: 13))
				}
			}
			
			VStack(alignment: .leading, spacing: 20) {
				Text("Overview".uppercased())
					.font(.system(size: 14, weight: .medium))
					.foregroundColor(.gray)
					
				Text("\(movie?.overview ?? "No overview available")")
					.font(.system(size: 15))
			}
			.padding(.top, 20)
			.padding(.horizontal, 10)
			
			Spacer()
		}
		.padding(.horizontal, 5)
		.padding(.top, 30)
		.navigationTitle("\(movie?.title ?? "Movie Title")")
		.navigationBarTitleDisplayMode(.inline)
	}
	
	private func releaseDateString() -> String {
		let formattedDate = MDDate.shared.convertDateFormat(inputString: self.movie?.releaseDate, fromFormat: .original, toFormat: .formatted)
		return "Release Date: \(formattedDate)"
	}
	
	private func ratingsString() -> String {
		var rating = ""
		rating.append(contentsOf: "⭐️ \(movie?.voteAverage.percentageString ?? "0")")
		rating.append(contentsOf: " • \(movie?.voteCount ?? 0) votes")
		return rating
	}
	
	private func posterURL(for posterPath: String?) -> URL? {
		guard let posterPath else { return nil }
		return DataAPI().getImageEndpoint(imagePath: posterPath, type: .poster)
	}
}

#Preview {
	MovieDetailView()
}

