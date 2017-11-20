//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 18.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation

struct RequestConfig<T> {
    let request: IRequest
    let parser: Parser<T>
}

enum Result<T> {
    case Success(T)
    case Fail(String)
}

protocol IRequestSender {
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping(Result<T>?) -> Void)
}
