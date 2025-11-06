
//
//  Float+Ext.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import Foundation

extension Float {
	
	///Converting Float to String and rating to percentage as it appears on the Movie Database website.
	var percentageString: String {
		let value = self * 10
		return value.truncatingRemainder(dividingBy: 1) == 0
		? String(format: "%.0f%%", value)
		: String(format: "%.1f%%", value)
	}
}
