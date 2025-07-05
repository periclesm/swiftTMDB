//
//  MovieListView.swift
//  SwiftMovieDB SUI
//
//  Created by Pericles Maravelakis on 5/7/25.
//

import SwiftUI

struct MovieListView: View {
	var mode: ServiceMode
	
    var body: some View {
		Text("Mode: \(mode.rawValue.capitalized)")
    }
}

#Preview {
	MovieListView(mode: .top)
}

struct MovieListViewItem: View {
	var body: some View {
		/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
	}
}
