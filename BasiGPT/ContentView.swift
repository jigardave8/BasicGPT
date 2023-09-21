import ChatGPTSwift
import SwiftUI

struct ContentView: View {
    let api = ChatGPTAPI(apiKey: "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")
    
    @State private var prompt = ""
    @State private var response = ""
    @State private var selectedText: String = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
            
            VStack {
                // Prompt text field
                TextField("Prompt", text: $prompt)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .allowsHitTesting(true) // Enable selection, copy, and highlight
                
                // Generate button
                Button(action: {
                    Task {
                        do {
                            let response = try await api.sendMessage(text: prompt)
                            self.response = response
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }) {
                    Text("Generate")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                
                // Response text field
                ScrollView {
                    Text(response)
                        .padding()
                        .allowsHitTesting(true) // Enable selection, copy, and highlight
                        .onTapGesture {
                            // Get the selected text range
                            let selectedTextRange = Range(uncheckedBounds: (lower: response.startIndex, upper: response.endIndex))
                            
                            // Get the selected text
                            selectedText = String(response[selectedTextRange])
                        }
                }
                // Added the following code to add copy and select functionality
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = selectedText
                    }) {
                        Text("Copy Selected Text")
                    }
                }
            }
            .padding()
        }
    }
}
