//
//  MovieCell.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 3/7/25.
//

import UIKit

///Custom UITableViewCell with its IBOutlets.
class MovieCell: UITableViewCell {
	@IBOutlet weak var movieImage: UIImageView!
	@IBOutlet weak var movieTitle: UILabel!
	@IBOutlet weak var movieYear: UILabel!
	@IBOutlet weak var movieDetail: UILabel!
}
