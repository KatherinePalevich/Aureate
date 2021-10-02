//
//  ContentView.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/20/21.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    @State var showMenu = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        let drag = DragGesture()
            .onEnded{
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading){
                    MainView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                        .disabled(self.showMenu ? true : false)
                    
                    
                    if self.showMenu {
                        MenuView()
                            .transition(.move(edge: .leading))
                    }
                }.gesture(drag)
                
            }.navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                        
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            ))
        }
    }
}

struct MainView : View{
    @Binding var showMenu: Bool
    let date = Date()
    
    var body: some View {
        VStack{
            Text("Welcome to Aureate").font(.system(size: 20))
            Text("Today's Date:")
            Text(date, style: .date)
            Text(date, style: .time)
            Spacer()
        }
    }
}


struct MenuView: View {
    var body: some View {
        List{
            NavigationLink(destination: EntryList()) {
                Image(systemName: "text.book.closed")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Journal")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            NavigationLink(destination: PlannerView()) {
                Image(systemName: "calendar")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Planner")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            NavigationLink(destination: ToDoView()) {
                Image(systemName: "list.bullet")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("To-Do")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            NavigationLink(destination: HabitTrackerView()) {
                Image(systemName: "square.grid.3x3.topleft.fill")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Habit Tracker")
                    .foregroundColor(.black)
                    .font(.headline)
            }
            NavigationLink(destination: DreamTrackerView()) {
                Image(systemName: "moon.stars")
                    .foregroundColor(.black)
                    .imageScale(.large)
                Text("Dream Tracker")
                    .foregroundColor(.black)
                    .font(.headline)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

