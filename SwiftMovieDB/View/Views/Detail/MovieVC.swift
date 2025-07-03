//
//  MovieVC.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import UIKit

/**
 This is a straightforward VC, used only to display the movie information.
 No further actions or user input is needed.
 */
class MovieVC: UITableViewController {
	
	var vm: MovieVM!
	
	@IBOutlet weak var backImage: UIImageView!
	@IBOutlet weak var movieImage: UIImageView!
	@IBOutlet weak var movieTitle: UILabel!
	@IBOutlet weak var movieReleaseDate: UILabel!
	@IBOutlet weak var movieDescription: UILabel!
	@IBOutlet weak var movieRatings: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }
	
	private func setupUI() {
		title = vm.movie?.title
		movieTitle.text = vm.movie?.title
		movieReleaseDate.text = vm.releaseDateString()
		movieDescription.text = vm.movie?.overview
		movieRatings.text = vm.ratingsString()
		
		ImageManager().setImage(into: backImage, from: vm.movie?.backdropPath, type: .backdrop)
		ImageManager().setImage(into: movieImage, from: vm.movie?.posterPath)
	}
}
