# BCCircularMenu

<img src="http://i12.tietuku.com/81464d560d709d7f.png" width = "300" height = "300" alt="BCCircularMenu" align = center />

This is a simple, adaptive circular menu that spreads out on touch and activates upon release with toggling animation for cocoa touch. You can easily arrange them however you want.

### Features
---
* Automatically generate  the number of buttons needs to be displayed based on its parameter
* Entirely customizable
* Autoformat the spacing

### Installation
---
Simply grab the file `BCCircularMenu/BCCircularMenu/BCCircularMenuView` and put it in your project.

### Usage
---
+ 1. In your ViewController, inherit from `BCCircularMenuDelegate`, make sure to import `projectName-swift.h` beforehand if your using objective-C


>Swift
```swift
     class ViewController: UIViewController,BCCircularMenuDelegate
```
>Objective-C
```objectivec
     @interface ViewController ()<BCCircularMenuDelegate>
```


+ 2. Make some buttons the way you normally would

>Swift
```swift
    let button1 = UIButton(type: .Custom)
    button1.setTitle("b1", forState: .Normal)
    button1.setImage(UIImage(named: "b1image"), forState: .Normal)
    button1.backgroundColor = UIColor.redColor()
    let button2 = UIButton(type: .Custom)
    button2.setTitle("b2", forState: .Normal)
    button1.setImage(UIImage(named: "b2image"), forState: .Normal)
    button2.backgroundColor = UIColor.yellowColor()
```
>Objective-C
```objectivec
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"b1" forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"b1image.jpg"] forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor yellowColor];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"b2" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"b2image.jpg"] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor blueColor];
```

+ 3. Create a circularMenu with youre desired params, set the delegate, and add it to view

>Swift
```swift
    let circularMenu = BCCircularMenu(buttons: [button1,button2], 
    distanceFromCenter: 25.0, buttonSize: 34.0, frame: self.view.frame)
    circularMenu.delegate = self
    self.view.addSubview(circularMenu)
```

>Objective-C
```objectivec
     BCCircularMenu * circularMenu = [[BCCircularMenu alloc] initWithButtons:\
     @[button1,button2] distanceFromCenter:37 buttonSize:42 frame:self.view.frame];
     circularMenu.delegate = self;
     [self.view addSubview:circularMenu];
```

+ 4. Implement the method and you're done

>Swift
```swift
    func activatedButton(number: Int) {
        print("button number: \(number) is activated")
    }
```

>OBjective-C
```objectivec
   -(void)activatedButton:(NSInteger)number{
       NSLog(@"button number:%ld is activated",(long)number);
   }
```

# Parameters & Initializers
 Name    | Type    | description
 ---:   | :---:   | :---
  size   | doble   | size of each button
  buttons| array   | where all buttons are stored
 distance| double  | distance from the touch point to the center of each button
 spreadTime|float  | how long it takes for button spearding animation
 triggerTime|float | the minimum time required for a long press event to perform a valid trigger
 invalidTriggerDistance| CGFloat | the minimum length required to invalidate a trigger
