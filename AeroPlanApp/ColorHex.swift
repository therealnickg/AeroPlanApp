//
//  ColorHex.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 9/16/23.
//
//  Extension for the Color type that takes a hexadecimal value as input

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
	  self.init(
		.sRGB,
		red: Double((hex >> 16) & 0xFF) / 255.0,
		green: Double((hex >> 8) & 0xFF) / 255.0,
		blue: Double(hex & 0xFF) / 255.0,
		opacity: alpha
	  )
    }
}
