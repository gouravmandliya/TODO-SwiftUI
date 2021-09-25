//
//  ToDoListView.swift
//  TO-DO
//
//  Created by Gourav on 10/04/21.
//

import SwiftUI

struct ToDoListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true) ]) var todos:FetchedResults<Todo>
    @State private var showingAddToDoView:Bool = false
    @State private var showingSettingView:Bool = false
    @EnvironmentObject var iconSettings :IconNames
    @State private var animatingButton :Bool = false
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    var body: some View {
        
        NavigationView
        {
            ZStack {
                List {
                  ForEach(self.todos, id: \.self) { todo in
                    HStack {
                      Circle()
                        .frame(width: 12, height: 12, alignment: .center)
                        .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                      Text(todo.name ?? "Unknown")
                        .fontWeight(.semibold)
                      
                      Spacer()
                      
                      Text(todo.priority ?? "Unkown")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.systemGray2))
                        .padding(3)
                        .frame(minWidth: 62)
                        .overlay(
                          Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                      )
                    } //: HSTACK
                      .padding(.vertical, 10)
                  } //: FOREACH
                  .onDelete(perform: deleteTodo)
                }

                .navigationBarTitle("TODO", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                    trailing:
                        Button(action: {
                        self.showingSettingView.toggle()
                        }, label: {
                        Image(systemName: "paintbrush")
                            .imageScale(.large)
                            
                                
                            })
                        .accentColor(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingView, content: {
                            SettingsView().environmentObject(self.iconSettings)
                    }))
                
                if todos.count == 0 {
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddToDoView, content: {
                AddToDoView().environment(\.managedObjectContext, self.managedObjectContext)
                
            })
            .overlay(
                ZStack{
                    Group{
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                          //  .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.15 : 0)
                           // .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                   // .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    Button(action: {
                        self.showingAddToDoView.toggle()
                        
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    })
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                }
                .padding(.bottom,15)
                .padding(.trailing,15)
                ,alignment: .bottomTrailing
            )
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
       
    }
    
    private func colorize(priority: String) -> Color {
      switch priority {
      case "High":
        return .pink
      case "Normal":
        return .green
      case "Low":
        return .blue
      default:
        return .gray
      }
    }
    private func deleteTodo(offsets:IndexSet){
        for index  in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            do{
                try managedObjectContext.save()
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        ToDoListView().environment(\.managedObjectContext, context)
    }
}
