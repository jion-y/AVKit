//
//  ThreadSafeArray.swift
//  AVKit
//
//  Created by liuming on 2021/8/2.
//

import Foundation

// MARK: - ThreadSafeArray

public class ThreadSafeArray<Element> {
    private var array: [Element] = []
    private var lock = pthread_rwlock_t()

    public init() {}

    public convenience init(array: [Element]) {
        self.init()
        self.array = array
    }
}

public extension ThreadSafeArray {
    var first: Element? {
        var result: Element?
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        result = array.first
        return result
    }

    var last: Element? {
        var result: Element?
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        result = array.last
        return result
    }

    var count: Int {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.count
    }

    var isEmpty: Bool {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return (array.count > 0)
    }

    var description: String {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.description
    }
}

public extension ThreadSafeArray {
    func first(where predicate: (Element) -> Bool) -> Element? {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let result = array.first(where: predicate)
        return result
    }
    func last(where predicate:(Element)->Bool) -> Element? {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let result = array.last(where: predicate)
        return result
    }
    func filter(isIncluded:@escaping (Element)->Bool) ->ThreadSafeArray<Element> {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let result = array.filter(isIncluded)
        return ThreadSafeArray.init(array: result)
    }
    func index(where predicate:(Element)->Bool)-> Int? {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.firstIndex(where: predicate)
    }
}
