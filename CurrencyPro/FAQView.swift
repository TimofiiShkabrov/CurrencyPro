//
//  FAQView.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 30.05.2023.
//

import SwiftUI

struct FAQView: View {
    
    @State private var isExpanded: [Bool] = [false, false, false]
    @Binding var lightThemeColors: [String : Color]
    @Binding var darkThemeColors: [String : Color]
    @Binding var isDarkMode: Bool
    @Binding var showFAQView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
//                  Set showFAQView to false to activate the X-axis offset of the FAQ View.
                    showFAQView = false
                }) {
                    Image(systemName: "xmark")
                        .frame(width: 30, height: 30)
                        .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
            
            ScrollView {
                VStack(alignment: .leading) {
                    DisclosureGroup(
                        isExpanded: $isExpanded[0],
                        content: {
                            Text("CurrencyPro is an application designed for currency conversion. It allows users to easily and quickly convert amounts of money from one currency to another. The app uses up-to-date exchange rates obtained from the network to ensure accuracy and currency conversions' timeliness.")
                                .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        },
                        label: {
                            Text("About the app")
                        }
                    )
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded[1],
                        content: {
                            Text("1. Currency selection: Users can choose a base currency for conversion and the currencies they want to compare the conversion with. Users can easily change the base currency and add or remove currencies for comparison. ")
                                .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                            
                            Text("2. Amount input: Users can enter the amount of money they want to convert. The app automatically updates the converted amounts for the selected currencies. ")
                                .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                            
                            Text("3. Up-to-date exchange rates: The app fetches up-to-date currency exchange rates from the network and updates them as needed. This ensures accuracy and currency conversion timeliness. ")
                                .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                            
                            Text("4. Dark and light themes: The app supports both dark and light themes, allowing users to choose their preferred appearance. 5. User interface: The app has a simple and intuitive user interface. It offers easy navigation and clear control elements. ")
                                .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        },
                        label: {
                            Text("The main functions of the app are")
                        }
                    )
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded[2],
                        content: {
                            Text("CurrencyPro is a useful application for anyone involved in international financial transactions or simply wanting to stay informed about current currency exchange rates. It provides a convenient way to quickly and accurately convert amounts of money and compare them in different currencies.")
                                .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        },
                        label: {
                            Text("Who is this app for?")
                        }
                    )
                    Spacer()
                }
                .padding(.trailing)
            }
            .padding(.horizontal)
        }
    }
}


struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView(
            lightThemeColors: .constant([String: Color]()),
            darkThemeColors: .constant([String: Color]()),
            isDarkMode: .constant(false),
            showFAQView: .constant(false)
        )
    }
}
