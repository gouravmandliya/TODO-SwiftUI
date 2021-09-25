//
//  AddToDo.swift
//  TO-DO
//
//  Created by Gourav on 10/04/21.
//

import SwiftUI

struct AddToDoView: View
{
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name:String = ""
    @State private var priority:String = "Normal"
    
    @State private var errorShowing:Bool = false
    @State private var errorTitle:String = ""
    @State private var errorMessage:String = ""
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    let priorities = ["High","Normal","Low"]
    
    var body: some View {
        NavigationView
        {
            VStack(alignment: .leading, spacing: 20) {
             
                TextField("Todo", text: $name)
                    .padding()
                    .background(Color(UIColor.tertiarySystemFill) )
                    .cornerRadius(9)
                    .font(.system(size: 24, weight: .bold, design: .default))
                   
                
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id: \.self) {
                        Text($0)
                    }
                   
                } .pickerStyle(SegmentedPickerStyle())
                Button(action: {
                    if self.name != ""
                    {
                        let todo = Todo(context: self.managedObjectContext)
                        todo.name = self.name
                        todo.priority = self.priority
                        do
                        {
                            try self.managedObjectContext.save()
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    else
                    {
                        self.errorShowing = true
                        self.errorTitle = "Invalid Name"
                        self.errorMessage = "Make sure to enter for\nThe new todo item"
                        return
                    }
                    self.presentationMode.wrappedValue.dismiss()
                   
                }, label: {
                    Text("Save")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .padding()
                        .frame(minWidth: 0,maxWidth: .infinity)
                        .background(themes[self.theme.themeSettings].themeColor)
                        .cornerRadius(9)
                        .foregroundColor(Color.white)
                    
                })
               
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical,30)
         
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                    })
            )        }
        .alert(isPresented: $errorShowing, content: {
            Alert(title: Text(self.errorTitle), message: Text(self.errorMessage), dismissButton:
                    .default(Text("Ok")))
        })
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}

struct AddToDo_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView()
    }
}
