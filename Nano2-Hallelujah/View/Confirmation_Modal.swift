//
//  Confirmation_Modal.swift
//  Nano2-Hallelujah
//
//  Created by Gabriella Christina Kandinata on 18/05/23.
//

import SwiftUI

struct Confirmation_Modal: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var showConfirmationModel: Bool
    @Binding var showExercisesModal: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "exclamationmark.triangle").imageScale(.large)
                    .foregroundColor(.red)
                    .font(.system(size:100, weight: .semibold))
                
                Spacer()
                    .frame(height:32)
                
                Text("Your heart rate is concerning. Are you in a panic mode?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.body)
                
                Spacer()
                    .frame(height:32)

                Button(action: {
                    showConfirmationModel = false
                    showExercisesModal = true
                }) {
                    Text("Calm me down")
                        .frame(width: 150, height: 20)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .font(.headline)
                        .foregroundColor(Color.orange)
                        .background(Color(hex:0xFF1E1E1E))
                        .fontWeight(.medium)
                        .cornerRadius(15)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button style
//                .sheet(isPresented: $isExercisesTutorialPresented) {
//                    Exercises_Tutorial()
//                }
                
                .clipShape(Capsule())
//
//                NavigationLink(destination: Exercises_Tutorial()) {
//                        Text("Calm me down")
//                            .frame(width: 150, height: 20)
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 12)
//                            .font(.headline)
//                            .foregroundColor(Color.orange)
//                            .background(Color(hex:0xFF1E1E1E))
//                            .fontWeight(.medium)
//                            .cornerRadius(15)
//                    }
//                    .padding(10)
//
//                .clipShape(Capsule())
                
//                Button("I'm fine:)"){
//                    print("Button tapped!")
//                }
//
                
                Button() {
                    showConfirmationModel = false
                } label: {
                    Text("I'm fine")
                        .frame(width: 150, height: 20)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: 0xFFB3B3B3))
                        .fontWeight(.regular)
                }
                .clipShape(Capsule())
            }
        }
    }
}

//struct Confirmation_Modal_Previews: PreviewProvider {
//    static var previews: some View {
//        Confirmation_Modal()
//    }
//}
