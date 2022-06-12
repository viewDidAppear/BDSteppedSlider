# BDSteppedSlider
A very unfashionable UISlider component for iOS apps, with snapping behaviour.

![BDSteppedSlider_hero](https://user-images.githubusercontent.com/2734719/173232378-81b591f5-2989-46a2-b498-7a4a80bd14c5.png)

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](https://raw.githubusercontent.com/viewDidAppear/BDSteppedSlider/master/LICENSE)
[![Twitter](https://img.shields.io/badge/twitter-follow%20me-ff69b4?style=for-the-badge)](https://twitter.com/viewDidAppear)
[![Blog](https://img.shields.io/badge/read-my%20blog-red?style=for-the-badge)](https://viewDidAppear.github.io)

---

`BDSteppedSlider` is a "Classic macOS" inspired value-slider, which can be used in-place of standard `UISlider`. Why? Because! That's why!
It is as performant as possible, but serves no real purpose other than to be extremely unfashionable. Have fun!

* It also includes a more modern style.

# Features

* "Snap"
  * The slider can be configured to move in whole numbers.
  * Dragging the slider between two marks and letting go, will move the slider to the nearest allowed value.
* "Quick Tap"
  * Tap anywhere on the slider track, and the knob will move to the mark stop nearest your touch position. 
* Animates!
* Supports the "Taptic" feedback engine.
  * *May be unavailable on some iOS devices
* Delegate Callback 

# Usage

`BDSteppedSlider` works like any bog-standard UISlider, with added functionality.

```swift

@IBOutlet private weak var slider: BDSteppedSlider!
```

# Delegate

When the value gets changed, `BDSteppedSlider` sends a message to attached listeners.

```swift
extension SomeViewController: BDSteppedSliderDelegate {
  func steppedSlider(_ slider: BDSteppedSlider, valueChanged newValue: Float) {
    print(newValue)
	}
}
```

# Installation & Compatibility

`BDSteppedSlider` works wherever this version of Swift will compile.

## Manual (aka Tried & True)

Download the repo and add it into your Xcode project.

## CocoaPods

```ruby
pod 'BDSteppedSlider'
```

# Why? WHY?

No reason. Have fun!

# Credits

`BDSteppedSlider` was created by [Benjamin Deckys](https://github.com/viewDidAppear)

# License

`BDSteppedSlider` is available under the MIT license. Please see the [LICENSE](LICENSE) file for more information.
