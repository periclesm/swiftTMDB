//
//  MovieDetailView.swift
//  SwiftMovieDB SUI
//
//  Created by Pericles Maravelakis on 8/7/25.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
	var movie: Movie?
	@State private var posterLoading = true
	@State private var backdropLoading = true
	
	var title: String {
		movie?.title ?? "Movie"
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			
			//Top Backdrop
			ZStack {
				KFImage(posterURL(for: movie?.backdropPath))
					.placeholder {
						Image("TMDB_backdrop")
							.resizable()
							.scaledToFill()
							.cornerRadius(8)
					}
					.cacheOriginalImage()
					.waitForCache()
					.fade(duration: 0.5)
					.scaleFactor(UIScreen.main.scale)
					.loadDiskFileSynchronously()
					.onSuccess({ _ in backdropLoading = false })
					.onFailure { error in
						debugPrint("Error: \(error)")
						backdropLoading = false
					}
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(maxWidth: .infinity, maxHeight: 220)
					.cornerRadius(8)
					.clipped()
				
				if backdropLoading {
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle(tint: .primary))
						.scaleEffect(1.5)
				}
			}
						
			HStack(alignment: .center, spacing: 10) {
				
				//Movie poster
				ZStack {
					KFImage(posterURL(for: movie?.posterPath))
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
						.frame(maxWidth: 80, maxHeight: 120)
						.cornerRadius(8)
						.clipped()
					
					if posterLoading {
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle(tint: .white))
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
			.padding(.horizontal, 5)
			
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
		.navigationTitle(title)
		.navigationBarTitleDisplayMode(.inline)
	}
	
	//MARK: - Functions
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

