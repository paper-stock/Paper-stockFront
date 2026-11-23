//
//  UserListView.swift
//  Paper-Stock
//
//  Created by Szymon on 23/11/2026.
//

import SwiftUI

struct UserListView: View {
    var body: some View {

            NavigationStack{
                List {
                    NavigationLink{
                        WhoAmIView()
                    }label: {
                        Label("My acount", systemImage: "person.crop.circle")
                    }
                    
                    NavigationLink {
                        ChangePasswordView()
                    } label: {
                        Label("Change password", systemImage: "lock.fill")
                    }
                    
                    NavigationLink{
                        GetAllOrdersView()
                    } label: {
                        Label("Orders", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        LogoutButton()
                    }
                }
            }
        }
}

#Preview {
    UserListView()
}
