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

class ViewController: UIViewController {
  
  @IBOutlet var slideView: AnimatedMaskLabel!
  @IBOutlet var timeLabel: UILabel!

	var timer: Timer?
	let formatter: DateFormatter = {
		let tmpFormatter = DateFormatter()
		tmpFormatter.dateFormat = "hh:mm"
		return tmpFormatter
	}()

  
  override func viewDidLoad() {
    super.viewDidLoad()
	setTime()

	timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.setTime), userInfo: nil, repeats: true)

	let swipe = UISwipeGestureRecognizer(target: self,
										 action: #selector(ViewController.didSlide))
		swipe.direction = .right
	slideView.addGestureRecognizer(swipe)
  }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		timer?.invalidate()
	}
  
	@objc func didSlide() {

    // reveal the meme upon successful slide
    let image = UIImageView(image: UIImage(named: "meme"))
    image.center = view.center
    image.center.x += view.bounds.size.width
    view.addSubview(image)
    
    UIView.animate(withDuration: 0.33, delay: 0.0,
      animations: {
        self.timeLabel.center.y -= 200.0
        self.slideView.center.y += 200.0
        image.center.x -= self.view.bounds.size.width
      },
      completion: { _ in
		self.slideView.swapGradient()
	}
    )
    
    UIView.animate(withDuration: 0.33, delay: 3.0,
      animations: {
        self.timeLabel.center.y += 200.0
        self.slideView.center.y -= 200.0
        image.center.x += self.view.bounds.size.width
      },
      completion: {_ in

        image.removeFromSuperview()
      }
    )
  }
	@objc private func setTime() {
		let curDate = Date()

		timeLabel.text = formatter.string(from: curDate)
	}
  
}






