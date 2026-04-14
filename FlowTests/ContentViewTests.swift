import XCTest
@testable import Flow

final class ContentViewTests: XCTestCase {
    func testContentViewCreation() {
        let view = ContentView()
        XCTAssertNotNil(view)
    }

    func testContentViewBody() {
        let view = ContentView()
        XCTAssertNotNil(view.body)
    }
}
