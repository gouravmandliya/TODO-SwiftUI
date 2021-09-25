//
//  SettingsView.swift
//  To-Do
//
//  Created by Gourav on 03/07/21.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    //MARK:- PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings:IconNames
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    //MARK:- BODY
    var body: some View {
        NavigationView{
        VStack(alignment: .center, spacing: 0, content: {
            Form{
                Section(header: Text("Choose the app icon")) {
                    Picker(selection: $iconSettings.currentIndex, label: Text("App Icons"), content: {
                        ForEach(0..<iconSettings.iconNames.count) { index in
                            HStack{
                            Image(uiImage: UIImage(named:  self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width:44,height:44)
                                .cornerRadius(8)
                                Spacer().frame(width:8)
                                Text(self.iconSettings.iconNames[index] ?? "Blue")
                                    .frame(alignment:.leading)
                            }
                            .padding(3)
                          }
                        
                        
                    })
                    .onReceive([self.iconSettings.currentIndex].publisher.first(), perform: { value in
                        let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                        if index != value {
                            UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { (error) in
                                if let err = error {
                                    print(err)
                                }
                            }
                        }
                    })
                }
                .padding(.vertical,3)
                
                Section(header:
                    HStack{
                        Text("Choose the app theme")
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(themes[self.theme.themeSettings].themeColor)
                    
                }) {
                    List{
                        ForEach(themes, id: \.id) { (item)  in
                            Button {
                                self.theme.themeSettings = item.id
                                UserDefaults.standard.setValue(self.theme.themeSettings, forKey: "Theme")
                            } label: {
                                
                                HStack{
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(item.themeColor)
                                   Text(item.themeName)
                                }
                            }
                            .accentColor(Color.primary)
                        }
                    }
                }.padding(.vertical,3)
                
                
                Section(header: Text("Follow us on social media")) {
                    FormRowLinkView(icon: "link", color: Color.pink, text: "Linkdin", link: "https://www.linkedin.com/in/gourav-mandliya-817b2aa8/")
                    FormRowLinkView(icon: "link", color: Color.blue, text: "Twitter", link: "https://twitter.com/gourav_mandliya")
                       
                }
                
                Section(header: Text("About the application")) {
                    FormRowStaticView(icon: "gear", firstText: "Application", secontText: "Todo")
                    FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secontText: "iPhone,iPad")
                    FormRowStaticView(icon: "keyboard", firstText: "Developer", secontText: "Gourav")
                    FormRowStaticView(icon: "paintbrush", firstText: "Designer", secontText: "Gourav")
                    FormRowStaticView(icon: "flag", firstText: "version", secontText: "1.0")
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            
            Text("Copyright @ All right reserved.\nBetter Apps ♡ less Code")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.vertical,8)
                .foregroundColor(Color.secondary)
              
            
        })
      
    
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                , label: {
                                    Image(systemName: "xmark")
                                })
        )
        .navigationBarTitle("Settings", displayMode: .inline)
        .background(Color("ColorBase").edgesIgnoringSafeArea(.all))
        }
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
    
}
//MARK:- PRIVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconNames())
    }
}
