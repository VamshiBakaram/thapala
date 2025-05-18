

import Foundation
import SwiftUICore

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @ObservedObject var homePostboxViewModel = HomePostboxViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    private let url = URL(string: "wss://tapi.ahexlab.com/chat")!  // Use "wss" for secure WebSocket.
    @Published var receivedMessages: [String] = []
    @Published var isConnected: Bool = false

    func connect() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        receive()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }

    func send(message: String) {
        let msg = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(msg) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
                self?.isConnected = false
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.receivedMessages.append(text)
                        self?.homePostboxViewModel.getAllChats(senderID: (self?.sessionManager.userId)!, recieverId: (self?.homePostboxViewModel.selectID)!)
                    }
                case .data(let data):
                    print("Received binary data: \(data)")
                @unknown default:
                    print("Received unknown message format.")
                }
                self?.receive()  // Keep listening!
            }
        }
    }
}
