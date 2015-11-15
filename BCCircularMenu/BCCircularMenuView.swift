//
//  BCCircularMenu.swift
//  BCCircularMenu
//
//  Created by Sunshuaiqi on 11/13/15.
//  Copyright © 2015 com.sunshuaiqi. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit


@objc protocol BCCircularMenuDelegate{
    optional func activatedButton(number : Int)
}

class BCCircularMenu: UIView {

    // tools
    var delegate:BCCircularMenuDelegate!
    var timer : NSTimer!
    var isValidTrigger = false
    var BCCircularMenuHasShown = false
    var touchLocation : CGPoint!
    var size : Double! // button's size
    var buttonsArray : [UIButton] // embarks all buttons required in this operation
    var distance : Double // the center-to-center distance between generated buttons and touch point
    var spreadDuration  = 0.35
    var buttonActivated = 0
    var buttonActivationSequence = 0
    var buttonDeactivationSequence = 0
    
    init(buttons:[UIButton], distanceFromCenter:Double, buttonSize:Double, frame: CGRect) {
        
        buttonsArray = buttons
        distance = distanceFromCenter
        size = buttonSize
        for var i = 1; i <= buttonsArray.count; i++ {
            buttonsArray[i-1].tag = i
            buttonDeactivationSequence += i
        }
        
       super.init(frame: frame)
        self.backgroundColor = UIColor ( red: 1.0, green: 0.856, blue: 0.7153, alpha: 1.0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // make isValidTrigger false
        isValidTrigger = false
        buttonActivated = 0
        // get the touch location
        for touch in touches{
            touchLocation = touch.locationInView(touch.view)
        }
        let offScreenDistance = CGFloat(distance + size / 2)
        
        if touchLocation.y >= UIScreen.mainScreen().bounds.size.height - offScreenDistance{
            touchLocation.y -= offScreenDistance
        }
        if touchLocation.y <= offScreenDistance{
            touchLocation.y += offScreenDistance
        }
        if touchLocation.x >= UIScreen.mainScreen().bounds.size.width - offScreenDistance{
            touchLocation.x -= offScreenDistance
        }
        if touchLocation.x <= offScreenDistance{
            touchLocation.x += offScreenDistance
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "timeDue", userInfo: nil, repeats: false)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let previousLocation = touch.previousLocationInView(touch.view)
            let currentLocation = touch.locationInView(touch.view)
            let translationInView = CGPointMake(currentLocation.x - previousLocation.x, currentLocation.y - previousLocation.y)
            if translationInView.x >= 2 || translationInView.y >= 2{
                timer.invalidate()
            }
            if (BCCircularMenuHasShown && isValidTrigger){
                for button in buttonsArray{
                    let buttonRadius = button.frame.size.width / 2.0
                    if (sqrt(pow(button.center.x - currentLocation.x, 2) + pow(button.center.y - currentLocation.y, 2)) <= buttonRadius){
                        buttonActivationSequence = button.tag+1
                        buttonActivated = button.tag
                    }else{
                        buttonActivationSequence += button.tag+1
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        timer.invalidate()
        if buttonActivationSequence > buttonDeactivationSequence + buttonsArray.count && BCCircularMenuHasShown || buttonActivationSequence == 0{
            buttonDismissAnimation()
        }else{
            DidFinishSelection()
        }
        
    }
    
    func timeDue(){
        isValidTrigger = true
        generateButtons()
    }
    
    func generateButtons(){
        
        for button in buttonsArray{
            button.center = touchLocation
            button.bounds = CGRect(origin: CGPointZero, size: CGSize(width: size, height: size))
            button.layer.cornerRadius = CGFloat(size) * 0.5
            button.clipsToBounds = true
            button.alpha = 0.0
            self.addSubview(button)
        }
        BCCircularMenuHasShown = true
        buttonSpreadOutAnimation()
    }
    
    func buttonSpreadOutAnimation(){
        let angle : Double = 360.0 / Double(buttonsArray.count)
        for button in buttonsArray{

            UIView.animateWithDuration(spreadDuration) { () -> Void in
               button.center = CGPoint(
                    x: Double(self.touchLocation.x) + self.distance * cos(angle * Double(button.tag+1) / 180.0 * M_PI),
                    y: Double(self.touchLocation.y) + self.distance * sin(angle * Double(button.tag+1) / 180.0 * M_PI))
                button.alpha = 1.0
            }
        }
    }
    
    func buttonDismissAnimation(){
        BCCircularMenuHasShown = false
        if (buttonActivated == 0){
            for button in self.buttonsArray{
                
                UIView.animateWithDuration(spreadDuration, animations: { () -> Void in
                    button.center = self.touchLocation
                    button.alpha = 0.0
                    }, completion: { (Bool) -> Void in
                        button.removeFromSuperview()
                })
            }
        }else{
            for button in self.buttonsArray{
                if button.tag != self.buttonActivated{
                    UIView.animateWithDuration(spreadDuration, animations: { () -> Void in
                        button.center = self.touchLocation
                        button.alpha = 0.0
                        
                        }, completion: { (Bool) -> Void in
                            button.removeFromSuperview()
                    })
                }
                else{
                        UIView.animateWithDuration(self.spreadDuration/3.0, animations: { () -> Void in
                            button.center = CGPoint(
                                x: Double(self.touchLocation.x) + self.distance*0.75 * cos(360.0 / Double(self.buttonsArray.count) * Double(button.tag+1) / 180.0 * M_PI),
                                y: Double(self.touchLocation.y) + self.distance*0.75 * sin(360.0 / Double(self.buttonsArray.count) * Double(button.tag+1) / 180.0 * M_PI))
                            button.alpha = 0.4
                            }, completion: { (Bool) -> Void in
                                UIView.animateWithDuration(self.spreadDuration/3.0, animations: { () -> Void in
                                    button.alpha = 1.0
                                    }, completion: { (Bool) -> Void in
                                        UIView.animateWithDuration(self.spreadDuration/3.0, animations: { () -> Void in
                                            button.alpha = 0.4
                                            }, completion: { (Bool) -> Void in
                                                UIView.animateWithDuration(self.spreadDuration/3.0, animations: { () -> Void in
                                                    button.alpha = 1.0
                                                    }, completion: {(Bool) -> Void in
                                                        button.alpha = 0.0
                                                        button.removeFromSuperview()
                                                })
                                        })
                                })
                        })
                    }
                }
        }
    }
    
    func DidFinishSelection(){
        if (delegate != nil && buttonActivated != 0) {
            delegate?.activatedButton!(buttonActivated)
        }
        buttonDismissAnimation()
    }
}

    