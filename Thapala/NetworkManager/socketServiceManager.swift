//
//  socketServiceManager.swift
//  Thapala
//
//  Created by Ahex-Guest on 18/04/25.
//

import Foundation
import SocketIO

class SocketManagerService {
    static let shared = SocketManagerService()
    
    private var manager: SocketIO.SocketManager?
    private var socket: SocketIOClient?
    
    private var pendingRoomId: String?
    private var pendingUserId: Int?

    private init() {}

    func establishConnection(token: String, roomId: String, userId: Int) {
        guard socket == nil else {
            // If already connected, join directly
            joinRoom(roomId: roomId, userId: userId)
            return
        }

        pendingRoomId = roomId
        pendingUserId = userId

        let url = URL(string: "https://tapi.ahexlab.com/chat")!
        let config: SocketIOClientConfiguration = [
            .log(true),
            .compress,
            .extraHeaders(["Authorization": "Bearer \(token)"])
        ]
        
        manager = SocketIO.SocketManager(socketURL: url, config: config)
        socket = manager?.defaultSocket
        
        socket?.on(clientEvent: .connect) { [weak self] data, ack in
            print("✅ Socket connected")
            // Now it's safe to join the room
            if let roomId = self?.pendingRoomId, let userId = self?.pendingUserId {
                self?.joinRoom(roomId: roomId, userId: userId)
            }
        }

        socket?.on(clientEvent: .disconnect) { data, ack in
            print("❌ Socket disconnected")
        }

        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
        socket = nil
        manager = nil
    }

    func isConnected() -> Bool {
        return socket?.status == .connected
    }

    func joinRoom(roomId: String, userId: Int) {
        guard let socket = socket, socket.status == .connected else {
            print("⚠️ Cannot join room: socket not connected.")
            return
        }

        let payload: [String: Any] = [
            "roomId": roomId,
            "userId": userId
        ]
        socket.emit("joinRoom", payload)
        print("📥 Joined room: \(roomId)")
    }

    func sendMessage(messageData: [String: Any]) {
        guard let socket = socket, socket.status == .connected else {
            print("⚠️ Socket not connected. Cannot send message.")
            return
        }
        socket.emit("sendMessage", messageData)
        print("📤 Sent message: \(messageData)")
    }

    func listenForMessages(callback: @escaping ([String: Any]) -> Void) {
        socket?.on("receive_message") { data, ack in
            if let message = data.first as? [String: Any] {
                print("📩 Received message: \(message)")
                callback(message)
            }
        }
    }
    
}
