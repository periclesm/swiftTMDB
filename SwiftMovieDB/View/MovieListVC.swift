//
//  MovieListVC.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 2/7/25.
//

import UIKit

class MovieListVC: UITableViewController {
	
	//Set the View mode for this VC to fetch and display the appropreate data
	var mode: ServiceMode = .top
	
	//Define the View Model
	private var vm: MovieViewModel!
	
	//Used only when mode = .search
	@IBOutlet weak var backgroundView: UIView!
	private var searchController : UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
		if mode == .search {
			searchController = UISearchController(searchResultsController: nil)
		}
		
		setupUI()
		bindVM()
		getData()
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
		navigationItem.backButtonDisplayMode = .minimal
		
		switch mode {
			case .top:
				title = "Top Rated Movies"
			case .upcoming:
				title = "Upcoming Movies"
			case .popular:
				title = "Popular Movies"
			case .search:
				title = "Search"
				
			@unknown default:
				fatalError("Seems like you forgotten something")
		}
		
		if mode == .search {
			self.tableView.backgroundView = backgroundView
			navigationItem.hidesSearchBarWhenScrolling = false
			
			//Enable the following line and the extension below only when live update (aka, each time the user types a character) is needed
			//searchController?.searchResultsUpdater = self
			searchController?.obscuresBackgroundDuringPresentation = false
			searchController?.searchBar.placeholder = "search the Movie Database"
			searchController?.searchBar.delegate = self
			navigationItem.searchController = searchController
		}
	}
	
	private func bindVM() {
		let service = MoviesService(service: mode)
		vm = MovieViewModel(service)
		
		vm.onDataUpdate = { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	@IBAction func getData() {
		Task(priority: .userInitiated) {
			await vm.fetchData(for: mode)
			self.refreshControl?.endRefreshing()
		}
	}

    // MARK: - Table view

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Show/hide backgound depending on the UITableView array count.
		vm.movies.isEmpty ? (tableView.backgroundView?.isHidden = false) : (tableView.backgroundView?.isHidden = true)
		return vm.movies.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if vm.movies.isEmpty { return nil }
		
		if mode == .search {
			return "Total: \(vm.totalResults) movies"
		}
		
		return nil
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
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		/*
		 When preparing to display the cell, make certain checks and fetch the next results page.
		 IF <the cell is the third before the last in table> (give a small heads up for loading) AND <total tableview data is less than total search results> THEN <increment page by one> AND fetch next page. New data will be appended at the end of vm.movies list.
		 */
		
		if (indexPath.row == vm.movies.count-3) && (vm.movies.count < vm.totalResults) {
			vm.pageIncrement()
			switch mode {
				case .search:
					Task(priority: .userInitiated) {
						if let searchTerm = searchController?.searchBar.text {
							await vm.search(searchTerm: searchTerm)
						}
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
		performSegue(withIdentifier: "DetailSegue", sender: movie)
	}
}

//MARK: - Search Delegates
//extension MovieListVC: UISearchResultsUpdating {
//	func updateSearchResults(for searchController: UISearchController) {
//		//Since using Search Bar delegate, nothing to do here.
//	}
//}

extension MovieListVC: UISearchBarDelegate {
	
	///Clears search data.
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
