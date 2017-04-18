//: Playground - noun: a place where people can play

import UIKit

var str = "集合类型背后的\"轮子\""

// 可以被顺序访问的一系列数据的实现

protocol IteratorProtocol {
    associatedtype Element
    
    mutating func next() -> Element?
}

protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    
    func makeIterator() -> Iterator
}

let numbers = [1, 2, 3, 4, 5]

var begin = numbers.makeIterator()

while let number = begin.next() {
    print(number)
}

/*:
 * ## 存储容器和访问方法的胶着剂 - Iterator
 * 一方面, Iterator 要知道序列中元素的类型
 * 另一方面, Iterator 还要有一个可以不断访问下一个元素的方法
 */

// 定义一个 Fibonacci 数列的集合类型

struct FiboIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        
        let nextValue = state.0
        state = (state.1, state.0 + state.1)
        
        return nextValue
    }
}

struct Fibonacci: Sequence {
    
    func makeIterator() -> FiboIterator {
        
        return FiboIterator()
    }
}

let fib = Fibonacci()
var fibIter = fib.makeIterator()
var i = 1

while let value = fibIter.next(), i != 10 {
    print(value)
    i += 1
}

//struct Fibonacci: Sequence {
//    
//    typealias Element = Int
//    
//    func makeIterator() -> AnyIterator<Element> {
//        
//        return AnyIterator(FiboIterator())
//    }
//}


// 实现一个 queue

protocol Queue {
    
    associatedtype Element
    
    mutating func push(_ element: Element)
    
    mutating func pop() -> Element?
}

struct FIFOQueue<Element>: Queue {
    
    
    fileprivate var storage: [Element] = []
    
    fileprivate var operation: [Element] = []
    
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    mutating func pop() -> Element? {
        if operation.isEmpty {
            operation = storage.reversed()
            storage.removeAll()
        }
        
        return operation.popLast()
    }
}

extension FIFOQueue: Collection {
    
    //    为了让一个类型适配Collection，我们最少做三件事情就好了：
    //
    //    定义startIndex和endIndex属性，表示集合起始和结束位置；
    //    定义一个只读的下标操作符；
    //    实现一个index(after:)方法用于在集合中移动索引位置；
    
    public var startIndex: Int { return 0 }
    
    public var endIndex: Int {
        return operation.count + storage.count
    }
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        
        return i + 1
    }
    
    public subscript(pos: Int) -> Element {
        precondition((startIndex..<endIndex).contains(pos),
                     "Out of range")
        
        if pos < operation.endIndex {
            return operation[operation.count - 1 - pos]
        }
        
        return storage[pos - operation.count]
    }

}

var numberQueue = FIFOQueue<Int>()
for i in 1 ... 10 {
    numberQueue.push(i)
}
for i in numberQueue {
    print(i)
}

var numberArray = Array<Int>()
numberArray.append(contentsOf: numberQueue)

numberQueue.isEmpty
numberQueue.count
numberQueue.first

numberQueue.map { $0 * 2 }

extension FIFOQueue: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Element...) {
        self.init(storage: [], operation: elements.reversed())
    }
}


var numberQueue2 = FIFOQueue.init(arrayLiteral: [11, 12, 13, 14])
print(numberQueue2.pop())




