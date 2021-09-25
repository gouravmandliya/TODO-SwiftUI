//
//  EmptyListView.swift
//  To-Do
//
//  Created by Gourav on 11/04/21.
//

import SwiftUI

struct EmptyListView: View {
    
    let images :[String] = ["illustration-no1","illustration-no2","illustration-no3"]
    let tips:[String] = ["Use your time wisly.","Slow and steady wins the race.","Keep it short and sweet.","Put hard tasks first.","Reward yourself after work.","Collect tasks ahead of time.","Each night schedule for tomorrow."]
    
    @State private var isAnimated:Bool = false
  
    var body: some View {
        
        ZStack {
            VStack(alignment: .center, spacing: 20, content: {
                Image("\(images.randomElement() ?? self.images[0])")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                Text("\(tips.randomElement() ?? self.tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
            })
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -50)
            .animation(.easeOut(duration: 1.5))
            .onAppear(perform: {
                self.isAnimated.toggle()
            })
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .environment(\.colorScheme, .dark)
    }
}
