//
//  MessageHeaderTests.swift
//  BitcoinSwift
//
//  Created by Kevin Greene on 8/24/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import Foundation
import XCTest

class MessageHeaderTests: XCTestCase {

  let network = Message.Network.MainNet
  let command = Message.Command.Version
  let headerBytes: [UInt8] = [
      0xf9, 0xbe, 0xb4, 0xd9, // network (little-endian)
      0x76, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x00, 0x00, 0x00, 0x00, 0x00, // "version" command
      0x02, 0x00, 0x00, 0x00, // payload size (little-endian)
      0xf1, 0x58, 0x13, 0xfa] // payload checksum

  func testMessageHeaderEncoding() {
    let header = Message.Header(network:network,
                                command:command,
                                payloadLength:2,
                                payloadChecksum:0xfa1358f1)
    let expectedHeaderData = NSData(bytes:headerBytes, length:headerBytes.count)
    let actualHeaderData = header.data
    XCTAssertEqual(actualHeaderData, expectedHeaderData,
                   "\n[FAIL] Invalid encoded header \(header.data)")
  }

  func testMessageHeaderDecoding() {
    let headerData = NSData(bytes:headerBytes, length:headerBytes.count)
    if let header = Message.Header.fromData(headerData) {
      XCTAssertEqual(header.network, network,
                     "\n[FAIL] Invalid network \(header.network)")
      XCTAssertEqual(header.command, command,
                     "\n[FAIL] Invalid command \(header.command)")
    } else {
      XCTFail("\n[FAIL] Failed to parse message header")
    }
  }

  func testEmptyData() {
    if let header = Message.Header.fromData(NSData()) {
      XCTFail("\n[FAIL] Header should be nil")
    }
  }
}
