//
//  MainView.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 4/7/25.
//

import SwiftUI

struct MainView: View {
	var buttonWidth: CGFloat = 360
	var buttonHeight: CGFloat = 120
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 10) {
				Spacer()
				
				//Top Movies Button
				Button(action: {
					print("top")
				}) {
					ZStack {
						Image("topmovies")
							.resizable()
							.scaledToFill()
						
						Color.red.opacity(0.4)
						
						Text("Top Movies")
							.font(.system(size: 30, weight: .bold))
							.foregroundColor(.white)
							.shadow(color: .red, radius: 1, x: 2, y: 3)
					}
				}
				.frame(width: buttonWidth, height: buttonHeight)
				.clipShape(RoundedRectangle(cornerRadius: 16))
				
				//Coming Soon Button
				Button(action: {
					print("upcoming")
				}) {
					ZStack {
						Image("comingsoon")
							.resizable()
							.scaledToFill()
						
						Color.yellow.opacity(0.6)
						
						Text("Coming Soon")
							.font(.system(size: 30, weight: .bold))
							.foregroundColor(.white)
							.shadow(color: .orange, radius: 1, x: 2, y: 3)
					}
				}
				.frame(width: buttonWidth, height: buttonHeight, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 16))
				
				//Popular Movies Button
				Button(action: {
					print("popular")
				}) {
					ZStack {
						Image("popular")
							.resizable()
							.scaledToFill()
						
						Color.green.opacity(0.4)
						
						Text("Popular")
							.font(.system(size: 30, weight: .bold))
							.foregroundColor(.white)
							.shadow(color: .mint, radius: 1, x: 2, y: 3)

					}
				}
				.frame(width: buttonWidth, height: buttonHeight, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 16))
				
				//Search Button
				Button(action: {
					print("Search")
				}) {
					ZStack {
						Image("search")
							.resizable()
							.scaledToFill()
						
						Color.blue.opacity(0.5)
						
						Text("Search")
							.font(.system(size: 30, weight: .bold))
							.foregroundColor(.white)
							.shadow(color: .indigo, radius: 1, x: 2, y: 3)

					}
				}
				.frame(width: buttonWidth, height: buttonHeight, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 16))
			}
			.padding(.bottom, 20)
			.navigationTitle("the Movie Database")
			.navigationBarTitleDisplayMode(.large) // ✅ this makes it large
		}
	}
}

#Preview {
    MainView()
}
