//
//  SessionExtension.swift
//  RxSwiftRepositories
//
//  Created by 小林遼太 on 2020/09/17.
//  Copyright © 2020 小林遼太. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

extension Session: ReactiveCompatible {}

extension Reactive where Base: Session {
    func response<T: Request>(_ request: T) -> Observable<T.Response> {
        return Observable<T.Response>.create { [weak base] observer -> Disposable in
            #if DEBUG
            print("------------ Start API Request ------------")
            print("url == \(request.baseURL.absoluteString)\(request.path)")
            if let parameters = request.parameters {
                print("parameters == \(parameters)")
            }
            if let body = request.bodyParameters as? MultipartFormDataBodyParameters {
                print("body parameters")
                body.parts.forEach {
                    print("\($0.name) == \($0.inputStream)")
                }
            }
            print("-------------------------------------------")
            #endif
            let task = base?.send(request) { result in
                switch result {
                case .success(let value):
                    #if DEBUG
                    print("------------ Success API Request ------------")
                    print("\(value)")
                    print("---------------------------------------------")
                    #endif

                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
}
