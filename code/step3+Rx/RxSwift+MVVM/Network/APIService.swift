//
//  APIService.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 07/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

let MenuUrl = "https://firebasestorage.googleapis.com/v0/b/rxswiftin4hours.appspot.com/o/fried_menus.json?alt=media&token=42d5cb7e-8ec4-48f9-bf39-3049e796c936"

class APIService {
    static func fetchAllMenus() -> Observable<Data> {
        
        Observable.create { emitter in
            URLSession.shared.dataTask(with: URL(string: MenuUrl)!) { data, response, error in
                if let error = error {
                    emitter.onError(error)
                }
                guard let data = data else {
                    let httpResponse = response as! HTTPURLResponse
                    let error = NSError(domain: "No Data", code: httpResponse.statusCode)
                    emitter.onError(error)
                    return
                }
                emitter.onNext(data)
                emitter.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
}

//class APIService {
//    static func fetchAllMenus(onComplete: @escaping (Result<Data, Error>) -> Void) {
//        URLSession.shared.dataTask(with: URL(string: MenuUrl)!) { data, res, err in
//            if let err = err {
//                onComplete(.failure(err))
//                return
//            }
//            guard let data = data else {
//                let httpResponse = res as! HTTPURLResponse
//                onComplete(.failure(NSError(domain: "no data",
//                                            code: httpResponse.statusCode,
//                                            userInfo: nil)))
//                return
//            }
//            onComplete(.success(data))
//        }.resume()
//    }
//    
//    static func fetchAllMenusRx() -> Observable<Data> {
//        return Observable.create { emitter in
//            
//            fetchAllMenus { result in
//                switch result {
//                case .success(let data):
//                    emitter.onNext(data)
//                    emitter.onCompleted()
//                case .failure(let error):
//                    emitter.onError(error)
//                }
//            }
//            return Disposables.create()
//        }
//    }
//}


