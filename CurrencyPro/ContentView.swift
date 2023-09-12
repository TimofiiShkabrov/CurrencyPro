//
//  ContentView.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 29.05.2023.
//

import SwiftUI

// Main Application View
struct ContentView: View {
    @StateObject var networkManager = NetworkManager()
    @State var showSelectCurrenciesView = false
    @State var showFAQView = false
    @State var selectedCurrencies = Set<String>()
    @State var selectedCurrencyDescription: CurrencyDescription?
    @State var valueAmountMoney = 0.0
    
    private let maximumElementWidth = UIScreen.main.bounds.width * 0.9
    private let maximumElementHeight = UIScreen.main.bounds.height * 0.9
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("enterAmountMoney") var enterAmountMoney = "100"
    @AppStorage("defaultCurrency") var defaultCurrency = "EUR"
    
    //  Colours for a light theme
    @State private var lightThemeColors = [
        "backgroundColor": Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        "backgroundColorShade": Color(#colorLiteral(red: 0.9058823529, green: 0.9176470588, blue: 0.937254902, alpha: 1)),
        "shadowColor": Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)),
        "textColor": Color.black,
    ]
    //  Colours for a dark theme
    @State private var darkThemeColors = [
        "backgroundColor": Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),
        "backgroundColorShade": Color(#colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2549019608, alpha: 1)),
        "shadowColor": Color(#colorLiteral(red: 0.08112061769, green: 0.0008273631684, blue: 0, alpha: 0.5783464884)),
        "textColor": Color.white,
    ]
    
    //  Display of all currencies in List
    var filteredExchangeRates: [ExchangeRate] {
        let selectedRates = networkManager.exchangeRates.filter { selectedCurrencies.contains($0.currency) }
        if selectedRates.count >= 2 {
            return Array(selectedRates)
        } else {
            return Array(networkManager.exchangeRates)
        }
    }
    
    var body: some View {
        ZStack {
            //          Logic of the application load View display. If no data is loaded (isLoading = false) display LoadView.
            if networkManager.isLoading {
                LoadView(
                    lightThemeColors: $lightThemeColors,
                    darkThemeColors: $darkThemeColors,
                    isDarkMode: $isDarkMode
                )
            } else {
                ZStack {
                    VStack {
                        HStack {
                            //                          Transfer View of the application header with colour change depending on the selected theme.
                            HeaderApp()
                        }
                        .background(isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"])
                        .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.bottom)
                        .shadow(color: (isDarkMode == false ? lightThemeColors["shadowColor"] : darkThemeColors["shadowColor"])?.opacity(0.3)  ?? Color.clear, radius: 3, x: 0, y: 10)
                        //                      Transmit View of the application's default currency selection with colour change depending on the selected theme
                        SelectCurrency(
                            networkManager: networkManager,
                            defaultCurrency: $defaultCurrency,
                            selectedCurrencyDescription: $selectedCurrencyDescription,
                            enterAmountMoney: $enterAmountMoney,
                            valueAmountMoney: $valueAmountMoney,
                            lightThemeColors: $lightThemeColors,
                            darkThemeColors: $darkThemeColors,
                            isDarkMode: $isDarkMode
                        )
                        .padding()
                        .background(isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"])
                        .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        .cornerRadius(20)
                        .frame(width: maximumElementWidth)
                        .shadow(color: (isDarkMode == false ? lightThemeColors["shadowColor"] : darkThemeColors["shadowColor"]) ?? Color.clear, radius: 5)
                        //                      Display View button to select the display of currencies to be compared with the default currency.
                        HStack {
                            Text("Add or change currencies to compare with the default")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Button(action: {
                                //                              Set showSelectCurrenciesView to true to activate the currency selection View offset on the X-axis.
                                showSelectCurrenciesView = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        .frame(width: maximumElementWidth)
                        
                        //                      Displays a list of currencies filtered on the basis of the selected currencies.
                        List(filteredExchangeRates, id: \.self) { exchangeRate in
                            VStack {
                                HStack {
                                    //                                  Display the correct currency symbol from CurrencyDescription relative to the selected currency from ExchangeRate.
                                    if let currencyDescription = currencyDescriptions.first(where: { $0.currency == exchangeRate.currency }) {
                                        Text(currencyDescription.currencySymbol)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(getRandomColor())
                                            .cornerRadius(50)
                                        Text(exchangeRate.currency)
                                    } else {
                                        Text(exchangeRate.currency)
                                    }
                                    Spacer()
                                    if exchangeRate.currency == defaultCurrency {
                                        Text(enterAmountMoney)
                                            .font(.system(size: 25))
                                    } else {
                                        //                                      Calculate and display the amount entered in relation to other currencies.
                                        if let defaultRate = networkManager.exchangeRates.first(where: {
                                            $0.currency == defaultCurrency })?.saleRateNB {
                                            let rate = defaultRate / exchangeRate.saleRateNB
                                            if let convertedAmount = Double(enterAmountMoney) {
                                                if convertedAmount != 0 {
                                                    Text("\(convertedAmount * rate, specifier: "%.2f")")
                                                        .font(.system(size: 25))
                                                } else {
                                                    Text("0")
                                                        .font(.system(size: 25))
                                                }
                                            } else {
                                                Text("\(exchangeRate.saleRateNB, specifier: "%.2f")")
                                                    .font(.system(size: 25))
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"])
                                .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                                .frame(width: maximumElementWidth)
                                .cornerRadius(20)
                                .shadow(color: (isDarkMode == false ? lightThemeColors["shadowColor"] : darkThemeColors["shadowColor"]) ?? Color.clear, radius: 5)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(isDarkMode == false ? lightThemeColors["backgroundColorShade"] : darkThemeColors["backgroundColorShade"])
                        }
                        .padding(.bottom, -10)
                        //                      Changing the list style
                        .listStyle(PlainListStyle())
                        
                        //                      Transfer View of the application footer with colour change depending on the selected theme.
                        FooterApp(
                            isDarkMode: $isDarkMode,
                            showFAQView: $showFAQView
                        )
                        .background(isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"])
                        .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
                        .shadow(color: (isDarkMode == false ? lightThemeColors["shadowColor"] : darkThemeColors["shadowColor"])?.opacity(0.3) ?? Color.clear, radius: 4, x:0, y: -10)
                        
                    }
                    .background(isDarkMode == false ? lightThemeColors["backgroundColorShade"] : darkThemeColors["backgroundColorShade"]) // Изменение фонового цвета родительского VStack
                    
                    .alert(isPresented: $networkManager.showError) {
                        Alert(title: Text(networkManager.errorMessage))
                    }
                    
                    //                  Displays a list of selected currencies for comparison with the main currency.
                    SelectCurrenciesView(
                        selectedCurrencies: $selectedCurrencies,
                        defaultCurrency: $defaultCurrency,
                        showSelectCurrenciesView: $showSelectCurrenciesView,
                        lightThemeColors: $lightThemeColors,
                        darkThemeColors: $darkThemeColors,
                        isDarkMode: $isDarkMode
                    )
                    .padding()
                    .frame(width: maximumElementWidth, height: maximumElementHeight / 2)
                    .background(isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"])
                    .frame(width: maximumElementWidth)
                    .cornerRadius(20)
                    .shadow(color: (isDarkMode == false ? lightThemeColors["shadowColor"] : darkThemeColors["shadowColor"]) ?? Color.clear, radius: 20)
                    //                      Shift the currency selection view to create a pop-up effect.
                    .offset(y: showSelectCurrenciesView ? maximumElementHeight * 0.26: maximumElementHeight)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                    //                      Set the networkManager instance as a global environment object.
                    .environmentObject(networkManager)
                    
                    //                  Display the FAQ View list.
                    FAQView(
                        lightThemeColors: $lightThemeColors,
                        darkThemeColors: $darkThemeColors,
                        isDarkMode: $isDarkMode,
                        showFAQView: $showFAQView
                    )
                    .padding()
                    .frame(width: maximumElementWidth, height: maximumElementHeight / 2)
                    .background(isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"])
                    .frame(width: maximumElementWidth)
                    .cornerRadius(20)
                    .shadow(color: (isDarkMode == false ? lightThemeColors["shadowColor"] : darkThemeColors["shadowColor"]) ?? Color.clear, radius: 20)
                    //                      Shift the FAQ view to create a pop-up effect.
                    .offset(y: showFAQView ? maximumElementHeight * 0.26: maximumElementHeight)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                }
                //              Hide the amount entry keypad when pressing on any part of the screen.
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        //      An asynchronous wait (await) operation that calls the fetchAllExchangeRates() function of the networkManager object.
        .onAppear {
            Task {
                await networkManager.fetchAllExchangeRates()
            }
        }
        .background((isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"]).edgesIgnoringSafeArea(.all))
        .preferredColorScheme(isDarkMode == false ? .light : .dark)
    }
    
    //  Colour radomisation function for the currency sivloth circle
    func getRandomColor() -> Color {
        let randomColor = colors.randomElement() ?? Color.black
        return randomColor
    }
    private let colors = [Color.red, Color.green, Color.blue, Color.yellow, Color.purple]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NetworkManager())
    }
}

struct SelectCurrency: View {
    @StateObject var networkManager: NetworkManager
    @Binding var defaultCurrency: String
    @Binding var selectedCurrencyDescription: CurrencyDescription?
    @Binding var enterAmountMoney: String
    @Binding var valueAmountMoney: Double
    @Binding var lightThemeColors: [String : Color]
    @Binding var darkThemeColors: [String : Color]
    @Binding var isDarkMode: Bool

    var body: some View {
        VStack {
            HStack {
                if let currencyDescription = selectedCurrencyDescription {
                    Text("\(currencyDescription.currencySymbol)")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .cornerRadius(50)
                } else {
                    Text("€")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .cornerRadius(50)
                }
                Spacer()
                Text("Select your currency:")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                //              Default currency picker for comparison with currencies from the List.
                Picker("Default currency", selection: $defaultCurrency) {
                    ForEach(networkManager.exchangeRates, id: \.currency) { exchangeRate in
                        //                      Displays the correct currency symbol from CurrencyDescription relative to the selected currency from ExchangeRate.
                        if let currencyDescription = currencyDescriptions.first(where: { $0.currency == exchangeRate.currency }) {
                            Text("\(currencyDescription.currencySymbol) - \(exchangeRate.currency)")
                        }
                    }
                }
                .pickerStyle(.menu)
                //               When the value of the defaultCurrency variable is changed, the code updates the description of the selected currency and calls the function to update the converted amounts.
                .onChange(of: defaultCurrency) { newDefaultCurrency in
                    selectedCurrencyDescription = currencyDescriptions.first(where: { $0.currency == newDefaultCurrency })
                    updateConvertedAmounts()
                }
            }
            
            HStack {
                TextField("Enter your amount", text: $enterAmountMoney, onCommit: {
                    self.valueAmountMoney = Double(self.enterAmountMoney) ?? 0.0
                    self.updateConvertedAmounts()
                })
                .multilineTextAlignment(.trailing)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill((isDarkMode == false ? lightThemeColors["backgroundColorShade"] : darkThemeColors["backgroundColorShade"]) ?? Color.white))
                .keyboardType(.decimalPad)
                //              Limit the entry to just one point in the amount entry field.
                .onChange(of: enterAmountMoney) { newValue in
                    if let commaRange = newValue.range(of: ",") {
                        enterAmountMoney.replaceSubrange(commaRange, with: ".")
                    }
                    let dotCount = newValue.reduce(0) { $1 == "." ? $0 + 1 : $0 }
                    if dotCount > 1 {
                        enterAmountMoney = String(newValue.filter { $0 != "." })
                    }
                }
                .font(.system(size: 35))
                .padding(.bottom)
            }
            
            HStack {
                Image(systemName: "chevron.down")
                    .foregroundColor(Color.gray)
            }
        }
    }
    
    func updateConvertedAmounts() {
        guard let amount = Double(enterAmountMoney) else {
            return
        }
        
        //      Search for the exchange rate for the selected currency and use it to convert the amount entered into the selected currency.
        networkManager.exchangeRates.forEach { exchangeRate in
            if exchangeRate.currency == defaultCurrency {
                valueAmountMoney = amount
            } else if let defaultRate = networkManager.exchangeRates.first(where: { $0.currency == defaultCurrency })?.saleRateNB {
                let rate = exchangeRate.saleRateNB / defaultRate
                valueAmountMoney = amount * rate
            }
        }
    }
}

struct HeaderApp: View {
    var body: some View {
        HStack {
            Image("icon")
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(20)
                .shadow(color: Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)), radius: 5)
            
            Text("CurrencyPro")
                .font(.largeTitle)
        }
        .padding(.bottom)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct FooterApp: View {
    
    @Binding var isDarkMode: Bool
    @Binding var showFAQView: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                if let url = URL(string: "mailto:timofii.shkabrov@gmail.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "lifepreserver")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            Spacer()
            Button {
                //              Set showFAQView to true to activate FAQ View's X-axis offset.
                showFAQView = true
            } label: {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            Spacer()
            //          Button to switch the theme of the app.
            Button {
                isDarkMode.toggle()
            } label: {
                if isDarkMode {
                    Image(systemName: "sun.min")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else {
                    Image(systemName: "moon")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width)
    }
}
