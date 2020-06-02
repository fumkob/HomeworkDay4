//
//  Presenter.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/06/02.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import SwiftyJSON

class Presenter {
    var gitHubDataArray = [GitHubData]()
    weak var view: ViewInterface?
    let apiClient: APIClient
    //データをAPIからリクエスト
    func requestData() {
        view?.startIndicator()
        //URL定義
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language%3Aswift&sort=stars")
            else {
            fatalError("url is nil")
        }
        apiClient.getData(url: url)
    }
    func parseData(value: Any) {
        let jsonData = JSON(value)
        let items = jsonData["items"]
        //データを解析し、配列に格納する
        self.gitHubDataArray = items.map { GitHubData(item: $0.1) }
    }
    init(client: APIClient, view: ViewInterface) {
        self.apiClient = client
        self.view = view
        apiClient.delegate = self
    }
}

extension Presenter: APIClientDelegate {
    //成功時
    func didSuccess(value: Any) {
        self.parseData(value: value)
        //テーブルデータ更新
        view?.reload()
    }
    //失敗時
    func didError(error: Error) {
        print(error)
        //Alert表示
        view?.presentAlert()
    }
    //完了時
    func didComplete() {
        view?.stopIndicator()
    }
}
