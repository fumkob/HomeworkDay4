//
//  Presenter.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/06/02.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

public class Presenter {
    public var gitHubDataArray = [GitHubData]()
    private weak var view: ViewInterface?
    public let apiClient: APIClient
    //データをAPIからリクエスト
    public func requestData() {
        view?.startIndicator()
        //URL定義
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language%3Aswift&sort=stars")
            else {
            fatalError("url is nil")
        }
        //GitHub情報をGet
        apiClient.getData(url: url, callBack: {[weak self] result in
            self?.view?.stopIndicator()
            switch result {
            //成功
            case .success(let data) :
                self?.gitHubDataArray = data
                self?.view?.reload()
            //失敗
            case .failure(let error) :
                print(error)
                self?.view?.presentAlert()
            }
        })
    }
    public init(client: APIClient, view: ViewInterface) {
        self.apiClient = client
        self.view = view
    }
}
