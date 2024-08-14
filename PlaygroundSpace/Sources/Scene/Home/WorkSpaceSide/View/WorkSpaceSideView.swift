//
//  WorkSpaceSideView.swift
//  PlaygroundSpace
//
//  Created by 김진수 on 8/5/24.
//

import SwiftUI
import ComposableArchitecture

struct WorkSpaceSideView: View {
    @Perception.Bindable var store: StoreOf<WorkSpaceSideFeature>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack {
                    fakeNavigation()
                    contentView()
                    workSpaceAddView()
                        .asButton {
                            store.send(.sendToMakeWorkSpace)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.vertical, 10)
                    workSpaceHelpView()
                        .asButton {
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.vertical, 10)
                        .padding(.bottom, 20)
                    Spacer()
                }
            }
            .sheet(item: $store.scope(state: \.workSpaceCreateState, action: \.workSpaceCreateAction), content: { store in
                WorkSpaceCreateView(store: store)
            })
            .onAppear {
                store.send(.onAppear)
            }
//            .confirmationDialog($store.scope(state: \.alertSheet, action: \.alertSheetAction))
            .sheet(item: $store.scope(state: \.workSpaceCreateState, action: \.workSpaceCreateAction), content: { store in
                WorkSpaceCreateView(store: store)
            })
            .sheet(item: $store.scope(state: \.workSpaceChangeOwnerState, action: \.workSpaceChangeOwnerAction), content: { store in
                ChannelOwnerView(store: store)
            })
            .confirmationDialog("title", isPresented: $store.editIsOpen, titleVisibility: .hidden) {
                if store.isOwner {
                    Button("워크스페이스 편집") {
                        store.send(.workSpaceEditType(.workSpaceEdit))
                    } // 첫 번째 버튼
                    Button("워크스페이스 나가기") {
                        store.send(.workSpaceEditType(.workSpaceOut))
                    } // 두 번째 버튼
                    Button("워크스페이스 관리자 변경") {
                        store.send(.workSpaceEditType(.workSpaceChangeOwner))
                    } // 두 번째 버튼
                    Button("워크스페이스 삭제") {
                        store.send(.workSpaceEditType(.workSpaceDelete))
                    } // 두 번째 버튼
                } else {
                    Button("워크스페이스 나가기") {
                        store.send(.workSpaceEditType(.workSpaceOut))
                    }
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
}
extension WorkSpaceSideView {
    @ViewBuilder
    private func contentView() -> some View {
        switch store.currentCase {
        case .loading:
            ProgressView()
        case .empty:
            VStack {
                Spacer()
                Text("워크스페이스를\n찾을 수 없어요.")
                    .setTextStyle(type: .title1)
                    .foregroundStyle(.brBlack)
                    .multilineTextAlignment(.center)
                Text("관리자에게 초대를 요청하거나,\n다른이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.")
                    .setTextStyle(type: .body)
                    .foregroundStyle(.brBlack)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 12)
                Button {
                    store.send(.sendToMakeWorkSpace)
                } label: {
                    Text("워크스페이스 생성")
                        .asText(type: .title2, foreColor: .brWhite, backColor: .brGreen)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
//                Spacer()
            }
        case .over:
            List {
                ForEach(store.currentModels, id: \.workspaceID) { item in
                    makeWorkSpaceListView(item)
                }
            }
            .listStyle(.plain)
        }
    }
}

extension WorkSpaceSideView {
    
    private func makeWorkSpaceListView(_ model: WorkspaceListEntity) -> some View {
        HStack {
            HStack {
                Group {
                    if let url = URL(string: model.coverImage) {
                        DownSamplingImageView(url: url, size: CGSize(width: 44, height: 44))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(model.name)
                        .setTextStyle(type: .title2)
                        .foregroundStyle(.tePrimary)
                    Text(model.createdAt)
                        .setTextStyle(type: .body)
                        .foregroundStyle(.teSecondary)
                }
            }
            .onTapGesture {
                store.send(.selectedModel(model))
            }
            
            Spacer()
            
            VStack (alignment: .trailing) {
                Image(ImageNames.dot)
                    .renderingMode(.template)
                    .foregroundStyle(.brBlack)
                    .padding(.vertical, 20)
                    .padding(.leading, 17)
                    .background(Color.white.opacity(0.2))
                
            }
            .onTapGesture {
                store.send(.workSpaceEditButtonTapped(model))
            }
        }
        .padding(.all, 10)
        .background(store.currentWorkSpaceID == model.workspaceID ? Color.green.opacity(0.1) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
}

extension WorkSpaceSideView {
    
    func workSpaceAddView() -> some View {
        HStack {
            Image(ImageNames.plus)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .padding(.horizontal, 10)
                .padding(.leading, 8)
            Text("워크 스페이스 추가")
                .setTextStyle(type: .body)
            Spacer()
        }
    }
    
    func workSpaceHelpView() -> some View {
        HStack {
            Image(ImageNames.help)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .padding(.horizontal, 10)
                .padding(.leading, 8)
            Text("도움말")
                .setTextStyle(type: .body)
            Spacer()
        }
    }
    
}

// 가짜 네비
extension WorkSpaceSideView {
    func fakeNavigation() -> some View {
        HStack {
            Text("워크스페이스")
                .setTextStyle(type: .title1)
                .foregroundStyle(.brBlack)
            Spacer()
        }
        .padding(.top, 60)
        .padding(.leading, 10)
        .padding(.bottom, 10)
        .background(Color.gray)
    }
}
