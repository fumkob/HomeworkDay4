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

public class APIClient {
    private let afRequest = AF
    public func getData(url: URL, callBack: @escaping (Result<[GitHubData], Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        //タイムアウト時間定義
        urlRequest.timeoutInterval = 5
        //データ取得
        afRequest.request(urlRequest).validate().responseJSON {response in
            switch response.result {
            //成功
            case .success(let value) :
                callBack(.success(self.parseData(value: value)))
            case .failure(let error) :
                print(error)
                callBack(.failure(error))
            }
        }
    }
    private func parseData(value: Any) -> [GitHubData] {
        let jsonData = JSON(value)
        let items = jsonData["items"]
        //データを解析し、配列に格納する
        return items.map { GitHubData(item: $0.1) }
    }
}
