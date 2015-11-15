//
//  ViewController.swift
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

class ViewController: UIViewController,BCCircularMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton(type: .Custom)
        button1.setTitle("b1", forState: .Normal)
        button1.setImage(UIImage(named: "b1image"), forState: .Normal)
        button1.backgroundColor = UIColor.redColor()
        
        let button2 = UIButton(type: .Custom)
        button2.setTitle("b2", forState: .Normal)
        button1.setImage(UIImage(named: "b2image"), forState: .Normal)
        button2.backgroundColor = UIColor.yellowColor()
        
        let button3 = UIButton(type: .System)
        button3.setTitle("b3", forState: .Normal)
        button3.backgroundColor = UIColor.blueColor()
        
        let button4 = UIButton(type: .System)
        button4.setTitle("b4", forState: .Normal)
        button4.backgroundColor = UIColor.greenColor()
        
        let button5 = UIButton(type: .System)
        button5.setTitle("b5", forState: .Normal)
        button5.backgroundColor = UIColor.cyanColor()
        
        let button6 = UIButton(type: .System)
        button6.setTitle("b6", forState: .Normal)
        button6.backgroundColor = UIColor.brownColor()
        
        let CircularMenu = BCCircularMenu(buttons: [button1,button2,button3, button4, button5, button6], distanceFromCenter: 30.0, buttonSize: 40.0, frame: self.view.frame)
        
        CircularMenu.delegate = self
        self.view.addSubview(CircularMenu)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func activatedButton(number: Int) {
        print("button number: \(number) was clicked")
    }

}

