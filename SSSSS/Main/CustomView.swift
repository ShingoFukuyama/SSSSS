//
//  CustomView.swift
//  SSSSS
//
//  Created by Shingo Fukuyama on 2025/12/09.
//

import SwiftUI

struct CustomView: View {
    @ObservedObject var store: CustomViewState

    init(store: CustomViewState) {
        self.store = store
    }

    var body: some View {
        VStack {
            Divider()

            Text("Count: \(store.state.count)")
            buttonView(title: "Increment!") {
                store.send(.incrementCount)
            }

            Divider()

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(store.state.posts) { post in
                        postView(id: post.id, title: post.title)
                            .frame(maxWidth: 350, alignment: .leading)
                            .padding(8)
                    }
                }
            }
            .frame(maxHeight: 300)
            .border(Color.black, width: 2)
            buttonView(title: "Fetch Post!") {
                store.send(.fetchPosts)
            }

            Divider()

            if let errorMessage = store.state.errorMessage {
                Text("Error: \(errorMessage)")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func postView(id: Int, title: String) -> some View {
        HStack(alignment: .top) {
            Text("\(id):")
            Text("\(title)")
        }
    }

    private func buttonView(title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(Color.white)
                .padding(8)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.green)
        )
    }
}
