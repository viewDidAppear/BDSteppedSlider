//
//  BDSteppedSlider.swift
//  BDSteppedSlider
//
//  Created by Benjamin Deckys on 2022/06/04.
//

import UIKit

public protocol BDSteppedSliderDelegate: AnyObject {
	func steppedSlider(_ slider: BDSteppedSlider, valueChanged newValue: Float)
}

@IBDesignable
public final class BDSteppedSlider: UISlider {

	// MARK: - Constants

	private enum Constants {
		static let tickMarkWidth = CGFloat(3)
		static let insetFromBottomOfSuperview = CGFloat(5)
	}

	// MARK: - Style Configuration

	public enum Style: Int {
		case classic = 0
		case modern = 1

		var knobImage: UIImage {
			switch self {
				case .modern:
					return #imageLiteral(resourceName: "thumb_modern")
				case .classic:
					return #imageLiteral(resourceName: "thumb_classic")
			}
		}

		var minTrackImage: UIImage? {
			switch self {
				case .modern:
					return nil
				case .classic:
					return #imageLiteral(resourceName: "min_track_asset")
			}
		}

		var maxTrackImage: UIImage? {
			switch self {
				case .modern:
					return nil
				case .classic:
					return #imageLiteral(resourceName: "max_track_asset")
			}
		}

		var tickMarkWidth: CGFloat {
			switch self {
				case .classic:
					return 1
				case .modern:
					return 3
			}
		}

		var tickMarkColor: UIColor {
			switch self {
				case .classic:
					return .black
				case .modern:
					return .lightGray
			}
		}
	}

	// MARK: - Delegate

	public weak var delegate: BDSteppedSliderDelegate?

	// MARK: - Inspectable Public Properties

	/// Style for the control, either `.classic` or `.modern`. Defaults to `.classic`
	/// IBInspectable does not support `enum` even in 2022. So map Int values to between 0 and 1...
	@IBInspectable public var controlStyle: Int = 0 {
		didSet {
			style = controlStyle % 2 == 0 ? .classic : .modern
			setNeedsDisplay()
		}
	}

	/// How much to "step" the slider. Defaults to `5`.
	/// Make sure this value is relative to the minimum and maximum values of the slider!
	@IBInspectable public var valueInterval: Float = 5 {
		didSet {
			setNeedsDisplay()
		}
	}

	/// Whether or not to show the values below the track, in place of the tick marks. Defaults to `false`
	@IBInspectable public var showsValuesBelowTrack: Bool = false {
		didSet {
			setNeedsDisplay()
		}
	}

	@IBInspectable public var elongateCappingTickMarks: Bool = true

	@IBInspectable public var animateSnappingBetweenTickMarks: Bool = true

	// MARK: - Private Properties

	private var style: Style = .classic

	private var lastKnownXPosition: CGFloat = 0

	private lazy var hapticEngine: UIImpactFeedbackGenerator? = {
		if #available(iOS 10, *) {
			return UIImpactFeedbackGenerator(style: .light)
		} else {
			return nil
		}
	}()

	/**
	 Size of the elongated tick marks. May be unused.
	 */
	private var longTickMarkSize: CGSize {
		CGSize(width: style.tickMarkWidth, height: 5)
	}

	/**
	 Size of the tick marks between the start and end caps.
	 */
	private var intermediaryTickMarkSize: CGSize {
		CGSize(width: style.tickMarkWidth, height: 3)
	}

	/**
	 Calculate height of tick marks.
	 */
	private var tickMarkHeight: CGFloat {
		elongateCappingTickMarks ? longTickMarkSize.height : intermediaryTickMarkSize.height
	}

	/**
	 Calculate X position for the first capping tick mark
	 */
	var firstTickMarkX: CGFloat {
		(style.knobImage.size.width / 2)
	}

	/**
	 Calculate X position for the last capping tick mark
	 */
	var lastTickMarkX: CGFloat {
		bounds.width - firstTickMarkX - 1
	}

	/**
	 Calculate the number of pixels we have in which to draw our tick marks.
	 */
	private lazy var usablePixelRange: CGFloat = {
		lastTickMarkX - firstTickMarkX
	}()

	/**
	 Calculate the number of tick marks to draw.
	 */
	private var numberOfTickMarks: CGFloat {
		CGFloat((maximumValue - minimumValue) / valueInterval) - 1
	}

	/**
	 Calculate spacing in pixels between each tick mark.
	 */
	private var spacingBetweenTickMarks: CGFloat {
		usablePixelRange / (numberOfTickMarks + 1)
	}

	// MARK: - Init

	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	// MARK: - Setup

	private func commonInit() {
		// Prepare the haptic engine, if one is available
		hapticEngine?.prepare()

		// Set the images, based on the style enum
		setThumbImage(style.knobImage, for: .normal)
		setMinimumTrackImage(style.minTrackImage, for: .normal)
		setMaximumTrackImage(style.maxTrackImage, for: .normal)

		// Call the delegate method
		delegate?.steppedSlider(self, valueChanged: value)
	}

	// MARK: - Drawing

	public override func draw(_ rect: CGRect) {
		// Redraw only if the new frame != current frame
		// Prevent expensive redraws when unneccessary
		guard rect != frame else { return }

		// Draw cap marks
		drawLeftCappingTickMark()
		drawRightCappingTickMark()

		// Draw interstitial marks
		var previousMarkX = firstTickMarkX

		// For each tick mark...
		(0..<Int(numberOfTickMarks)).forEach { _ in
			// Calculate X position
			let x = previousMarkX + spacingBetweenTickMarks

			// Create path
			let path = UIBezierPath(
				roundedRect: CGRect(
					x: x.rounded(),
					y: bounds.maxY-Constants.insetFromBottomOfSuperview,
					width: intermediaryTickMarkSize.width,
					height: intermediaryTickMarkSize.height
				),
				cornerRadius: intermediaryTickMarkSize.width / 2
			)

			// Set the fill color, and fill the path
			style.tickMarkColor.setFill()
			path.fill()

			previousMarkX = x
		}

	}

	private func drawLeftCappingTickMark() {
		let path = UIBezierPath(
			roundedRect: CGRect(
				x: firstTickMarkX,
				y: bounds.maxY-Constants.insetFromBottomOfSuperview,
				width: style.tickMarkWidth,
				height: tickMarkHeight
			),
			cornerRadius: style.tickMarkWidth / 2
		)
		style.tickMarkColor.setFill()
		path.fill()
	}

	private func drawRightCappingTickMark() {
		let path = UIBezierPath(
			roundedRect: CGRect(
				x: lastTickMarkX,
				y: bounds.maxY-Constants.insetFromBottomOfSuperview,
				width: style.tickMarkWidth,
				height: tickMarkHeight
			),
			cornerRadius: style.tickMarkWidth
		)
		style.tickMarkColor.setFill()
		path.fill()
	}

	// MARK: - Touch Tracking

	/**
	 When the user begins puts their finger down on BDSteppedSlider, save the X position of the touch.
	 */
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)

		// Get position of touch
		let touchPositionX = touches.first?.location(in: self) ?? .zero

		// Set the new value
		setCurrentValue(for: touchPositionX.x)
	}

	public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		return true
	}

	/**
	 When the user lifts their finger off from BDSteppedSlider, correct the knob position.
	 */
	public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		// Get end position of touch
		let touchPositionX = touch?.location(in: self) ?? .zero

		// Ser the new value
		setCurrentValue(for: touchPositionX.x)
	}

	private func setCurrentValue(for touchPositionX: CGFloat) {
		// Save it into our last known x-coordinate position
		lastKnownXPosition = (touchPositionX - style.knobImage.size.width / 2)

		// Calculate relative value of control
		let fraction = lastKnownXPosition / usablePixelRange

		// Figure out where the user touched (+ the minimum possible value)
		let touchedValue = ((maximumValue - minimumValue) * Float(fraction)) + minimumValue

		// Round the value using our intervals, so we stick to whole numbers.
		let newValue = abs(valueInterval * (touchedValue / valueInterval).rounded())

		// Set the (capped to nearest tick mark) newValue, with optional animation, and call our delegate.
		if animateSnappingBetweenTickMarks {
			UIView.animate(
				withDuration: 0.1,
				delay: 0.0,
				options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]) { [weak self] in
					self?.setValue(newValue, animated: true)
				} completion: { [weak self] _ in
					guard let self = self else { return }
					self.delegate?.steppedSlider(self, valueChanged: newValue)
				}
		} else {
			delegate?.steppedSlider(self, valueChanged: newValue)
		}
	}

	// MARK: - Interface Builder Hook

#if TARGET_INTERFACE_BUILDER

	public override func prepareForInterfaceBuilder() {
		setNeedsDisplay()
	}

#endif

}

