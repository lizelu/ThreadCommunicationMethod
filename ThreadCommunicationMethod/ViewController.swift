//
//  ViewController.swift
//  ThreadCommunicationMethod
//
//  Created by Mr.LuDashi on 2017/8/28.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSMachPortDelegate {
    
    var handelEventThread: Thread!
    var handelEventMackPort: NSMachPort!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configMacPortAndThread()
    }
    
    func configMacPortAndThread() {
        self.handelEventMackPort = NSMachPort()
        self.handelEventMackPort.setDelegate(self)
    
        self.handelEventThread = Thread.current
        RunLoop.current.add(self.handelEventMackPort, forMode: .commonModes)
    }
    
    @IBAction func tapOtherThreadSendEventButton(_ sender: Any) {
        DispatchQueue.global().async {
            guard let sendEventPort = self.handelEventMackPort else {
                return
            }
            
            sendEventPort.send(before: Date(), msgid: 100, components:nil, from: nil, reserved: 0)
        }
    }
    
    func displayCurrentThread() {
        print(Thread.current)
    }
    
    //MARK: - NSMachPortDelegate
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        print(msg)
       // let message: NSPortMessage = msg
        
        displayCurrentThread()
        print("Handel Event")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

