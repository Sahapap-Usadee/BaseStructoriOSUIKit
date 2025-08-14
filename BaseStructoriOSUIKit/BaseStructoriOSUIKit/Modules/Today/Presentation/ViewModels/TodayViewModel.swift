//
//  TodayViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 14/8/2568 BE.
//

import Foundation
import Combine

class TodayViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var todayCards: [TodayCard] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedCard: TodayCard?
    @Published var showingDetail: Bool = false
    
    // MARK: - Input Publishers
    private let loadDataSubject = PassthroughSubject<Void, Never>()
    private let cardSelectedSubject = PassthroughSubject<TodayCard, Never>()
    private let refreshSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    var loadDataRequested: AnyPublisher<Void, Never> {
        loadDataSubject.eraseToAnyPublisher()
    }
    
    var cardSelected: AnyPublisher<TodayCard, Never> {
        cardSelectedSubject.eraseToAnyPublisher()
    }
    
    var refreshRequested: AnyPublisher<Void, Never> {
        refreshSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupBindings()
        loadTodayCards()
    }
    
    // MARK: - Public Methods
    func loadTodayCards() {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.todayCards = TodayCard.sampleData
            self?.isLoading = false
        }
    }
    
    func selectCard(_ card: TodayCard) {
        selectedCard = card
        showingDetail = true
        cardSelectedSubject.send(card)
    }
    
    func refresh() {
        refreshSubject.send()
        loadTodayCards()
    }
    
    func dismissDetail() {
        showingDetail = false
        selectedCard = nil
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Handle load data requests
        loadDataRequested
            .sink { [weak self] in
                self?.loadTodayCards()
            }
            .store(in: &cancellables)
        
        // Handle refresh requests
        refreshRequested
            .sink { [weak self] in
                self?.loadTodayCards()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Card Animation Helpers
extension TodayViewModel {
    func getCardCornerRadius(for type: TodayCardType) -> CGFloat {
        switch type {
        case .featured:
            return 20
        case .story, .appOfTheDay:
            return 16
        case .gameOfTheDay, .collection:
            return 14
        }
    }
    
    func getCardHeight(for type: TodayCardType) -> CGFloat {
        switch type {
        case .featured:
            return 400
        case .story:
            return 300
        case .appOfTheDay, .gameOfTheDay:
            return 250
        case .collection:
            return 320
        }
    }
}
