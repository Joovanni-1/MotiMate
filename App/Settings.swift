//
//  Settings.swift
//  MotiMate
//
//  Created by Giovanni Gaudiuso on 05/12/24.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        VStack {
            Text("Notifica")
            Text("tema chiaro scuro")
            Text("chi siamo!!")
        }
    }
}

#Preview {
    Goals(selected:2)
        .environmentObject(AppVariables())
     .environmentObject(AbitudiniViewModel())
}
