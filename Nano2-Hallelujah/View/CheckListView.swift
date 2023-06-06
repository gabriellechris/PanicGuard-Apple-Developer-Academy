//
//  CheckListView.swift
//  Nano2-Hallelujah
//
//  Created by Gabriella Christina Kandinata on 19/05/23.
//


import SwiftUI



struct CheckView: View {
    
    @State var isChecked:Bool = false
    @State private var isAllChecked = false
    
    var title:String
    func toggle(){isChecked = !isChecked}
    var body: some View {
        HStack{
            Button(action: toggle) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
            }
            Text(title)
        }
    }
}

#if DEBUG
struct CheckView_Previews: PreviewProvider {
    static var previews: some View {
        CheckView(title:"Title")
    }
}
#endif
