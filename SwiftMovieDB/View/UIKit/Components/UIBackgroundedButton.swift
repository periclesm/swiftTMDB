//
//  UIBackgroundedButton.swift
//  SwiftMovieDB
//
//  Created by Pericles Maravelakis on 1/7/25.
//

import UIKit

@IBDesignable
final class UIBackgroundedButton: UIButton {
	
	private let backgroundImageView = UIImageView()
	private let tintOverlayView = UIView()
	
	@IBInspectable
	var backgroundImageName: String? {
		didSet {
			if let name = backgroundImageName, let image = UIImage(named: name) {
				setBackgroundImage(image)
			}
		}
	}
	
	@IBInspectable
	var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
		didSet {
			updateOverlayColor()
		}
	}
	
	@IBInspectable
	var overlayAlpha: CGFloat = 0.3 {
		didSet {
			updateOverlayColor()
		}
	}
	
	@IBInspectable
	var cornerRadiusMultiplier: CGFloat = 0.125 {
		didSet {
			setNeedsLayout()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupBackground()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupBackground()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = frame.height * cornerRadiusMultiplier
		self.clipsToBounds = true
		self.layer.masksToBounds = true
	}
	
	private func setupBackground() {
		// Background Image View
		backgroundImageView.contentMode = .scaleAspectFill
		backgroundImageView.isUserInteractionEnabled = false
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(backgroundImageView)
		sendSubviewToBack(backgroundImageView)
		
		// Tint Overlay View
		tintOverlayView.backgroundColor = overlayColor
		tintOverlayView.isUserInteractionEnabled = false
		tintOverlayView.translatesAutoresizingMaskIntoConstraints = false
		insertSubview(tintOverlayView, aboveSubview: backgroundImageView)
		
		// Constraints (Full size)
		NSLayoutConstraint.activate([
			backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
			backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			tintOverlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
			tintOverlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
			tintOverlayView.topAnchor.constraint(equalTo: topAnchor),
			tintOverlayView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	func setBackgroundImage(_ image: UIImage?) {
		backgroundImageView.image = image
	}
	
	private func updateOverlayColor() {
		tintOverlayView.backgroundColor = overlayColor.withAlphaComponent(overlayAlpha)
	}
}
