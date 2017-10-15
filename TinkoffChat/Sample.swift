////
////  Sample.swift
////  TinkoffChat
////
////  Created by e.a.morozova on 11.10.17.
////  Copyright © 2017 e.a.morozova. All rights reserved.
////
//
//import UIKit
//
//class Sample {
//
////    func increment(by value: Int) -> Int {
////        var initial = 0
////        return initial + value
////    }
////
////    let incrementer = increment
////    incrementer(4)
//
//    func perform(_ function: () -> ()) {
//        function()
//    }
//
//    func makeIncrement() -> (Int) -> Int {
//        func increment(value: Int) -> Int {
//            let initial = 0
//            return initial + value
//        }
//
//        return increment
//    }
//
//    let generatedFunc = makeIncrement()
//    generatedFunc(5)
//
//    //closure expressions
//
////    func incremeter(by value: Int) -> (Int) -> (String) {
////        var initial = 0
////
////        func innerFunc(incrementer: Int) -> String {
////            initial += incrementer
////            return "Result \(initial)"
////        }
////
////        return innerFunc
////    }
////
////
////    let increment = incremeter(by: 4)
////    increment(4)
//
//    //@escaping/@noescaping
//
//    let printMessage = { (message: Message) -> () in
//        print(message.text)
//    }
//
//    typealias CompetionBlock = () -> ()
//    var completionBlock: CompetionBlock? = nil
//
//    func perform2(_ block: @escaping CompetionBlock) {
//        completionBlock = block
//    }
//
//    // capture List
//
//    class ViewController2: UIViewController {
//        var buttonAction: (() -> ())? = nil
//
//        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//            buttonAction = {
//                [weak self] in self?.buttonPressed()
//            }
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("")
//        }
//
//        func  buttonPressed() {
//
//        }
//
//        deinit {
//            print("deinit View Controller")
//        }
//
//        var vc = ViewController2()
//    }
//
//
//    // DeadLock
//    let serialQueue = DispatchQueue(label: "com.tinkoffChat.serialQueue")
//    serialQueue.async {
//        print("#1")
//
//        serialQueue.sync {
//            sleep(2)
//            print("#2")
//        }
//
//        print("#1 finished")
//    }
//
//}
//
