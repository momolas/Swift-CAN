# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Build**: `swift build` - Compiles the Swift package
- **Test**: `swift test` - Runs all tests (currently 3 tests in FrameTests)
- **Clean**: `swift package clean` - Cleans build artifacts

## Architecture Overview

Swift-CAN is a Swift library providing protocols and types for Controller Area Network (CAN) Bus communication. The architecture follows these key patterns:

### Namespace Pattern
All types are organized under the `CAN` enum namespace (defined in Namespace.swift), preventing naming conflicts and providing clear API organization.

### Core Components

**CAN.Frame** (Frame.swift): The central data structure representing CAN bus frames with:
- Arbitration ID (11-bit or 29-bit addressing)
- Data Length Code (DLC) 
- Byte array data
- Timestamp for received frames
- Three initialization patterns: unpadded, padded, and DLC-specified
- Originator calculation for standard CAN/OBD2 addressing (swaps sender/receiver IDs)
- candump-compatible string formatting

**CAN.ArbitrationId** (Types.swift): UInt32 typealias with:
- Broadcast constants for 11-bit (0x7DF) and 29-bit (0x18DB33F1) addressing
- isBroadcast computed property

**CAN.Interface** (Interface.swift): Protocol defining CAN interface implementations with:
- Metadata properties (vendor, model, serialNumber) with default implementations
- Connection management (open/close with bitrate)
- Frame I/O operations (read with timeout, write)

**CAN.Error** (Error.swift): Comprehensive error enumeration covering platform support, interface discovery, configuration, I/O operations, and timeouts.

### Key Implementation Details

- Frame originator calculation handles both 11-bit (XOR with 0x08) and 29-bit (byte swapping) addressing schemes
- Interface protocol uses default implementations for metadata properties to reduce boilerplate
- Frame formatting matches candump output format for debugging compatibility
- Error handling covers both recoverable (read/write errors, timeouts) and non-recoverable (EOF) conditions

## Testing

Tests are located in Tests/Swift-CANTests/Frame.swift and focus on:
- Broadcast frame originator validation (should return nil)
- 11-bit addressing originator calculation
- 29-bit addressing originator calculation

The test suite validates the core addressing logic that enables bidirectional CAN communication by correctly identifying sender/receiver relationships.