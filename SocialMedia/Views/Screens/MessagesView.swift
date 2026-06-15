import SwiftUI

struct MessagesView: View {
    @StateObject var viewModel = MessagesViewModel()
    @State private var selectedConversation: Conversation?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                if selectedConversation != nil {
                    ChatDetailView(
                        conversation: $selectedConversation,
                        viewModel: viewModel
                    )
                } else {
                    ConversationListView(
                        viewModel: viewModel,
                        selectedConversation: $selectedConversation
                    )
                }
            }
            .navigationTitle(selectedConversation?.participant.name ?? "Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if selectedConversation != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            selectedConversation = nil
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(AppColors.primary)
                        }
                    }
                } else {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(AppColors.primary)
                        }
                    }
                }
            }
        }
    }
}

struct ConversationListView: View {
    @ObservedObject var viewModel: MessagesViewModel
    @Binding var selectedConversation: Conversation?
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            SearchBar(text: $viewModel.searchText)
                .padding(12)
            
            // Conversations List
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if viewModel.filteredConversations.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bubble.right")
                        .font(.system(size: 48))
                        .foregroundColor(AppColors.textSecondary)
                    Text("No Messages")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    Text("Start a conversation to begin")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredConversations) { conversation in
                            Button(action: {
                                selectedConversation = conversation
                                viewModel.loadMessages(for: conversation)
                            }) {
                                ConversationRow(conversation: conversation)
                            }
                            .foregroundColor(.primary)
                            
                            Divider()
                                .padding(.horizontal, 12)
                        }
                    }
                }
            }
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: conversation.participant.profileImageURL)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.participant.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(conversation.lastMessage)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(timeString(from: conversation.timestamp))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                
                if conversation.unreadCount > 0 {
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Text("\(conversation.unreadCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
    }
    
    private func timeString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
}

struct ChatDetailView: View {
    @Binding var conversation: Conversation?
    @ObservedObject var viewModel: MessagesViewModel
    @State private var messageText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        if message.sender.id == MockData.currentUser.id {
                            HStack {
                                Spacer()
                                MessageBubble(
                                    message: message,
                                    isCurrentUser: true
                                )
                            }
                        } else {
                            HStack {
                                MessageBubble(
                                    message: message,
                                    isCurrentUser: false
                                )
                                Spacer()
                            }
                        }
                    }
                }
                .padding(12)
            }
            
            Divider()
            
            // Message Input
            HStack(spacing: 8) {
                TextField("Type a message...", text: $messageText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(AppColors.background)
                    .cornerRadius(20)
                    .font(.system(size: 14, weight: .regular))
                
                Button(action: {
                    if !messageText.isEmpty, let participant = conversation?.participant {
                        viewModel.sendMessage(messageText, to: participant)
                        messageText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(AppColors.primary)
                        .frame(width: 36, height: 36)
                        .background(AppColors.background)
                        .cornerRadius(18)
                }
            }
            .padding(12)
            .background(AppColors.cardBackground)
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        Text(message.content)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(isCurrentUser ? .white : AppColors.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isCurrentUser ? AppColors.primary : AppColors.background)
            .cornerRadius(12)
            .frame(maxWidth: 250, alignment: .leading)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search conversations", text: $text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(AppColors.textPrimary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
