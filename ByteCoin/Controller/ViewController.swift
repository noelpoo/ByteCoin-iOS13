//
//  ViewController.swift
//  ByteCoin
//
//  Created by Noel Poo on 19/09/2020.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

//MARK: - VC - UIViewController
class ViewController: UIViewController {
    
    var coinManager = CoinManager()

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }
}

//MARK: - VC - UIPickerViewDataSource, UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //MARK: - pickerView(numberOfRows)
    // telling picker view how many rows of options to show
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    //MARK: - pickerView(title for current row)
    // telling picker view what to show for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    //MARK: - pickerView(did select row)
    // this method will get called everytime user scrolls the picker and stops at a selected row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(coinManager.currencyArray[row])
        
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }

}

//MARK: - VC - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        print("time: \(coin.time)")
        print("coin_id: \(coin.coin_id)")
        print("currency id: \(coin.currency_id)")
        print("rate: \(coin.rate)")
        
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", coin.rate)
            self.currencyLabel.text = coin.currency_id
        }
    }
}

