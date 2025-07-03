//
//  MainVC.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 1/7/25.
//

import UIKit

class MainVC: UIViewController {
	
	@IBOutlet weak var topMoviesButton: UIButton!
	@IBOutlet weak var upcomingMoviesButton: UIButton!
	@IBOutlet weak var popularMoviesButton: UIButton!
	@IBOutlet weak var searchMoviesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.destination {
			case let dvc as MovieListVC:
				if let mode = sender as? ServiceMode {
					dvc.mode = mode
				}
				
			default:
				break
		}
	}
	
	@IBAction func topMoviesAction() {
		performSegue(withIdentifier: "MovieListSegue", sender: ServiceMode.top)
	}
	
	@IBAction func upcomingMoviesAction() {
		performSegue(withIdentifier: "MovieListSegue", sender: ServiceMode.upcoming)
	}
		
	@IBAction func popularMoviesAction() {
		performSegue(withIdentifier: "MovieListSegue", sender: ServiceMode.popular)
	}
	
	@IBAction func searchAction() {
		performSegue(withIdentifier: "MovieListSegue", sender: ServiceMode.search)
	}
}
