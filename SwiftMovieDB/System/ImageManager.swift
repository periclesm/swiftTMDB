//
//  ImageManager.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import UIKit
import Kingfisher

/**
 A wrapper with default options for Kingfisher image downloader.
 */

class ImageManager: NSObject {
	
	@MainActor
	func setImage(into imageView: UIImageView, from urlString: String?, type: ImageType = .poster) {
		guard let urlString else {
			imageView.image = defaultImage(type)
			return
		}
		
		let imageURL = DataAPI().getImageEndpoint(imagePath: urlString, type: type)
		let processor = ResizingImageProcessor(referenceSize: imageView.bounds.size, mode: .aspectFill)
		
		let options: KingfisherOptionsInfo = [
			.cacheOriginalImage,
			.waitForCache,
			.processor(processor),
			.backgroundDecode,
			.transition(.fade(0.25)),
			.scaleFactor(UIScreen.main.scale),
			.loadDiskFileSynchronously
		]
		
		imageView.kf.indicatorType = .activity
		imageView.kf.setImage(
			with: imageURL,
			options: options) { result in
				switch result {
					case .success (_):
						break
					case .failure:
						imageView.image = self.defaultImage(type)
				}
			}
	}
	
	private func defaultImage(_ type: ImageType) -> UIImage? {
		switch type {
			case .backdrop: return UIImage(named: "TMDB_backdrop")
			default: return UIImage(named: "TMDB_poster")
		}
	}
}
