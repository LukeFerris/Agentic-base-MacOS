import XCTest
@testable import Flow

final class FlowAppTests: XCTestCase {
    func testAppCreation() {
        let app = FlowApp()
        XCTAssertNotNil(app)
    }

    func testAppBody() {
        let app = FlowApp()
        XCTAssertNotNil(app.body)
    }
}
