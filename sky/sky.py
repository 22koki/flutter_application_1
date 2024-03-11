board = []
for i in range(8):
    board.append(["."] * 8)

def create_piece(piece_type, color, x, y):
    return {"type": piece_type, "color": color, "x": x, "y": y}

pieces = []
pieces.append(create_piece("♚", "White", 0, 0))  # King
pieces.append(create_piece("♟", "Black", 6, 5))  # Pawn

def is_valid_move(piece, x, y):
    # Add code to check if the move is valid based on the piece type and the game rules
    # For now, let's assume all moves are valid
    return True

def move_piece(piece, x, y):
    # Update the piece's position on the board
    piece["x"] = x
    piece["y"] = y

def print_board():
    # Print the game board
    print("  a b c d e f g h")
    print(" +----------------")
    for i in range(8):
        print(f"{8 - i}|", end=" ")
        for j in range(8):
            piece = None
            for p in pieces:
                if p["x"] == j and p["y"] == i:
                    piece = p
                    break
            if piece:
                print(piece["type"], end=" ")
            else:
                print(board[i][j], end=" ")
        print("|")
    print(" +----------------")

def main():
    while True:
        print_board()
        
        # Prompt the user to select a piece and enter its destination coordinates
        piece_index = int(input("Enter the index of the piece you want to move: "))
        
        # Check if the piece_index is valid
        if 0 <= piece_index < len(pieces):
            x = int(input("Enter the x-coordinate of the destination: "))
            y = int(input("Enter the y-coordinate of the destination: "))
            
            # Move the piece
            move_piece(pieces[piece_index], x, y)
            
            # Check if the move is valid
            if is_valid_move(pieces[piece_index], x, y):
                print("Valid move")
            else:
                print("Invalid move")
        else:
            print("Invalid piece index. Please enter a valid index.")

if __name__ == "__main__":
    main()
