//
//  LoadingViewModel.swift
//  BaseStructoriOSUIKit
//
//  Created by sahapap on 8/8/2568 BE.
//

import UIKit
import Combine

class LoadingViewModel: ObservableObject {
    @Published var loadingProgress: Float = 0.0
    @Published var loadingText: String = "กำลังโหลด..."
    @Published var isLoading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private let loadingDuration: TimeInterval = 3.0
    
    // MARK: - Output Publishers
    private let loadingCompletedSubject = PassthroughSubject<Void, Never>()
    
    var loadingCompleted: AnyPublisher<Void, Never> {
        return loadingCompletedSubject.eraseToAnyPublisher()
    }
    
    func startLoading() -> AnyPublisher<Void, Never> {
        return Future { [weak self] promise in
            guard let self = self else { 
                promise(.success(()))
                return 
            }
            
            self.simulateLoading { 
                self.loadingCompletedSubject.send()
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func simulateLoading(completion: @escaping () -> Void) {
        let steps = ["เริ่มต้นแอปพลิเคชัน...", "โหลดข้อมูล...", "เตรียมหน้าจอหลัก...", "เสร็จสิ้น!"]
        let stepDuration = loadingDuration / Double(steps.count)
        
        Timer.publish(every: stepDuration / 10, on: .main, in: .common)
            .autoconnect()
            .scan(0) { count, _ in count + 1 }
            .sink { [weak self] count in
                guard let self = self else { return }
                
                let stepIndex = min(count / 10, steps.count - 1)
                let progressInStep = Float(count % 10) / 10.0
                
                self.loadingProgress = (Float(stepIndex) + progressInStep) / Float(steps.count)
                self.loadingText = steps[stepIndex]
                
                if count >= steps.count * 10 {
                    self.isLoading = false
                    completion()
                }
            }
            .store(in: &cancellables)
    }
}
