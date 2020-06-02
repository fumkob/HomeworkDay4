//
//  APIModel.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/06/02.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import Alamofire

protocol APIClientDelegate: class {
    func didSuccess(value: Any)
    func didError(error: Error)
    func didComplete()
}

class APIClient {
    weak var delegate: APIClientDelegate?
    func getData(url: URL) {
        var urlRequest = URLRequest(url: url)
        //タイムアウト時間定義
        urlRequest.timeoutInterval = 5
        //データ取得
        AF.request(urlRequest).validate().responseJSON {[weak self] response in
            switch response.result {
            //成功
            case .success(let value) :
                self?.delegate?.didSuccess(value: value)
            //失敗
            case .failure(let error) :
                self?.delegate?.didError(error: error)
            }
            //終了
            self?.delegate?.didComplete()
        }
    }
}
