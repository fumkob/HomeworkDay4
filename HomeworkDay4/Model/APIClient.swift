//
//  APIModel.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/06/02.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

public class APIClient {
    private let afRequest = AF
    public func getData(url: URL) -> Single<[GitHubData]> {
        return .create {observer in
            var urlRequest = URLRequest(url: url)
            //タイムアウト時間定義
            urlRequest.timeoutInterval = 5
            //データ取得
            self.afRequest.request(urlRequest).validate().responseJSON {response in
                switch response.result {
                //成功
                case .success(let value) :
                    observer(.success((self.parseData(value: value))))
                case .failure :
                    observer(.error(APIError.urlError))
                }
            }
            return Disposables.create()
        }
    }
    private func parseData(value: Any) -> [GitHubData] {
        let jsonData = JSON(value)
        let items = jsonData["items"]
        //データを解析し、配列に格納する
        return items.map { GitHubData(item: $0.1) }
    }
    enum APIError: Error {
        case urlError
    }
}
