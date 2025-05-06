import SwiftUI

/// Dedicated emergency contacts view that can be launched from the home screen
struct EmergencyContactsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @State private var showingAddContact = false
    @State private var showingCallAlert = false
    @State private var contactToCall: EmergencyContact?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Emergency header
                ZStack {
                    Rectangle()
                        .fill(Color.red)
                        .frame(height: 120)
                    
                    VStack {
                        Text("Emergency Contacts")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Tap a contact to call")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                }
                
                // Contacts list
                if userSettings.userProfile?.emergencyContacts.isEmpty ?? true {
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        
                        Text("No emergency contacts")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Add emergency contacts to quickly reach someone in case of emergency")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showingAddContact = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Contact")
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        // 911 Emergency
                        Button(action: {
                            contactToCall = EmergencyContact(
                                name: "Emergency Services",
                                relationship: .other,
                                phoneNumber: "911"
                            )
                            showingCallAlert = true
                        }) {
                            HStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "phone.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Emergency Services")
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text("911")
                                        .font(.system(size: 16))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "phone.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 8)
                        }
                        
                        // User's emergency contacts
                        ForEach(userSettings.userProfile?.emergencyContacts ?? []) { contact in
                            Button(action: {
                                contactToCall = contact
                                showingCallAlert = true
                            }) {
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 50, height: 50)
                                        
                                        Text(contact.name.prefix(1).uppercased())
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(contact.name)
                                            .font(.system(size: 18, weight: .bold))
                                        
                                        Text(contact.relationship.rawValue)
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondary)
                                        
                                        Text(contact.phoneNumber)
                                            .font(.system(size: 16))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "phone.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddContact = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                EditEmergencyContactView(isPresented: $showingAddContact)
                    .environmentObject(userSettings)
            }
            .alert(isPresented: $showingCallAlert) {
                Alert(
                    title: Text("Call \(contactToCall?.name ?? "Contact")"),
                    message: Text("Are you sure you want to call \(contactToCall?.phoneNumber ?? "")?"),
                    primaryButton: .default(Text("Call")) {
                        if let phoneNumber = contactToCall?.phoneNumber,
                           let url = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
                            UIApplication.shared.open(url)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
