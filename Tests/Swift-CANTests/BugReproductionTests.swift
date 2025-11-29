import XCTest
@testable import Swift_CAN

final class BugReproductionTests: XCTestCase {

    // Bug 1: Extended ID Ambiguity
    // Now fixed by passing `extended: true` to the initializer.
    func testExtendedIDAmbiguity() {
        let idValue: UInt32 = 0x123
        // We explicitly specify this is an extended frame.
        let frame = CAN.Frame(id: idValue, padded: [], extended: true)

        // Expected result for 29-bit addressing swap:
        // 0x00000123 -> Bytes: 00 00 01 23.
        // Swap Target/Source (Byte 2 and 3) -> 00 00 23 01 -> 0x2301.
        let expectedOriginator: UInt32 = 0x2301

        XCTAssertTrue(frame.isExtended, "Frame should be marked as extended")
        XCTAssertEqual(frame.originator, expectedOriginator, "Extended ID 0x123 should have originator 0x2301")
    }

    // Bug 2: Padded Init DLC
    // Now fixed by truncating data > 8 bytes.
    func testPaddedInitDLC() {
        let longData = [UInt8](repeating: 0x00, count: 9)
        let frame = CAN.Frame(id: 0x123, padded: longData)

        XCTAssertEqual(frame.dlc, 8, "Padded frame DLC should be 8")
        XCTAssertEqual(frame.data.count, 8, "Padded frame data count should be 8")
    }
}
