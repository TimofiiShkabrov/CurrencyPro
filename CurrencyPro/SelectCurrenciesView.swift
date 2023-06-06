//
//  SelectCurrenciesView.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 29.05.2023.
//

import SwiftUI

// View currency selections to be displayed in the main Connect View.
struct SelectCurrenciesView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @Binding var selectedCurrencies: Set<String>
    @Binding var defaultCurrency: String
    @Binding var showSelectCurrenciesView: Bool
    @Binding var lightThemeColors: [String : Color]
    @Binding var darkThemeColors: [String : Color]
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Select currencies to compare with the default")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Spacer()
//              Set showSelectCurrenciesView to true to activate the currency selection View offset on the X-axis.
                Button(action: {
                    showSelectCurrenciesView = false
                }) {
                    Image(systemName: "xmark")
                        .frame(width: 30, height: 30)
                        .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        .padding(.horizontal)
                }
            }
            HStack(alignment: .top) {
                Text("Selected currencies: ".uppercased())
                Text(selectedCurrencies.joined(separator: ", ").uppercased())
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
//          Create a list of available currencies to select from.
            ScrollView(.vertical) {
                VStack {
                    ForEach(networkManager.exchangeRates, id: \.self) { exchangeRate in
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(selectedCurrencies.contains(exchangeRate.currency) ? .blue : .clear)
                            Button(action: {
//                              Switching currency selection.
                                if selectedCurrencies.contains(exchangeRate.currency) {
                                    selectedCurrencies.remove(exchangeRate.currency)
                                } else {
                                    selectedCurrencies.insert(exchangeRate.currency)
                                }
                            }) {
//                              Displaying currencies from the API and adding a currency symbol and description from the CurrencyDescription.
                                Text(exchangeRate.currency)
                                    .padding(.vertical, 4)
                                    .foregroundColor(selectedCurrencies.contains(exchangeRate.currency) ? .blue : (isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"]))
                                if let currencyDescriptions = currencyDescriptions.first(where: { $0.currency == exchangeRate.currency }) {
                                    Text("- \(currencyDescriptions.currencySymbol) - \(currencyDescriptions.description)")
                                        .foregroundColor(selectedCurrencies.contains(exchangeRate.currency) ? .blue : (isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"]))
                                } else {
                                    Text(exchangeRate.currency)
                                        .foregroundColor(selectedCurrencies.contains(exchangeRate.currency) ? .blue : (isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"]))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
//          Set showSelectCurrenciesView to true to activate the currency selection View offset on the X-axis.
            Button(action: {
                showSelectCurrenciesView = false
            }) {
                Text("Add seting".uppercased())
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color.green)
            .cornerRadius(20)
            .shadow(color: (isDarkMode == false ? lightThemeColors["shadowColor"] : darkThemeColors["shadowColor"]) ?? Color.clear, radius: 5, y: 10)
            .padding()
        }
    }
}

struct SelectCurrenciesView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCurrenciesView(
            selectedCurrencies: .constant(Set<String>()),
            defaultCurrency: .constant(""),
            showSelectCurrenciesView: .constant(false),
            lightThemeColors: .constant([String: Color]()),
            darkThemeColors: .constant([String: Color]()),
            isDarkMode: .constant(false)
        )
        .environmentObject(NetworkManager())
    }
}
