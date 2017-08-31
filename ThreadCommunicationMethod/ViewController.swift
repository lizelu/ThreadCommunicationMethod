//
//  ViewController.swift
//  ThreadCommunicationMethod
//
//  Created by Mr.LuDashi on 2017/8/28.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSMachPortDelegate {

    var handelEventMachPort: NSMachPort!

    override func viewDidLoad() {
        super.viewDidLoad()
        addMachPortToMainRunLoop()
    }
    
    func addMachPortToMainRunLoop() {
        //创建MachPort、并设置代理、然后将该MachPort添加到主线程中的RunLoop中
        self.handelEventMachPort = NSMachPort()
        self.handelEventMachPort.setDelegate(self)
        RunLoop.current.add(self.handelEventMachPort, forMode: .commonModes)
    }
    
    @IBAction func tapOtherThreadSendEventButton(_ sender: Any) {
        //开启一个子线程，子线程通过handelEventMackPort与主线程通信
        DispatchQueue.global().async {
            guard let sendEventPort = self.handelEventMachPort else {
                return
            }
            Thread.current.name = "MySubThread"
            print("Send Event Sub Thread: \(Thread.current)")
            
            //往主线程中的RunLoop中发送事件
            sendEventPort.send(before: Date(), msgid: 100, components:nil, from: nil, reserved: 0)
        }
    }
    
    //MARK: - NSMachPortDelegate
    //MachPort所触发的回调方法
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        print("Handel Event Thread: \(Thread.current)\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

