//
//  CurrentDataModel.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 29.05.2023.
//

import Foundation

// Privat24CurrentAPI
struct QueryPrivatBank24API: Decodable {
    let exchangeRate: [ExchangeRate]
}

// ExchangeRate
struct ExchangeRate: Decodable, Hashable {
    let currency: String
    let saleRateNB: Double
}

// Array with additional data on currencies.
struct CurrencyDescription {
    let currency: String
    let currencySymbol: String
    let description: String
}
let currencyDescriptions: [CurrencyDescription] = [
    CurrencyDescription(currency: "AUD", currencySymbol: "$AU", description: "Australian Dollar"),
    CurrencyDescription(currency: "AZN", currencySymbol: "₼", description: "Azerbaijan Manat"),
    CurrencyDescription(currency: "BYN", currencySymbol: "Br", description: "Belarusian Ruble"),
    CurrencyDescription(currency: "CAD", currencySymbol: "CA$", description: "Canadian Dollar"),
    CurrencyDescription(currency: "CHF", currencySymbol: "₣", description: "Swiss Franc"),
    CurrencyDescription(currency: "CNY", currencySymbol: "¥", description: "Yuan Renminbi"),
    CurrencyDescription(currency: "CZK", currencySymbol: "Kč", description: "Czech Koruna"),
    CurrencyDescription(currency: "DKK", currencySymbol: "kr", description: "Danish Krone"),
    CurrencyDescription(currency: "EUR", currencySymbol: "€", description: "Euro"),
    CurrencyDescription(currency: "GBP", currencySymbol: "£", description: "Pound Sterling"),
    CurrencyDescription(currency: "GEL", currencySymbol: "₾", description: "Lari"),
    CurrencyDescription(currency: "HUF", currencySymbol: "ƒ", description: "Forint"),
    CurrencyDescription(currency: "ILS", currencySymbol: "₪", description: "New Israeli Sheqel"),
    CurrencyDescription(currency: "JPY", currencySymbol: "¥", description: "Yen"),
    CurrencyDescription(currency: "KZT", currencySymbol: "₸", description: "Tenge"),
    CurrencyDescription(currency: "MDL", currencySymbol: "L", description: "Moldovan Leu"),
    CurrencyDescription(currency: "NOK", currencySymbol: "kr", description: "Norwegian Krone"),
    CurrencyDescription(currency: "PLN", currencySymbol: "zł", description: "Zloty"),
    CurrencyDescription(currency: "SEK", currencySymbol: "kr", description: "Swedish Krona"),
    CurrencyDescription(currency: "SGD", currencySymbol: "S$", description: "Singapore Dollar"),
    CurrencyDescription(currency: "TMT", currencySymbol: "TMT", description: "Turkmenistan New Manat"),
    CurrencyDescription(currency: "TRY", currencySymbol: "₺", description: "Turkish Lira"),
    CurrencyDescription(currency: "UAH", currencySymbol: "₴", description: "Hryvnia"),
    CurrencyDescription(currency: "USD", currencySymbol: "$", description: "US Dollar"),
    CurrencyDescription(currency: "UZS", currencySymbol: "Soʻm", description: "Uzbekistan Sum"),
    CurrencyDescription(currency: "XAU", currencySymbol: "oz", description: "Gold"),
]

