//
//  HelperManager.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 29.05.2023.
//

import Foundation

// Error list to be displayed.
func warningMessage(error: NetworkError) -> String {
    switch error {
    case .noData:
        return "Data cannot be found at URL."
    case .tooManyRequests:
        return "Too many requests. Try again later."
    case .decodingError:
        return "Can't decode data."
    }
}
