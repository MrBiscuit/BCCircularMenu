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

    // MARK: -public variables
    var delegate:BCCircularMenuDelegate!
    var size : Double! // button's size
    var buttons : [UIButton] // embarks all buttons required in this operation
    var distance : Double // the center-to-center distance between generated buttons and touch point
    var spreadTime  = 0.35
    var triggerTime = 0.4
    var invalidTriggerDistance : CGFloat = 2
    
    // MARK: - private variables
    private var touchLocation : CGPoint!
    private var BCCircularMenuHasShown = false
    private var buttonActivationSequence = 0
    private var buttonDeactivationSequence = 0
    private var buttonActivated = 0
    private var timer : NSTimer!
    private var isValidTrigger = false
    
    init(buttons:[UIButton], distanceFromCenter:Double, buttonSize:Double, frame: CGRect) {
        
        self.buttons = buttons
        distance = distanceFromCenter
        size = buttonSize
        for var i = 1; i <= buttons.count; i++ {
            buttons[i-1].tag = i
            buttonDeactivationSequence += i
        }
        
       super.init(frame: frame)
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
        timer = NSTimer.scheduledTimerWithTimeInterval(triggerTime, target: self, selector: "timeDue", userInfo: nil, repeats: false)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let previousLocation = touch.previousLocationInView(touch.view)
            let currentLocation = touch.locationInView(touch.view)
            let translationInView = CGPointMake(currentLocation.x - previousLocation.x, currentLocation.y - previousLocation.y)
            if translationInView.x >= invalidTriggerDistance || translationInView.y >= invalidTriggerDistance{
                timer.invalidate()
            }
            if (BCCircularMenuHasShown && isValidTrigger){
                for button in buttons{
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
        if buttonActivationSequence > buttonDeactivationSequence + buttons.count && BCCircularMenuHasShown || buttonActivationSequence == 0{
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
        
        for button in buttons{
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
        let angle : Double = 360.0 / Double(buttons.count)
        for button in buttons{

            UIView.animateWithDuration(spreadTime) { () -> Void in
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
            for button in self.buttons{
                
                UIView.animateWithDuration(spreadTime, animations: { () -> Void in
                    button.center = self.touchLocation
                    button.alpha = 0.0
                    }, completion: { (Bool) -> Void in
                        button.removeFromSuperview()
                })
            }
        }else{
            for button in self.buttons{
                if button.tag != self.buttonActivated{
                    UIView.animateWithDuration(spreadTime, animations: { () -> Void in
                        button.center = self.touchLocation
                        button.alpha = 0.0
                        
                        }, completion: { (Bool) -> Void in
                            button.removeFromSuperview()
                    })
                }
                else{
                        UIView.animateWithDuration(self.spreadTime/3.0, animations: { () -> Void in
                            button.center = CGPoint(
                                x: Double(self.touchLocation.x) + self.distance*0.75 * cos(360.0 / Double(self.buttons.count) * Double(button.tag+1) / 180.0 * M_PI),
                                y: Double(self.touchLocation.y) + self.distance*0.75 * sin(360.0 / Double(self.buttons.count) * Double(button.tag+1) / 180.0 * M_PI))
                            button.alpha = 0.4
                            }, completion: { (Bool) -> Void in
                                UIView.animateWithDuration(self.spreadTime/3.0, animations: { () -> Void in
                                    button.alpha = 1.0
                                    }, completion: { (Bool) -> Void in
                                        UIView.animateWithDuration(self.spreadTime/3.0, animations: { () -> Void in
                                            button.alpha = 0.4
                                            }, completion: { (Bool) -> Void in
                                                UIView.animateWithDuration(self.spreadTime/3.0, animations: { () -> Void in
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
