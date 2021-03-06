/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

/**
*  Class that manages the creation, display, hiding, and deletion of the MILAlertView
*/
public class MILAlertViewManager: NSObject {
    
    /// The MILAlertView. Private to just this class
    var milAlertView : MILAlertView!
    /// The callback of the reload
    var callback : (()->())!
    
    
    public class var sharedInstance : MILAlertViewManager{
        
        struct Singleton {
            static let instance = MILAlertViewManager()
        }
        return Singleton.instance
    }
    
    /**
    
    
    - parameter text:     Text to display on the MILAlertView
    - parameter callback: Callback function to execute when the MILAlertView or its reload button is tapped
    */
    /**
    Function that builds and displays a MILAlertView
    
    - parameter text:      Text to display on the MILAlertView
    - parameter view:      view on which to add alert
    - parameter underView: view under which to add alert
    - parameter toHeight:  height of how far down the alert will show
    - parameter callback:  Callback function to execute when the MILAlertView or its reload button is tapped
    */
    func show(text: String!, view: UIView! = nil, underView: UIView! = nil, toHeight: CGFloat! = 44, callback: (()->())!) {
        
        // show alertview on main UI
        
        if self.milAlertView != nil{
            self.remove()
        }
        self.callback = callback
        self.milAlertView = self.buildAlert(text, callback: callback)
        if view != nil && underView != nil{
            view.insertSubview(self.milAlertView, belowSubview: underView)
            
        }else if view != nil && underView == nil {
            view.addSubview(self.milAlertView)
        }
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.milAlertView.setBottom(self.milAlertView.height + toHeight)
            }, completion: { finished -> Void in
                if finished{
                    if let alertview = self.milAlertView {
                        alertview.userInteractionEnabled = true
                    }else{
                        
                    }
                    if callback == nil {
                        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "hide", userInfo: nil, repeats: false)
                    }
                }
        })
        
    }
    
    
    /**
    Builds a MILAlertView that is initialized with the appropriate data
    
    - parameter text:     Text to display on the MILAlertView
    - parameter callback: Callback function to execute when the MILAlertView reload button is tapped
    
    - returns: An initialized MILAlertView
    */
    private func buildAlert(text: String!, callback: (()->())!)-> MILAlertView{
        let milAlertView : MILAlertView = MILAlertView.instanceFromNib() as MILAlertView
        milAlertView.setOriginX(0)
        milAlertView.setWidth(UIScreen.mainScreen().bounds.width)
        milAlertView.setBottom(44)
        milAlertView.setLabel(text)
        milAlertView.userInteractionEnabled = false
        milAlertView.setCallbackFunc(callback)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "reload")
//        if callback != nil {
//            tapGesture = UITapGestureRecognizer(target: self, action: "reload")
//        }
        milAlertView.addGestureRecognizer(tapGesture)
        
        return milAlertView
    }
    
    /**
    Hides the MILAlertView with an animation
    */
    public func hide() {
        if self.milAlertView != nil{
            self.milAlertView.userInteractionEnabled = false
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.milAlertView.setBottom(44)
                }, completion: { finished -> Void in
                    if finished {
                        //self.remove()
                    }
            })
        }
        
    }
    
    /**
    Removes the MILAlertView from its superview and sets it to nil
    */
    func remove(){
        if self.milAlertView != nil{
            self.milAlertView.removeFromSuperview()
            self.milAlertView = nil
        }
    }
    
    /**
    Reload function that fires when the MILALertView is tapped
    */
    @IBAction func reload(){
        callback()
        hide()
    }
    
}
