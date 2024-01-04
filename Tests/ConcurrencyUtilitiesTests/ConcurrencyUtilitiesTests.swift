import XCTest
@testable import ConcurrencyUtilities

final class ConcurrencyUtilitiesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(ConcurrencyUtilities().text, "Hello, World!")
        self.performOnce(token: .fileAndLine) {
            print("go")
        }
        self.performOnce(token: "a") {
            print("a")
        }
        self.performOnce(token: "a") {
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
