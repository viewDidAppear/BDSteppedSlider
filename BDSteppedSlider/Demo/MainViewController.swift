//
//  MainViewController.swift
//  BDSteppedSlider
//
//  Created by Benjamin Deckys on 2022/06/04.
//

import UIKit

final class MainViewController: UIViewController {

	@IBOutlet private weak var slider: BDSteppedSlider! {
		didSet {
			slider.delegate = self
		}
	}
	@IBOutlet private weak var label: UILabel!

}

extension MainViewController: BDSteppedSliderDelegate {
	func steppedSlider(_ slider: BDSteppedSlider, valueChanged newValue: Float) {
		label.text = "FPS: \(newValue)"
	}
}

