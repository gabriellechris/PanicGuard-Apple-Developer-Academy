//
//  Exercises_Tutorial.swift
//  Nano2-Hallelujah
//
//  Created by Gabriella Christina Kandinata on 18/05/23.
//

import SwiftUI

struct Exercises_Tutorial: View {
    
    @State private var isAllChecked = false
    @Binding var showExercisesModal: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack {
                Text("Do these exercises")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: 380, alignment: .leading)
                
                Spacer()
                    .frame(height:32)
                
                Group {
                    Text("1. Breathing Exercise")
                        .foregroundColor(Color(hex: 0xFFFCFCFC))
                        .frame(maxWidth: 400, alignment: .leading)
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding(.leading, 16)
                    
                    VStack {
                        Spacer()
                            .frame(height: 16)
                        CheckView(title:"Breathe in for 4 seconds.")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(.leading, 8)
                            .padding(.top, 2)
                        CheckView(title:"Hold your breath for 7 seconds.")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(.leading, 8)
                            .padding(.top, 2)
                        CheckView(title:"Exhale slowly for 8 seconds.")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(.leading, 8)
                            .padding(.top, 2)
                        CheckView(title:"Repeat until you feel calmer.")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(.leading, 8)
                            .padding(.top, 2)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    
                    
                    Text("2. The 5-4-3-2-1 technique")
                        .foregroundColor(Color(hex: 0xFFFCFCFC))
                        .frame(maxWidth: 380, alignment: .leading)
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding(.leading, 16)
                    
                    VStack {
                        Spacer()
                            .frame(height: 16)
                        CheckView(title:"Look around the room, then name five things you see around you. ")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(2)
                        CheckView(title:"Next, name four things you can touch.")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(2)
                        CheckView(title:"Listen quietly, then acknowledge three things you can hear.")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(2)
                        CheckView(title:"Note two things you can smell. ")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(2)
                        CheckView(title:"Notice something you can taste inside your mouth.  ")
                            .foregroundColor(Color(hex: 0xFFD2D2D2))
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(2)
                        
                        Spacer()
                            .frame(height: 64)
                    }
                    
                    
                    Button() {
                        showExercisesModal = false
                    } label: {
                        Text("Finished")
                            .frame(width: 150, height: 20)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .font(.headline)
                            .foregroundColor(Color.orange)
                            .background(Color(hex: 0xFF1E1E1E))
                            .fontWeight(.medium)
                            .cornerRadius(15)
                    }
                    .padding(10)
//                    .disabled(!isAllChecked)
                    
    
//
//                    Button() {
//                        showExercisesModal = false
//                    } label: {
//                        Text("Finished")
//                            .frame(width: 150, height: 20)
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 12)
//                            .font(.headline)
//                            .foregroundColor(Color.orange)
//                            .background(Color(hex: 0xFF1E1E1E))
//                            .fontWeight(.medium)
//                            .cornerRadius(15)
//                    }
//                    .clipShape(Capsule())
                    
                }
                
                Spacer()
                    .frame(height: 32)
            }
            
        }
    }
}

//
//struct Exercises_Tutorial_Previews: PreviewProvider {
//    static var previews: some View {
//        Exercises_Tutorial()
//    }
//}
