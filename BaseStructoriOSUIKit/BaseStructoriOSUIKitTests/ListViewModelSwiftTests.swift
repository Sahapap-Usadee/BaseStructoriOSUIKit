//
//  ListViewModelSwiftTests.swift
//  BaseStructoriOSUIKitTests
//
//  Created by sahapap on 4/9/2568 BE.
//

import Testing
import Combine
@testable import BaseStructoriOSUIKit

@Suite("ListViewModel Tests")
struct ListViewModelSwiftTests {
    
    let mockUserManager: MockUserManager
    let sut: ListViewModel
    
    init() {
        mockUserManager = MockUserManager()
        sut = ListViewModel(userManager: mockUserManager)
    }
    
    // MARK: - Initial State Tests
    
    @Test("Initial state should have correct default values")
    func initialState() {
        #expect(sut.title == "รายการ")
        #expect(sut.description == "จัดการรายการและแสดง Modal Presentations")
        #expect(sut.items.count == 5) // Should load initial data
        #expect(!sut.isLoading)
        #expect(sut.selectedItemCount == 0)
    }
    
    @Test("Initial items should be populated correctly")
    func initialItems() {
        #expect(sut.items.count == 5)
        #expect(sut.items[0].title == "รายการที่ 1")
        #expect(sut.items[0].subtitle == "รายละเอียดสำหรับรายการแรก")
        #expect(!sut.items[0].isSelected)
        
        #expect(sut.items[4].title == "รายการที่ 5")
        #expect(sut.items[4].subtitle == "รายละเอียดสำหรับรายการห้า")
        #expect(!sut.items[4].isSelected)
    }
    
    // MARK: - Modal Presentation Tests
    
    @Test("Show modal tapped should trigger modal request")
    func showModalTapped() {
        var modalRequested = false
        let cancellable = sut.modalRequested.sink { 
            modalRequested = true 
        }
        
        sut.showModalTapped()
        
        #expect(modalRequested)
        cancellable.cancel()
    }
    
    @Test("Show action sheet tapped should trigger action sheet request")
    func showActionSheetTapped() {
        var actionSheetRequested = false
        let cancellable = sut.actionSheetRequested.sink { 
            actionSheetRequested = true 
        }
        
        sut.showActionSheetTapped()
        
        #expect(actionSheetRequested)
        cancellable.cancel()
    }
    
    @Test("Show alert tapped should trigger alert request")
    func showAlertTapped() {
        var alertRequested = false
        let cancellable = sut.alertRequested.sink { 
            alertRequested = true 
        }
        
        sut.showAlertTapped()
        
        #expect(alertRequested)
        cancellable.cancel()
    }
    
    // MARK: - Item Management Tests
    
    @Test("Add new item should append item to list")
    func addNewItem() {
        let initialCount = sut.items.count
        
        sut.addNewItem()
        
        #expect(sut.items.count == initialCount + 1)
        #expect(sut.items.last?.title == "รายการใหม่ \(initialCount + 1)")
        #expect(sut.items.last?.isSelected == false)
        #expect(sut.items.last?.subtitle.contains("สร้างเมื่อ") == true)
    }
    
    @Test("Add multiple new items should work correctly")
    func addMultipleNewItems() {
        let initialCount = sut.items.count
        
        sut.addNewItem()
        sut.addNewItem()
        sut.addNewItem()
        
        #expect(sut.items.count == initialCount + 3)
        #expect(sut.items[initialCount].title == "รายการใหม่ \(initialCount + 1)")
        #expect(sut.items[initialCount + 1].title == "รายการใหม่ \(initialCount + 2)")
        #expect(sut.items[initialCount + 2].title == "รายการใหม่ \(initialCount + 3)")
    }
    
    // MARK: - Item Selection Tests
    
    @Test("Toggle item selection should update selection state")
    func toggleItemSelection() {
        let item = sut.items[0]
        #expect(!item.isSelected) // Initially not selected
        
        sut.toggleItemSelection(item)
        
        #expect(sut.items[0].isSelected) // Should be selected now
        #expect(sut.selectedItemCount == 1)
    }
    
    @Test("Toggle item selection multiple times should work correctly")
    func toggleItemSelectionMultipleTimes() {
        let item = sut.items[0]
        
        // First toggle - select
        sut.toggleItemSelection(item)
        #expect(sut.items[0].isSelected)
        #expect(sut.selectedItemCount == 1)
        
        // Second toggle - deselect
        sut.toggleItemSelection(item)
        #expect(!sut.items[0].isSelected)
        #expect(sut.selectedItemCount == 0)
    }
    
    @Test("Select multiple items should update count correctly")
    func selectMultipleItems() {
        sut.toggleItemSelection(sut.items[0])
        sut.toggleItemSelection(sut.items[1])
        sut.toggleItemSelection(sut.items[2])
        
        #expect(sut.selectedItemCount == 3)
        #expect(sut.items[0].isSelected)
        #expect(sut.items[1].isSelected)
        #expect(sut.items[2].isSelected)
        #expect(!sut.items[3].isSelected)
        #expect(!sut.items[4].isSelected)
    }
    
    @Test("Toggle non-existent item should not crash")
    func toggleNonExistentItem() {
        let nonExistentItem = ListItem(
            id: 999,
            title: "Non-existent",
            subtitle: "This item doesn't exist",
            isSelected: false
        )
        
        sut.toggleItemSelection(nonExistentItem)
        
        #expect(sut.selectedItemCount == 0)
        // Should not crash and selection count should remain 0
    }
    
    // MARK: - Delete Selected Items Tests
    
    @Test("Delete selected items should remove only selected items")
    func deleteSelectedItems() {
        // Select some items
        sut.toggleItemSelection(sut.items[0])
        sut.toggleItemSelection(sut.items[2])
        #expect(sut.selectedItemCount == 2)
        
        let remainingItem1 = sut.items[1]
        let remainingItem2 = sut.items[3]
        let remainingItem3 = sut.items[4]
        
        sut.deleteSelectedItems()
        
        #expect(sut.items.count == 3)
        #expect(sut.selectedItemCount == 0)
        #expect(sut.items.contains { $0.id == remainingItem1.id })
        #expect(sut.items.contains { $0.id == remainingItem2.id })
        #expect(sut.items.contains { $0.id == remainingItem3.id })
    }
    
    @Test("Delete selected items when none selected should not change list")
    func deleteSelectedItemsWhenNoneSelected() {
        let initialCount = sut.items.count
        
        sut.deleteSelectedItems()
        
        #expect(sut.items.count == initialCount)
        #expect(sut.selectedItemCount == 0)
    }
    
    @Test("Delete all items should clear the list")
    func deleteAllItems() {
        // Select all items
        for item in sut.items {
            sut.toggleItemSelection(item)
        }
        #expect(sut.selectedItemCount == 5)
        
        sut.deleteSelectedItems()
        
        #expect(sut.items.isEmpty)
        #expect(sut.selectedItemCount == 0)
    }
    
    // MARK: - Complex Workflow Tests
    
    @Test("Complex workflow: add, select, delete should work correctly")
    func complexWorkflow() {
        // Add new items
        sut.addNewItem()
        sut.addNewItem()
        #expect(sut.items.count == 7)
        
        // Select some items (including new ones)
        sut.toggleItemSelection(sut.items[0])
        sut.toggleItemSelection(sut.items[5]) // First new item
        sut.toggleItemSelection(sut.items[6]) // Second new item
        #expect(sut.selectedItemCount == 3)
        
        // Delete selected items
        sut.deleteSelectedItems()
        #expect(sut.items.count == 4)
        #expect(sut.selectedItemCount == 0)
    }
    
    // MARK: - Publisher Tests
    
    @Test("Modal requested publisher should emit correctly")
    func modalRequestedPublisher() {
        var emissionCount = 0
        let cancellable = sut.modalRequested.sink { _ in
            emissionCount += 1
        }
        
        sut.showModalTapped()
        sut.showModalTapped()
        sut.showModalTapped()
        
        #expect(emissionCount == 3)
        cancellable.cancel()
    }
    
    @Test("Action sheet requested publisher should emit correctly")
    func actionSheetRequestedPublisher() {
        var emissionCount = 0
        let cancellable = sut.actionSheetRequested.sink { _ in
            emissionCount += 1
        }
        
        sut.showActionSheetTapped()
        sut.showActionSheetTapped()
        
        #expect(emissionCount == 2)
        cancellable.cancel()
    }
    
    @Test("Alert requested publisher should emit correctly")
    func alertRequestedPublisher() {
        var emissionCount = 0
        let cancellable = sut.alertRequested.sink { _ in
            emissionCount += 1
        }
        
        sut.showAlertTapped()
        
        #expect(emissionCount == 1)
        cancellable.cancel()
    }
    
    // MARK: - Edge Cases Tests
    
    @Test("Large number of items should be handled correctly")
    func largeNumberOfItems() {
        // Add many items
        for _ in 1...100 {
            sut.addNewItem()
        }
        
        #expect(sut.items.count == 105) // 5 initial + 100 new
        
        // Select every 10th item
        for i in stride(from: 0, to: sut.items.count, by: 10) {
            sut.toggleItemSelection(sut.items[i])
        }
        
        #expect(sut.selectedItemCount == 11) // 0, 10, 20, ..., 100 (11 items)
        
        // Delete selected items
        sut.deleteSelectedItems()
        
        #expect(sut.items.count == 94) // 105 - 11 = 94
        #expect(sut.selectedItemCount == 0)
    }
}
