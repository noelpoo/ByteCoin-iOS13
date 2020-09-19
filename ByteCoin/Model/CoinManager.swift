//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Noel Poo on 19/9/2020.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "1F971D37-FCDF-4DF6-BDD4-B74576031E64"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let url = "\(self.baseURL)\(currency)?apikey=\(self.apiKey)"
        print("request url: \(url)")
        self.performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            print("performing request with: \(url)")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJson(coinData: safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let time = decodedData.time
            let coin_id = decodedData.asset_id_base
            let currency_id = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(time: time, coin_id: coin_id, currency_id: currency_id, rate: rate)
            
            return coin
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}
