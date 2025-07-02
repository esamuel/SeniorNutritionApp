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
                        Text(NSLocalizedString("Emergency Contacts", comment: "Title for emergency contacts screen"))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(NSLocalizedString("Tap a contact to call", comment: "Subtitle for emergency contacts screen"))
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
                        
                        Text(NSLocalizedString("No emergency contacts", comment: "Message when no emergency contacts are added"))
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(NSLocalizedString("Add emergency contacts to quickly reach someone in case of emergency", comment: "Prompt to add emergency contacts"))
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showingAddContact = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text(NSLocalizedString("Add Contact", comment: "Button to add a new contact"))
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
                        // Emergency Services (Dynamic Number)
                        Button(action: {
                            contactToCall = EmergencyContact(
                                name: userSettings.getEffectiveEmergencyServiceName(),
                                relationship: .other,
                                phoneNumber: userSettings.getEffectiveEmergencyNumber()
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
                                    Text(userSettings.getEffectiveEmergencyServiceName())
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text(userSettings.getEffectiveEmergencyNumber())
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
                    Button(NSLocalizedString("Close", comment: "Button to close the screen")) {
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
                    title: Text(String(format: NSLocalizedString("Call %s", comment: "Alert title to confirm call"), contactToCall?.name ?? NSLocalizedString("Contact", comment: "Default contact name"))),
                    message: Text(String(format: NSLocalizedString("Are you sure you want to call %s?", comment: "Alert message to confirm call"), contactToCall?.phoneNumber ?? "")),
                    primaryButton: .default(Text(NSLocalizedString("Call", comment: "Button to confirm a call"))) {
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
