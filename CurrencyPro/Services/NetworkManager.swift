//
//  NetworkManager.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 29.05.2023.
//

import Foundation

// To retrieve data via PrivatBank API, it is necessary to generate a URL to retrieve the DATA with the current number as of today. To generate today's date in the format "dd.mm.yyyy", a "DataManager" is created.

enum Link {
    case privarBank24APIUrl
    
    var urlAPI: URL {
        
        // Transmit today's date in the correct format from the "DateManager".
        let dateString = getDate()
        
        switch self {
        case .privarBank24APIUrl:
            return URL(string: "https://api.privatbank.ua/p24api/exchange_rates?date=\(dateString)")!
        }
    }
}

// List of errors
enum NetworkError: Error {
    case noData
    case tooManyRequests
    case decodingError
}

// Working with the API
private actor ServiceStore {
    func loadExchangeRates() async throws -> [ExchangeRate] {
//      Create an empty array of exchangeRates, which will contain the exchange rate data.
        var exchangeRates = [ExchangeRate]()
//      Asynchronous request to retrieve data from a specified URL.
        let (data, response) = try await URLSession.shared.data(from: Link.privarBank24APIUrl.urlAPI)
        let httpResponse = response as? HTTPURLResponse
//      Checking statusCode
        let statusCode = httpResponse?.statusCode ?? 0
        
        if statusCode == 429 {
            throw NetworkError.tooManyRequests
        }
//      Attempt to decode received data using JSONDecoder.
        guard let decodedQuery = try? JSONDecoder().decode(QueryPrivatBank24API.self, from: data) else {
            throw NetworkError.decodingError
        }
//      The exchange rate values from decodedQuery.exchangeRate are assigned to the exchangeRates array.
        exchangeRates = decodedQuery.exchangeRate
        
        return exchangeRates
    }
}

final class NetworkManager: ObservableObject {
    @Published var exchangeRates = [ExchangeRate]()
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    
//  The object responsible for performing data loading operations.
    private let store = ServiceStore()
    
    @MainActor func fetchAllExchangeRates() async {
//      Indicates that data is being loaded to display LoadView.
        isLoading = true
        defer {
//          The defer construct sets a 1 second delay before the isLoading flag changes back to false. This simulates a short delay after data loading before the interface is updated.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//              Remove LoadView when all data is loaded.
                self.isLoading = false
            }
        }
        do {
//          An asynchronous call to loadExchangeRates() from the store object to load exchange rates. The result is saved in the exchangeRates property.
            exchangeRates = try await store.loadExchangeRates()
        } catch {
//          Error handling 
            if let networkError = error as? NetworkError {
                errorMessage = warningMessage(error: networkError)
            } else if let urlError = error as? URLError, urlError.errorCode == NSURLErrorCancelled {
//              Handling a cancellation error
                print("Request cancelled")
                return
            } else {
                print("Catch: \(error)")
                errorMessage = warningMessage(error: NetworkError.decodingError)
            }
            showError = true
        }
    }
}
