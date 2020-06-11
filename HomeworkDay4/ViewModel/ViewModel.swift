//
//  ViewModel.swift
//  HomeworkDay4
//
//  Created by Fumiaki Kobayashi on 2020/06/08.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ViewModel {
    private let apiClient: APIClient
    //データ用
    private let dataEventSubject = PublishSubject<[GitHubData]>()
    public var gitHubDataArray: Driver<[GitHubData]> {return dataEventSubject.asDriver(onErrorJustReturn: [])}
    //くるくる用
    private let indicatorEventSubject = BehaviorSubject<Bool>(value: true)
    public var indicatorStatus: Driver<Bool> {return indicatorEventSubject.asDriver(onErrorJustReturn: false)}
    //アラート用
    private let alertEventSubject = BehaviorSubject<Bool>(value: false)
    public var alertStatus: Driver<Bool> {return alertEventSubject.asDriver(onErrorJustReturn: false)}
    //disposeBag
    private var disposeBag = DisposeBag()
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    func requestData() {
        //くるくるさせる
        indicatorEventSubject.onNext(true)
        //Retryを押された時に一旦falseにする
        alertEventSubject.onNext(false)
        //URL定義
        guard let url = URL(string: "https://api.github.com/search/repositories?q=language%3Aswift&sort=stars")
            else {
                fatalError("url is nil")
        }
        disposeBag = DisposeBag()
        //API通信 
        apiClient.getData(url: url)
            .subscribe(onNext: { [weak self] in
                //くるくるやめる
                self?.indicatorEventSubject.onNext(false)
                //分岐
                switch $0 {
                case let .success(data):
                    self?.dataEventSubject.onNext(data)
                case let .failure(error):
                    //alert表示
                    self?.alertEventSubject.onNext(true)
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
