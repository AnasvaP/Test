//
//  ContentView.swift
//  Test
//
//  Created by Anastasiia Poliuchovych on 22.03.2023.
//

import SwiftUI
import CoreData
import Combine

// MAIN VIEW
struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @FetchRequest (sortDescriptors: []) var favorites: FetchedResults<User>
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel, favorites: favorites)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            FavView(favorites: favorites)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Fav")
                }
        }
    }
}


// FISRT TAB BAR ITEM - HOME
struct HomeView: View {
    
    @Environment(\.managedObjectContext) var moc
    @State private var showRepos = false
    
    var viewModel: ViewModel
    var favorites: FetchedResults<User>
    
    init(viewModel: ViewModel, favorites: FetchedResults<User>) {
        self.viewModel = viewModel
        self.favorites = favorites
    }
    
    @State private var selectedUserLogin = String()
    
    var body: some View{
        NavigationView {
            ScrollView {
                // Create a list of users
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.users) { user in
                        HStack{
                            
                            // User avatar image
                            AsyncImage(url: URL(string: user.avatarURL),
                                       content: { image in
                                image.resizable()
                                    .frame(width: 50, height: 50)
                                    .aspectRatio(contentMode: .fit)
                            },placeholder: {
                                Text("Loading...")
                            })
                            .padding(10)
                            .onTapGesture {
                                self.showRepos = true
                                self.selectedUserLogin = user.login
                            }
                            
                            // User login
                            Text(user.login)
                                .font(.title2)
                            
                            Spacer()
                            // Button to save a new fav (or delete from fav)
                            Button(checkIfFavContains(user: user).b ? "Видалити": "Зберегти") {
                                
                                let (exist,userToDelete) = checkIfFavContains(user: user)
                                if exist {
                                    moc.delete(userToDelete)
                                    print("Deleted user: \(user.login)")
                                    
                                } else {
                                    let u = User(context: moc)
                                    u.login = user.login
                                    u.avatarURL = user.avatarURL
                                    print("Saved user: \(user.login)")
                                }
                                try? moc.save()
                            }
                            .foregroundColor(.black)
                            .frame(width: 100, height: 50, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 5, x: 0, y: 0)
                            
                            
                        }.padding(5)
                        // LIST OF REPOS
                            .sheet(isPresented: $showRepos) {
                                List(viewModel.repos){ repo in
                                    Text(repo.name)
                                        .truncationMode(.tail)
                                        .multilineTextAlignment(.leading)
                                }.onAppear {
                                    viewModel.fetchRepos(forUser: selectedUserLogin)
                                }
                            }
                    }
                }
                .navigationTitle("Home")
            }
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
    
    
    func checkIfFavContains(user: DataModel) -> (b: Bool, userToDelete: User){
        var userToDelete = User()
        let b = favorites.contains { u in
            if u.login == user.login {
                userToDelete = u
                return true
            }
            return false
        }
        return (b, userToDelete)
    }
}



// SECOND TAB BAR ITEM - FAV
struct FavView: View {
    
    var favorites: FetchedResults<User>
    
    init(favorites: FetchedResults<User>) {
        self.favorites = favorites
    }
    
    var body: some View{
        NavigationView {
            VStack{
                List(favorites){user in
                    Text(user.login ?? "no data")
                }
            }
        }
    }
}
