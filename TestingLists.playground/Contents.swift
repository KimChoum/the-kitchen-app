import UIKit
import SwiftUI

struct UserWithUUID: Identifiable {
    var id: UUID
    var name: String
}

class Users: ObservableObject {
    @Published var names = [UserWithUUID(id: UUID(), name: "Taylor"), UserWithUUID(id: UUID(), name: "Swift")]
}

struct ContentView: View {
    @EnvironmentObject var users: Users
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(users.names.enumerated()), id: \.element.id) { index, element in
                    TextField("titel", text: Binding<String>(get: { element.name }, set: { users.names[index].name = $0 }))
                }
                .onDelete(perform: delete)
            }
            .navigationBarItems(trailing: EditButton())
            .navigationTitle("working")
        }
    }
    func delete(at offsets: IndexSet) {
        users.names.remove(atOffsets: offsets)
    }
}
