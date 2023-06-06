//
//  LoadView.swift
//  CurrencyPro
//
//  Created by Тимофей Шкабров on 29.05.2023.
//

import SwiftUI

struct LoadView: View {
    
    @Binding var lightThemeColors: [String : Color]
    @Binding var darkThemeColors: [String : Color]
    @Binding var isDarkMode: Bool
    
    private let maximumElementWidth = UIScreen.main.bounds.width
    private let maximumElementHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            HStack {
                Image("icon")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(20)
                    .shadow(color: Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)), radius: 5)
                
                Text("CurrencyPro")
                    .font(.largeTitle)
                    .foregroundColor(isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"])
            }
            .frame(width: UIScreen.main.bounds.width)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: (((isDarkMode == false ? lightThemeColors["textColor"] : darkThemeColors["textColor"]) ?? Color.gray))))
            
        }
        .frame(width: maximumElementWidth, height: maximumElementHeight)
        .background(isDarkMode == false ? lightThemeColors["backgroundColor"] : darkThemeColors["backgroundColor"])
    }
}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadView(
            lightThemeColors: .constant([String: Color]()),
            darkThemeColors: .constant([String: Color]()),
            isDarkMode: .constant(true)
        )
    }
}
