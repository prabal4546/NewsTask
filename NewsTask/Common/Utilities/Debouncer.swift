//
//  Debouncer.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 20/11/22.
//

import Foundation

public class Debouncer {
    private let timeInterval: TimeInterval
    private var timer: Timer?
    typealias Handler = () -> Void
    var handler: Handler?
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        })
    }
    
     private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else { return }
        handler?()
        handler = nil
    }
}
