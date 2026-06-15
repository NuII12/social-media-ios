import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tab = .feed
    
    enum Tab {
        case feed
        case search
        case messages
        case profile
        case settings
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .feed:
                    FeedView()
                case .search:
                    SearchView()
                case .messages:
                    MessagesView()
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                }
            }
            
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "house.fill",
                        label: "Feed",
                        isSelected: selectedTab == .feed,
                        action: { selectedTab = .feed }
                    )
                    
                    TabBarButton(
                        icon: "magnifyingglass",
                        label: "Search",
                        isSelected: selectedTab == .search,
                        action: { selectedTab = .search }
                    )
                    
                    TabBarButton(
                        icon: "bubble.right.fill",
                        label: "Messages",
                        isSelected: selectedTab == .messages,
                        action: { selectedTab = .messages }
                    )
                    
                    TabBarButton(
                        icon: "person.fill",
                        label: "Profile",
                        isSelected: selectedTab == .profile,
                        action: { selectedTab = .profile }
                    )
                    
                    TabBarButton(
                        icon: "gearshape.fill",
                        label: "Settings",
                        isSelected: selectedTab == .settings,
                        action: { selectedTab = .settings }
                    )
                }
                .background(AppColors.cardBackground)
            }
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
            }
            .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [User] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                VStack(spacing: 12) {
                    // Search Bar
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.textSecondary)
                        
                        TextField("Search users...", text: $searchText)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(AppColors.textPrimary)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppColors.cardBackground)
                    .cornerRadius(20)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    
                    // Results
                    if searchText.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(AppColors.textSecondary)
                            Text("Search for Users")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.textPrimary)
                            Text("Find people to follow")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 8) {
                                ForEach(MockData.sampleUsers) { user in
                                    UserSearchRow(user: user)
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserSearchRow: View {
    let user: User
    @State private var isFollowing = false
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: user.profileImageURL)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("@\(user.username)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(user.bio)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: { isFollowing.toggle() }) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundColor(isFollowing ? AppColors.textPrimary : .white)
                    .background(isFollowing ? AppColors.background : AppColors.primary)
                    .border(AppColors.border, width: 1)
                    .cornerRadius(6)
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(8)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
