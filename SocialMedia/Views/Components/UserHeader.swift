import SwiftUI

struct UserHeader: View {
    let user: User
    var onFollowPressed: (() -> Void)?
    var onEditPressed: (() -> Void)?
    var isOwnProfile: Bool = false
    var isFollowing: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Cover Image
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppColors.primary.opacity(0.3),
                            AppColors.secondary.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 100)
            
            VStack(spacing: 12) {
                // Profile Image
                AsyncImage(url: URL(string: user.profileImageURL)) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(AppColors.cardBackground, lineWidth: 4))
                .offset(y: -50)
                
                // Name and Username
                VStack(spacing: 4) {
                    Text(user.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("@\(user.username)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                // Bio
                Text(user.bio)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                
                // Stats
                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("\(user.posts)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Posts")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(user.followers)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Followers")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(user.following)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Following")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(AppColors.background)
                .cornerRadius(8)
                
                // Buttons
                HStack(spacing: 12) {
                    if isOwnProfile {
                        Button(action: { onEditPressed?() }) {
                            Label("Edit Profile", systemImage: "pencil")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .background(AppColors.primary)
                                .cornerRadius(8)
                        }
                    } else {
                        Button(action: { onFollowPressed?() }) {
                            Text(isFollowing ? "Following" : "Follow")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(isFollowing ? AppColors.textPrimary : .white)
                                .background(isFollowing ? AppColors.background : AppColors.primary)
                                .border(AppColors.border, width: 1)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "envelope.fill")
                                .frame(width: 40, height: 40)
                                .foregroundColor(AppColors.primary)
                                .background(AppColors.background)
                                .border(AppColors.border, width: 1)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(AppColors.cardBackground)
    }
}

struct UserHeader_Previews: PreviewProvider {
    static var previews: some View {
        UserHeader(
            user: MockData.currentUser,
            isOwnProfile: true
        )
    }
}
