
//
//  Float+Ext.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 9/6/25.
//

import Foundation

extension Float {
	var percentageString: String {
		let value = self * 10
		return value.truncatingRemainder(dividingBy: 1) == 0
		? String(format: "%.0f%%", value)
		: String(format: "%.1f%%", value)
	}
}
