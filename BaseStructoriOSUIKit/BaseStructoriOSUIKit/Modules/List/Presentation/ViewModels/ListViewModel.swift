//
//  ListViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import Foundation
import Combine

class ListViewModel: ObservableObject {

    // MARK: - Services
    public let userService: UserServiceProtocol
    // MARK: - Published Properties
    @Published var title: String = "รายการ"
    @Published var description: String = "จัดการรายการและแสดง Modal Presentations"
    @Published var items: [ListItem] = []
    @Published var isLoading: Bool = false
    @Published var selectedItemCount: Int = 0
    
    // MARK: - Input Publishers
    private let modalRequestedSubject = PassthroughSubject<Void, Never>()
    private let actionSheetRequestedSubject = PassthroughSubject<Void, Never>()
    private let alertRequestedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    var modalRequested: AnyPublisher<Void, Never> {
        modalRequestedSubject.eraseToAnyPublisher()
    }
    
    var actionSheetRequested: AnyPublisher<Void, Never> {
        actionSheetRequestedSubject.eraseToAnyPublisher()
    }
    
    var alertRequested: AnyPublisher<Void, Never> {
        alertRequestedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol) {
        self.userService = userService
        loadInitialData()
    }
    
    // MARK: - Public Methods
    func showModalTapped() {
        modalRequestedSubject.send()
    }
    
    func showActionSheetTapped() {
        actionSheetRequestedSubject.send()
    }
    
    func showAlertTapped() {
        alertRequestedSubject.send()
    }
    
    func addNewItem() {
        let newItem = ListItem(
            id: items.count + 1,
            title: "รายการใหม่ \(items.count + 1)",
            subtitle: "สร้างเมื่อ \(Date().formatted())",
            isSelected: false
        )
        items.append(newItem)
    }
    
    func toggleItemSelection(_ item: ListItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isSelected.toggle()
            selectedItemCount = items.filter { $0.isSelected }.count
        }
    }
    
    func deleteSelectedItems() {
        items.removeAll { $0.isSelected }
        selectedItemCount = 0
    }
    
    // MARK: - Private Methods
    private func loadInitialData() {
        items = [
            ListItem(id: 1, title: "รายการที่ 1", subtitle: "รายละเอียดสำหรับรายการแรก", isSelected: false),
            ListItem(id: 2, title: "รายการที่ 2", subtitle: "รายละเอียดสำหรับรายการสอง", isSelected: false),
            ListItem(id: 3, title: "รายการที่ 3", subtitle: "รายละเอียดสำหรับรายการสาม", isSelected: false),
            ListItem(id: 4, title: "รายการที่ 4", subtitle: "รายละเอียดสำหรับรายการสี่", isSelected: false),
            ListItem(id: 5, title: "รายการที่ 5", subtitle: "รายละเอียดสำหรับรายการห้า", isSelected: false)
        ]
    }
}

// MARK: - List Item Model
struct ListItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let subtitle: String
    var isSelected: Bool
}
