//
//  ProfileRow.swift
//  TripPlanner3
//
//  Created by stlp on 9/13/24.
//

import Foundation
import SwiftUI

struct ProfileRow: View {
    var icon: String       // Icon for the row
    var label: String      // Label for the row
    @Binding var text: String  // Bound text for input
    var editable: Bool = true  // Flag to determine if the text field is editable

    let elementHeight: CGFloat = 45
    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.85

    var body: some View {
        HStack {
            Image(systemName: icon)  // Display the icon
                .foregroundColor(.gray)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(label)  // Display the label
                    .font(.headline)
                    .foregroundColor(.gray)
                
                if editable {
                    // Editable TextField
                    TextField(label, text: $text)
                        .padding()
                        .frame(height: elementHeight)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
                } else {
                    // Non-editable Text display
                    Text(text)
                        .padding()
                        .frame(height: elementHeight)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
                        .disabled(true)
                }
            }
        }
        .padding(.vertical, 5)
        .frame(width: buttonWidth)
    }
}
