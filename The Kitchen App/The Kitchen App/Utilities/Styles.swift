//
//  Styles.swift
//  The Kitchen App
//
//  Created by Dean Stirrat on 3/15/22.
//

import SwiftUI


struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
 
            configuration.label
 
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .purple : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
 
    }
}

struct Styles: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Styles_Previews: PreviewProvider {
    static var previews: some View {
        Styles()
    }
}
