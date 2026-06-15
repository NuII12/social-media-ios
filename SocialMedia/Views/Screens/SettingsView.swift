import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        // Account Section
                        SettingsSectionView(title: "Account") {
                            SettingRowView(
                                title: "Edit Profile",
                                icon: "person.fill",
                                action: {}
                            )
                            
                            SettingRowView(
                                title: "Change Password",
                                icon: "lock.fill",
                                action: {}
                            )
                            
                            SettingRowView(
                                title: "Two-Factor Authentication",
                                icon: "shield.fill",
                                action: {}
                            )
                        }
                        
                        // Notifications Section
                        SettingsSectionView(title: "Notifications") {
                            SettingToggleView(
                                title: "Push Notifications",
                                icon: "bell.fill",
                                isOn: $viewModel.pushNotificationsEnabled
                            )
                            
                            SettingToggleView(
                                title: "Email Notifications",
                                icon: "envelope.fill",
                                isOn: $viewModel.emailNotificationsEnabled
                            )
                            
                            SettingToggleView(
                                title: "Show Online Status",
                                icon: "circle.fill",
                                isOn: $viewModel.showOnlineStatus
                            )
                        }
                        
                        // Privacy Section
                        SettingsSectionView(title: "Privacy") {
                            SettingToggleView(
                                title: "Private Account",
                                icon: "lock.circle.fill",
                                isOn: $viewModel.privateAccount
                            )
                            
                            SettingToggleView(
                                title: "Allow Messages from Anyone",
                                icon: "message.fill",
                                isOn: $viewModel.allowMessagesFromAnyone
                            )
                            
                            SettingRowView(
                                title: "Blocked Users",
                                icon: "nosign",
                                action: {}
                            )
                        }
                        
                        // About Section
                        SettingsSectionView(title: "About") {
                            SettingRowView(
                                title: "App Version",
                                subtitle: "1.0.0",
                                icon: "info.circle.fill",
                                action: {}
                            )
                            
                            SettingRowView(
                                title: "Terms of Service",
                                icon: "doc.text.fill",
                                action: {}
                            )
                            
                            SettingRowView(
                                title: "Privacy Policy",
                                icon: "hand.raised.fill",
                                action: {}
                            )
                            
                            SettingRowView(
                                title: "About Us",
                                icon: "star.fill",
                                action: {}
                            )
                        }
                        
                        // Danger Zone
                        SettingsSectionView(title: "Danger Zone") {
                            SettingRowView(
                                title: "Download Your Data",
                                icon: "icloud.and.arrow.down",
                                action: {},
                                textColor: .orange
                            )
                            
                            SettingRowView(
                                title: "Delete Account",
                                icon: "trash.fill",
                                action: { viewModel.deleteAccount() },
                                textColor: .red
                            )
                        }
                        
                        // Logout Button
                        Button(action: { viewModel.logout() }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .background(AppColors.primary)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(AppColors.primary)
                    }
                }
            }
        }
    }
}

struct SettingsSectionView<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
                .textCase(.uppercase)
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                content()
            }
            .background(AppColors.cardBackground)
            .cornerRadius(8)
            .overflow(.hidden)
        }
        .padding(.horizontal, 12)
    }
}

struct SettingRowView: View {
    let title: String
    var subtitle: String?
    var icon: String?
    let action: () -> Void
    var textColor: Color = Color(uiColor: .label)
    var showArrow: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .frame(width: 24, height: 24)
                        .foregroundColor(textColor.opacity(0.7))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(textColor)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
        }
        
        Divider()
            .padding(.horizontal, 12)
    }
}

struct SettingToggleView: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(AppColors.primary.opacity(0.7))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { _ in
                    // Save changes
                }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground)
        
        Divider()
            .padding(.horizontal, 12)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
