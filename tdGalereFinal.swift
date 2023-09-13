import SwiftUI

struct ContentView: View {
    @State private var grid = ["", "", "", "", "", "", "", "", ""]
    @State private var currentPlayer = "X"
    @State private var showingpopover = false
    @State private var showingpopoverselect = true
    @State private var phrase = ""
    @State private var playing = true
    @State private var winningCells: [Int] = []

    var body: some View {
        VStack {
            Text("Morpion")
                .font(.largeTitle)
                .padding(.top, 30)

            Text("C'est au tour de : " + currentPlayer)

            Spacer()

            VStack(spacing: 1) {
                ForEach(0..<3) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<3) { col in
                            Button(action: {
                                if playing {
                                    if grid[row * 3 + col].isEmpty {
                                        grid[row * 3 + col] = currentPlayer
                                        winVerif()
                                        drawVerif()
                                        togglePlayer()
                                    }
                                }
                            }) {
                                Text(grid[row * 3 + col])
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 100)
                                    .background(
                                        winningCells.contains(row * 3 + col) ? Color.red : Color.black
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(0)
                            }
                        }
                    }
                }
            }
            .cornerRadius(15)

            Spacer()

            Button("Recommencer") {
                showingpopoverselect = true
                grid = ["", "", "", "", "", "", "", "", ""]
                playing = true
                winningCells = []
            }
            .foregroundColor(.black)
        }

        .popover(isPresented: $showingpopover) {
            Text(phrase)
                .font(.headline)
                .padding()
        }
        
        
        .popover(isPresented: $showingpopoverselect) {
            Text("Qui commence ?")
                .font(.headline)
                .padding()
            
            HStack{
                Button("X"){
                    currentPlayer = "X"
                    showingpopoverselect = false
                }
                .buttonStyle(.bordered)
                Button("O"){
                    currentPlayer = "O"
                    showingpopoverselect = false
                }
                .buttonStyle(.bordered)
            }
            
        }
        
        
    }

    private func togglePlayer() {
        currentPlayer = (currentPlayer == "X") ? "O" : "X"
    }

    private func winVerif() {
        print("vérif joueur " + currentPlayer + "...")
        let win = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]

        for sequence in win {
            var playerWon = true

            for index in sequence {
                if grid[index] != currentPlayer {
                    playerWon = false
                    break
                }
            }

            if playerWon {
                print("gagné")
                phrase = ("Joueur " + currentPlayer + " à gagné !")
                showingpopover = true
                playing = false
                winningCells = sequence // Marquer les cellules gagnantes en rouge
                break
            }
        }
    }

    private func drawVerif() {
        let allNonEmpty = grid.allSatisfy { element in
            return !element.isEmpty
        }

        if allNonEmpty && playing {
            print("full")
            phrase = "Égalité"
            playing = false
            showingpopover = true
        } else {
            print("not full")
        }
    }
}
