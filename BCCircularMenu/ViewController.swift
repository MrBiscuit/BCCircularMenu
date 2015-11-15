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
        button1.setImage(UIImage(named: "check"), forState: .Normal)
        
        let button2 = UIButton(type: .Custom)
        button2.setImage(UIImage(named: "x"), forState: .Normal)
        
        let button3 = UIButton(type: .Custom)
        button3.setImage(UIImage(named: "sms"), forState: .Normal)
        
        let button4 = UIButton(type: .Custom)
        button4.setImage(UIImage(named: "@"), forState: .Normal)
        
        let button5 = UIButton(type: .Custom)
        button5.setImage(UIImage(named: "back"), forState: .Normal)
        
        let CircularMenu = BCCircularMenu(buttons: [button1,button2,button3, button4, button5], distanceFromCenter: 90.0, buttonSize: 90.0, frame: self.view.frame)
        
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

