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

// MARK: - Properties

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

// MARK: - Immutable

public extension ThreadSafeArray {
    func first(where predicate: (Element)->Bool)->Element? {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let result = array.first(where: predicate)
        return result
    }

    func last(where predicate: (Element)->Bool)->Element? {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let result = array.last(where: predicate)
        return result
    }

    func filter(isIncluded: @escaping (Element)->Bool) ->ThreadSafeArray<Element> {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let result = array.filter(isIncluded)
        return ThreadSafeArray(array: result)
    }

    func index(where predicate: (Element)->Bool)-> Int? {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.firstIndex(where: predicate)
    }

    func sorted(by areInIncreasingOrder: (Element, Element)->Bool)->ThreadSafeArray<Element> {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let result = array.sorted(by: areInIncreasingOrder)
        return ThreadSafeArray<Element>(array: result)
    }

    func map<T>(_ transform: @escaping (Element)->T) ->[T] {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.map(transform)
    }

    func compactMap<T>(_ transform: (Element)->T)->[T] {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.compactMap(transform)
    }

    func reduce<T>(initialResult: T, _ nexPartialResult: @escaping (T, Element)->T)->T {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.reduce(initialResult, nexPartialResult)
    }

    func forEach(_ body: (Element)->Void) {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        array.forEach(body)
    }

    func contains(where predicate: (Element)->Bool)->Bool {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.contains(where: predicate)
    }

    func allSatisfy(_ predicate: (Element)->Bool)->Bool {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return array.allSatisfy(predicate)
    }
}

// MARK: - Mutable

public extension ThreadSafeArray {
    func append(_ element: Element) {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        array.append(element)
    }

    func append(_ elements: [Element]) {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        array += elements
    }

    func insert(_ element: Element, at index: Int) {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        array.insert(element, at: index)
    }

    func remove(at index: Int, completion: ((Element)->Void)? = nil) {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        if index > 0, index < count {
            let e = array.remove(at: index)
            completion?(e)
        }
    }

    func remove(where predicate: @escaping (Element)->Bool, completion: (([Element])->Void)? = nil) {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        var elements = [Element]()
        while let index = array.firstIndex(where: predicate) {
            elements.append(array.remove(at: index))
        }
        completion?(elements)
    }

    func removeAll(completion: (([Element])->Void)? = nil) {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        let elements = array
        array.removeAll()
        completion?(elements)
    }
}
public extension ThreadSafeArray {
    subscript(index: Int) -> Element? {
            get {
                pthread_rwlock_rdlock(&lock)
                defer {
                    pthread_rwlock_unlock(&lock)
                }
                var result: Element?
                guard self.array.startIndex..<self.array.endIndex ~= index else { return nil }
                result = self.array[index]
                return result
            }
            set {
                
                pthread_rwlock_wrlock(&lock)
                defer {
                    pthread_rwlock_unlock(&lock)
                }
                guard let newValue = newValue else { return }
                self.array[index] = newValue
            }
        }
}
// MARK: - Equatable
public extension ThreadSafeArray where Element: Equatable {
    
    func contains(_ element: Element) -> Bool {
        pthread_rwlock_rdlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        return self.array.contains(element)
    }
}

// MARK: - Infix operators
public extension ThreadSafeArray {
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The element to append to the array.
    static func +=(left: inout ThreadSafeArray, right: Element) {
        left.append(right)
    }
    
    /// Adds new elements at the end of the array.
    ///
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The elements to append to the array.
    static func +=(left: inout ThreadSafeArray, right: [Element]) {
        left.append(right)
    }
}
