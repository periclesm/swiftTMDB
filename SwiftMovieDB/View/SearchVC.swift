//
//  SearchVC.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import UIKit

///Custom UITableViewCell with its IBOutlets.
class MovieCell: UITableViewCell {
	@IBOutlet weak var movieImage: UIImageView!
	@IBOutlet weak var movieTitle: UILabel!
	@IBOutlet weak var movieYear: UILabel!
	@IBOutlet weak var movieDetail: UILabel!
}

class SearchVC: UITableViewController {
	
	//View displaying content when there are no data in the UITableView
	@IBOutlet weak var backgroundView: UIView!
	
	private let searchController = UISearchController(searchResultsController: nil)
	
	///Initialize the View Model
	private var vm: SearchVM!

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		bindVM()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "DetailSegue" {
			let dvc = segue.destination as! MovieVC
			if let object = sender as? Movie {
				dvc.vm = MovieVM()
				dvc.vm.movie = object
			}
		}
	}
	
	private func setupUI() {
		self.tableView.backgroundView = backgroundView
		navigationItem.hidesSearchBarWhenScrolling = false
		navigationItem.backButtonDisplayMode = .minimal
		
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "search the Movie Database"
		searchController.searchBar.delegate = self
		navigationItem.searchController = searchController
	}
	
	private func bindVM() {
		let searchService = SearchService()
		let topRatedService = TopRatedService()
		let upcomingService = UpcomingService()
		let popularService = PopularService()
		
		//Passing all services needed in the View in the
		let moviesService = MoviesService(searchMovies: searchService,
										  topRated: topRatedService,
										  upcoming: upcomingService,
										  popular: popularService)
		
		vm = SearchVM(service: moviesService)
		
		vm.onDataUpdate = { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	//MARK: - IBActions
	
	@IBAction func topMovies() {
		Task(priority: .userInitiated) {
			await vm.top()
		}
	}
	
	@IBAction func upcomingMovies() {
		Task(priority: .userInitiated) {
			await vm.upcoming()
		}
	}
	
	@IBAction func popularMovies() {
		Task(priority: .userInitiated) {
			await vm.popular()
		}
	}
	
	@IBAction func resetAction() {
		vm.clearData()
		tableView.reloadData()
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Show/hide backgound depending on the UITableView array count.
		vm.movies.isEmpty ? (self.tableView.backgroundView?.isHidden = false) : (self.tableView.backgroundView?.isHidden = true)
		return vm.movies.count
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if vm.movies.isEmpty { return nil }
		else { return "Total: \(vm.totalResults) results" }
	}
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.text = header.textLabel?.text?.capitalized
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let movie = vm.movies[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
		
		cell.movieTitle.text = movie.title
		cell.movieYear.text = MDDate.shared.convertDateFormat(inputString: movie.releaseDate, fromFormat: .original, toFormat: .short)
		cell.movieDetail.text = "User Score: \(movie.voteAverage.percentageString)\nPopularity: \(String(format: "%.1f", movie.popularity))"
		
		ImageManager().setImage(into: cell.movieImage, from: movie.posterPath)

		return cell
    }
	
	// MARK: - Table view delegate
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		/*
		 When preparing to display the cell, make certain checks and fetch the next results page.
		 IF <the cell is the third before the last in table> (give a small heads up for loading) AND <total tableview data is less than total search results> THEN <increment page by one> AND fetch next page. New data will be appended at the end of vm.movies list.
		 */
		
		if (indexPath.row == vm.movies.count-3) && (vm.movies.count < vm.totalResults) {
			vm.pageIncrement()
			switch vm.mode {
				case .search:
					Task(priority: .userInitiated) {
						await vm.search(searchTerm: searchController.searchBar.text)
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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let movie = vm.movies[indexPath.row]
		self.performSegue(withIdentifier: "DetailSegue", sender: movie)
	}
}

extension SearchVC: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		//Since using Search Bar delegate, nothing to do here.
	}
}

extension SearchVC: UISearchBarDelegate {
	
	///Clear search data method.
	func clearSearch(reload: Bool = true) {
		vm.clearData()
		self.tableView.reloadData()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			//clear all data when user deletes all characters.
			clearSearch()
		}
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(false, animated: true)
		Task(priority: .userInitiated) {
			await vm.search(searchTerm: searchBar.text)
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		
		//Clear all previous data for a fresh search.
		clearSearch()
		
		//R U paying attention? Or am I talking to myself?
		Task(priority: .userInitiated) {
			await vm.search(searchTerm: searchBar.text)
		}
	}
}


