//
//  ThreadSafeHashTable.swift
//  LYAVKit
//
//  Created by liuming on 2021/8/4.
//

import Foundation

// MARK: - ThreadSafeHashTable

public class ThreadSafeHashTable<T> where T:AnyObject {
    private var hashTable = NSHashTable<T>(options: .weakMemory, capacity: 20)
    private var lock = pthread_rwlock_t()
    init() {
        let status = pthread_rwlock_init(&lock, nil)
        assert(status == 0)
    }
    deinit {
        pthread_rwlock_destroy(&lock)
    }
}

public extension ThreadSafeHashTable {
    var count: Int {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.count
        pthread_rwlock_unlock(&lock)
        return result
    }

    var anyObject: T? {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.anyObject
        pthread_rwlock_unlock(&lock)
        return result
    }

    var allObjects: [T] {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.allObjects
        pthread_rwlock_unlock(&lock)
        return result
    }

    var setRepresentation: Set<AnyHashable> {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.setRepresentation
        pthread_rwlock_unlock(&lock)
        return result
    }

    var pointerFunctions: NSPointerFunctions {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.pointerFunctions
        pthread_rwlock_unlock(&lock)
        return result
    }

    var objectEnumerator: NSEnumerator {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.objectEnumerator()
        pthread_rwlock_unlock(&lock)
        return result
    }
}

public extension ThreadSafeHashTable {
    func member(object: T) -> T? {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.member(object)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func add(_ object: T) {
        pthread_rwlock_wrlock(&lock)
        hashTable.add(object)
        pthread_rwlock_unlock(&lock)
    }

    func remove(_ object: T) {
        pthread_rwlock_wrlock(&lock)
        hashTable.remove(object)
        pthread_rwlock_unlock(&lock)
    }

    func removeAll() {
        pthread_rwlock_wrlock(&lock)
        hashTable.removeAllObjects()
        pthread_rwlock_unlock(&lock)
    }

    func contains(_ object: T) -> Bool {
        pthread_rwlock_rdlock(&lock)
        let result = hashTable.contains(object)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func intersects(hashTable: ThreadSafeHashTable<T>) -> Bool {
        pthread_rwlock_rdlock(&lock)
        let result = self.hashTable.intersects(hashTable.hashTable)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func isEqual(hashTable: ThreadSafeHashTable<T>) -> Bool {
        pthread_rwlock_rdlock(&lock)
        let result = self.hashTable.isEqual(to: hashTable.hashTable)
        pthread_rwlock_unlock(&lock)
        return result
    }
    func union(hasTable:ThreadSafeHashTable<T>) {
        pthread_rwlock_wrlock(&lock)
        self.hashTable.union(hasTable.hashTable)
        pthread_rwlock_unlock(&lock)
    }
    func minus(hasTable:ThreadSafeHashTable<T>) {
        pthread_rwlock_wrlock(&lock)
        self.hashTable.minus(hasTable.hashTable)
        pthread_rwlock_unlock(&lock)
    }
}

public extension ThreadSafeHashTable {
    func forEach(_ body: (T?) -> Void) {
        pthread_rwlock_rdlock(&lock)
       let enumerator = self.hashTable.objectEnumerator()
        var index = self.hashTable.count
        while index > 0 {
            let next = enumerator.nextObject()
            if next != nil {
                body(next as? T)
            }
            index -= 1
        }
        pthread_rwlock_unlock(&lock)
    }
}
