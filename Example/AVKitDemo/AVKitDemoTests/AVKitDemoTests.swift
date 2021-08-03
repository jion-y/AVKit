import LYAVKit
import XCTest

class AVKitDemoTests: XCTestCase {
    private var array: ThreadSafeArray<Int>? = ThreadSafeArray<Int>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.array? = ThreadSafeArray<Int>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.array = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

//        var index: Int = -1
//        while index < 100000 {
//            index = index + 1
//            self.array?.append(index)
//            DispatchQueue.global().async {
//                if index % 10 == 0  {
//                    self.array?[index] = -100
//                }
//            }
//            DispatchQueue.global().async {
//                print("start print value")
//                self.array?.forEach { value in
//                    print("value = \(value)")
//                }
//                print("end print value")
//            }
//        }
        for index in 0...500 {
            DispatchQueue.global().async {
                self.array?.append(index)
            }
        }
        
        for index in 500...1000 {
            DispatchQueue.global().async {
                self.array?.append(index)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            self.array?.forEach { value in
                
            }
        }
    }
}
