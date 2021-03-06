/*
* Copyright (c) 2014-present Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {
	var isGreyscale = true
  
  let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    
    // Configure the gradient here
	gradientLayer.startPoint	= CGPoint(x: 0.0, y: 0.5)
	gradientLayer.endPoint		= CGPoint(x: 1.0, y: 0.5)

    return gradientLayer
  }()
	let textAttributes: [NSAttributedStringKey: Any] = {
		let style = NSMutableParagraphStyle()
			style.alignment = .center
		return [
			NSAttributedStringKey.font: 			UIFont(name: "HelveticaNeue-Thin",
														   size: 28.0)!,
			NSAttributedStringKey.paragraphStyle: 	style
		]
	}()
  
  @IBInspectable var text: String! {
    didSet {
      setNeedsDisplay()
		let image = UIGraphicsImageRenderer(size: bounds.size).image { _ in
			text.draw(in: bounds,
					  withAttributes: textAttributes)
		}
		let maskLayer = CALayer()
			maskLayer.backgroundColor 	= UIColor.clear.cgColor
			maskLayer.frame				= bounds.offsetBy(dx: bounds.size.width, dy: 0)
			maskLayer.contents			= image.cgImage

		gradientLayer.mask = maskLayer
    }
  }
  
  override func layoutSubviews() {
    layer.borderColor = UIColor.green.cgColor
	gradientLayer.frame = CGRect(x: 		-bounds.size.width,
								 y: 		bounds.origin.y,
								 width: 	3 * bounds.size.width,
								 height: 	bounds.size.height)
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()

	layer.addSublayer(gradientLayer)

	addGreyscaleGradient()
  }

	private func addRainbowGradient() {
		let colors = [
			UIColor.yellow.cgColor,
			UIColor.green.cgColor,
			UIColor.orange.cgColor,
			UIColor.cyan.cgColor,
			UIColor.red.cgColor,
			UIColor.yellow.cgColor
		]
		let locations: [NSNumber] = [
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.25
		]
		let rainbowAnimation = CABasicAnimation(keyPath: "locations")
		rainbowAnimation.fromValue 	= [ 0.0,  0.0, 0.0,  0.0, 0.0,  0.25 ]
		rainbowAnimation.toValue	= [ 0.65, 0.8, 0.85, 0.9, 0.95, 1.0 ]
		rainbowAnimation.duration	= 3.0
		rainbowAnimation.repeatCount = Float.infinity

		gradientLayer.removeAnimation(forKey: "GreyscaleAnimation")
		gradientLayer.colors 	= colors
		gradientLayer.locations = locations
		gradientLayer.add(rainbowAnimation, forKey: "RainbowAnimation")
	}

	private func addGreyscaleGradient() {
		let colors 	= [
			UIColor.black.cgColor,
			UIColor.white.cgColor,
			UIColor.black.cgColor
		]
		let locations: [NSNumber] = [
			0.25,
			0.5,
			0.75
		]
		let greyScaleAnimation = CABasicAnimation(keyPath: "locations")
		greyScaleAnimation.fromValue 	= [0.0, 0.0, 0.25]
		greyScaleAnimation.toValue		= [0.75, 1.0, 1.0]
		greyScaleAnimation.duration		= 3.0
		greyScaleAnimation.repeatCount 	= Float.infinity

		gradientLayer.removeAnimation(forKey: "RainbowAnimation")
		gradientLayer.colors	= colors
		gradientLayer.locations = locations
		gradientLayer.add(greyScaleAnimation, forKey: "GreyscaleAnimation")
	}

	func swapGradient() {
		isGreyscale ? addRainbowGradient() : addGreyscaleGradient()
		isGreyscale	= !isGreyscale
	}
}
