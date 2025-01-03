// YOU MUST ADD YOUR OWN FILE PATH TO ENGINE



import java.util.LinkedList;
import java.io.*;
String playerMove = null; 
ChessEngine engine;
String fenToEngine = null;
boolean isEngineMoveRequested = false;
ArrayList<String> moves = new ArrayList<String>();
LinkedList<vistsPerMove> moveDataList = new LinkedList<>(); 
List<String> heatMapMoves = new ArrayList<>();             
HashMap<String, Integer[]> heatmapColors = new HashMap<>();
boolean isPromoting = false; // Indicates if a promotion is in progress
Piece promotingPiece = null; // The pawn being promoted
PImage[][] boardImages; // Array of images for board visualization
boolean showHeatmap = false;
HashMap<String, PImage> pieceImages = new HashMap<>(); // HashMap to store piece images
String evalText = "";          // Evaluation text from the engine
String displayedText = "";  // Text currently being displayed
int charIndex = 0;          // Current character index
int typingInterval = 20;   // Time (ms) between characters
int lastTypedTime = 0;      // Time since last character was added
boolean isTyping = false;   // Flag to control typing state
String evalNodes;
int charIndexNodes = 0;        // Current character index for nodes
int typingIntervalNodes = 10;  // Typing speed for nodes
int lastTypedTimeNodes = 0;    // Last time a character was added for nodes
boolean isTypingNodes = false; // Flag for typing nodes text
String visitsPm;
// Global variables for engine settings
float temperature = 0;       // Current temperature value (stored variable)
int moveTime = 1000;         // Current movetime (default to 1000ms)
int selectedDepth = 0;       // Current selected depth (default is 0)
boolean applyButtonHovered = false;
boolean isControlPanelVisible = false;  // Visibility flag for the control panel
//boolean isInformationTabVisible = false; // Removed information tab visibility flag

// Inside your main class, declare these variables at the top
float thermometerX = 180;    // X-coordinate of the thermometer
float thermometerY = 170;    // Y-coordinate of the thermometer
float thermometerWidth = 50; // Width of the thermometer
float thermometerHeight = 200; // Height of the thermometer


float sliderY;               // Y-coordinate of the slider
float sliderHeight = 20;     // Height of the slider
boolean isDragging = false;  // Whether the thermometer slider is being dragged

float minValue = 0.1;        // Minimum value of the thermometer
float maxValue = 10;         // Maximum value of the thermometer

int minMoveTime = 1000;      // Minimum movetime
int maxMoveTime = 10000;     // Maximum movetime
int buttonRadius = 50;      // Radius of the twistable button
float angle = -3.1;             // Angle of the twist
boolean isDragging2 = false; // Whether the twistable button is being dragged
PVector buttonCenter = new PVector(795, 370);        // Center position of the button

boolean exitButtonHovered = false;



  void sendEngineOptions() {
        // send temperature
     engine.sendUciCommand("setoption name Temperature value " + temperature);
        // send movetime
       
     engine.sendUciCommand("position startpos moves" + playerMove+
     
     "go movetime " + moveTime);
     
    
     
     

    }


//Control Panel drawing
void drawControlPanel() {
  background(255);
      
      // Draw control panel header
        fill(0);
        rect(0, 0, 1800, 40);
        PFont mono = createFont("blackBox.ttf", 25); // Use Arial as the font
        textFont(mono);
        fill(255);
        textAlign(CENTER, CENTER);
        text("Control Panel", width / 2, 20);
    
    // Draw thermometer
    drawThermometer();
    text("• Temapture determines how creative the engine is",100,500,210,220);
    text("• Change engine movetime ONLY APPLICABLE AT START OF GAME",700,500,180,200);
    
    // Draw twistable button for movetime
    drawTwistableButton();
    drawApplyButton();
    drawExitButton();
}

void drawExitButton() {
     // Check if mouse is over the button
    if (mouseX > 845 && mouseX < 845 + 180 && mouseY > 700 && mouseY < 700+100) {
        exitButtonHovered = true;
        fill(100, 149, 237);
    } else {
         exitButtonHovered = false;
       fill(200);
    }
    strokeWeight(2);
    rect(845,700,180,100, 20);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(" Exit", 935, 750);
}
//aplly to set settings
void drawApplyButton() {
   // Check if mouse is over the button
    if (mouseX > 605 && mouseX < 605 + 180 && mouseY > 700 - 40 && mouseY < 700+100) {
        applyButtonHovered = true;
        fill(100, 149, 237);
    } else {
        applyButtonHovered = false;
       fill(200);
    }
   rect(605,700,180,100, 20);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    strokeWeight(2);
     text(" Apply", 695, 750);
}
//void drawInformationTab() {
 // fill(255, 247, 227, 200);
 // rect(0, 0, width, height);
 //  // Draw control panel header
  //      fill(0);
 //       rect(0, 0, 1800, 40);
 //       PFont mono = createFont("blackBox.ttf", 25); // Use Arial as the font
 //       textFont(mono);
 //       fill(255);
  //      textAlign(CENTER, CENTER);
  //      text("Information", width / 2, 20);
  //      if (isTypingNodes) {
  //  // Add the next character if enough time has passed
 //   if (charIndexNodes < evalNodes.length() && millis() - lastTypedTimeNodes >= typingIntervalNodes) {
 //     displayedText += evalNodes.charAt(charIndexNodes); // Append the next character
 //     charIndexNodes++; // Move to the next character
 //     lastTypedTimeNodes = millis(); // Update the timer
 //   }

    // Display the progressively typed text
//    PFont mono;
//  // The font "andalemo.ttf" must be located in the
//  // current sketch's "data" directory to load successfully
 // mono = createFont("blackBox.ttf", 16);
 //   fill(0);
//    textFont(mono);
 //   text(displayedText, 47, 100,540,200);
 // }
//}
  
// Existing drawThermometer() and drawDepthButtons() methods from your control panel code here
void drawThermometer() {
    fill(200);
  strokeWeight(1);
  rect(thermometerX, thermometerY, thermometerWidth, thermometerHeight);
  strokeWeight(1);
  // Current temperature fill
  fill(150, 0, 0);
  rect(thermometerX, sliderY, thermometerWidth, thermometerHeight + thermometerY - sliderY);
  strokeWeight(1);
  // Slider
  fill(0);
  rect(thermometerX - 10, sliderY - sliderHeight / 2, thermometerWidth + 20, sliderHeight);
  strokeWeight(0);
  // Temperature text
  fill(0);
  textAlign(CENTER);
  textSize(16);
  text("Temperature: " + temperature + "°C", thermometerX + thermometerWidth / 2, thermometerY + thermometerHeight + 40);
}


void drawTwistableButton() {
  strokeWeight(2);
  fill(200);
  buttonCenter.x = 795;
  buttonCenter.y = 350;
  ellipse(buttonCenter.x, buttonCenter.y, buttonRadius * 2, buttonRadius * 2);
  fill(0);
  // Draw indicator
  float indicatorX = buttonCenter.x + cos(angle) * buttonRadius;
  float indicatorY = buttonCenter.y + sin(angle) * buttonRadius;
  stroke(0);
  strokeWeight(4);
  line(buttonCenter.x, buttonCenter.y, indicatorX, indicatorY);

  // Draw handle
  noStroke();
  fill(150, 0, 0);
  ellipse(indicatorX, indicatorY, 10, 10);

  // Display movetime value
  strokeWeight(4);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("MoveTime: " + moveTime + " ms", buttonCenter.x, buttonCenter.y - 80);
}



class Piece {
  String type; // Type of piece (King, Queen, Rook, etc.)
  String pieceColor; // Piece color (White or Black)
  int row, col; // Position on the board
  boolean hasMoved = false;

  // Constructor
  Piece(String type, String pieceColor, int row, int col) {
    this.type = type;
    this.pieceColor = pieceColor;
    this.row = row;
    this.col = col;
  }

  // Move the piece
  void move(int newRow, int newCol) {
    this.row = newRow;
    this.col = newCol;
    this.hasMoved = true;
  }
}

// Draw the menu screen
void drawMenu() {
  background(185, 185, 185);  // Slightly darker gray for contrast
  textFont(createFont("Times New Roman", 12));
  fill(50);
  PImage gameName = loadImage("gameName.png");
  gameName.resize(500,100);
  image(gameName, width / 2 - 250, 100);

  textSize(14);
  text("By Jagbir Brar", width / 2, 400);  // Your name in the menu

  fill(80, 102, 153);  // Blue button color
  strokeWeight(2);
  rect(width / 2 - 100, 380, 200, 80);
  PImage startButton = loadImage("startButton.png");
  startButton.resize(180,24);
  image(startButton, width / 2 - 90, 405);

  PImage logo = loadImage("logo.png");
  logo.resize(300, 300);
  image(logo, width / 2 - 150, height / 2 + 80);
}

// make the chessboard as a 2D array
Piece[][] board = new Piece[8][8];
int tileSize = 70; // Size of each tile
boolean isMenuScreen = true; // Flag to check if we are on the menu screen

String currentTurn = "White"; // Tracks the current player's turn, White goes first (now Black visually)
// for tracking the last move
int[] lastMove = {-1, -1, -1, -1}; // {startRow, startCol, endRow, endCol}
Piece seletedPiece = null; // The piece currently being dragged
int selecedRow, seletedCol; // The original position of the selected piece
int ofsetX, ofsetY; // Offset to position the piece correctly during the drag

void setup() {
 
  sliderY = thermometerY + map(temperature, minValue, maxValue, thermometerHeight, 0);
  buttonCenter = new PVector(600, 300); // Place button at center
 // Create our heat map class

  size(1800, 900);  // Adjusted window size for the new layout
  initializeBoard();
  textAlign(CENTER, CENTER);
  textSize(24);
   engine = new ChessEngine();
  try {
    println("Starting lc0...");
    //NOTE: YOU MUST CHANGE THIS TO YOUR OWN FILE PATH 
    engine.startEngine(" path to lc0.exe");
    println("Lc0 started successfully.");
} catch (IOException e) {
    e.printStackTrace();
    println("Error message: " + e.getMessage());
}
   
  // Load piece images into the HashMap
  loadPieceImages();
   
   

}


 void draw() {
   
   // Inside your draw() method, after the drawGame() call, add this:
   
  //if(isInformationTabVisible) {
  //  drawInformationTab();
  //}
  if (isMenuScreen) {
    drawMenu();
    
  } else {
    drawGame();
    
    if (isControlPanelVisible == true) {
    drawControlPanel();
    }
    
    
     if (isEngineMoveRequested) {
          fill(0);
          textSize(32);
          text("Thinking...", width/2,50);
      }
      if (isTyping) {
    // Add the next character if enough time has passed
    if (charIndex < evalText.length() && millis() - lastTypedTime >= typingInterval) {
      displayedText += evalText.charAt(charIndex); // Append the next character
      charIndex++; // Move to the next character
      lastTypedTime = millis(); // Update the timer
    }
    

    // Display the progressively typed text
    PFont mono;
  // The font "andalemo.ttf" must be located in the 
  // current sketch's "data" directory to load successfully
  mono = createFont("blackBox.ttf", 16);
    fill(255);
    textFont(mono);
    text(displayedText, 47, 100,540,200);
    
    
  }
    
  }

        if (isInCheckmate(currentTurn)) {
      fill(0);
      textSize(32);
      text("Checkmate!", width / 2, 50);
      noLoop(); // Stop the game loop
    }
    if (isInStalemate(currentTurn)){
        fill(0);
        textSize(32);
        text("Stalemate!", width / 2, 50);
        noLoop();
    }
  }
  


// Function to check if the King of the specified color is in check
boolean isInCheck(String colour) {
    int kingRow = -1;
    int kingCol = -1;

    // Find the king's position
    for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
            if (board[row][col] != null && board[row][col].type.equals("King") && board[row][col].pieceColor.equals(colour)) {
                kingRow = row;
                kingCol = col;
                break; // Found the king, no need to continue the loop
            }
        }
        if(kingRow != -1){
          break; // exit outer loop once the king is found
        }
    }

    if (kingRow == -1) {
        return false; // King not found (shouldn't happen)
    }

    // Check if any opposing piece can attack the King's position
    String opponentColor = colour.equals("Black") ? "White" : "Black"; // Swapped colors

    for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
            if (board[row][col] != null && board[row][col].pieceColor.equals(opponentColor)) {
                // Check if the opponent's piece can move to the King's position
                if (isMoveValid(board[row][col], kingRow, kingCol)) {
                    return true; // King is in check
                }
            }
        }
    }

    return false; // King is not in check
}
   
// THINK ABOUT REFINING THIS TO COVER BOTH SQUAREs
void drawHeatmap() {
    int boardOffsetX = (width - (8 * tileSize)) / 2;
    int boardOffsetY = 150;
    float n = 0;
    int R = 0;
    int G = 0;
    int B = 0;
    //loop through all the moves and draw the colors
    for (String move : heatMapMoves) {
        int startCol = move.charAt(0) - 'a';
        int startRow = 8 - (move.charAt(1) - '0');
        int endCol = move.charAt(2) - 'a';
         int endRow = 8 - (move.charAt(3) - '0');

        //check if the data exists, if not just skip that value
         if(heatmapColors.get(move) == null){
              continue;
          }

        R = heatmapColors.get(move)[0];
        G = heatmapColors.get(move)[1];
        B = heatmapColors.get(move)[2];

        fill(R, G, B, 30); // Use the stored color with some transparency
        rect(boardOffsetX + startCol * tileSize, boardOffsetY + startRow * tileSize, tileSize, tileSize);
    }
}
// Function to initialize pieces on the board
void initializeBoard() {
  // Set up pawns
  for (int i = 0; i < 8; i++) {
    board[1][i] = new Piece("Pawn", "Black", 1, i); // Swapped colors
    board[6][i] = new Piece("Pawn", "White", 6, i); // Swapped colors
  }

  // Set up other pieces (Rooks, Knights, etc.)
  placePieces(0, "Black"); // Swapped colors
  placePieces(7, "White"); // Swapped colors
}
void drawNotations() {
  textFont(createFont("Times New Roman", 12));
  fill(0); // Fill the text with black
  String columns = ("a                       b                       c                      d                       e                       f                       g                    h");
  text(columns, 900, height - 170);

  for (int i = 0; i < 8; i++) {
    textSize(12);
    text(8 - i, 1200, 150 + (i * tileSize + tileSize / 2));
  }
}
   
      String convertToAlgebraicNotation(int row, int col) {
        if (row < 0 || row > 7 || col < 0 || col > 7) {
            return "Invalid"; // Or handle this error case as needed
        }
        char colChar = (char) ('a' + col);
        int rowNum = 8 - row;
        return String.valueOf(colChar) + rowNum;
    }




void placePieces(int row, String pieceColor) {
  board[row][0] = new Piece("Rook", pieceColor, row, 0);
  board[row][1] = new Piece("Knight", pieceColor, row, 1);
  board[row][2] = new Piece("Bishop", pieceColor, row, 2);
  board[row][3] = new Piece("Queen", pieceColor, row, 3);
  board[row][4] = new Piece("King", pieceColor, row, 4); // King
  board[row][5] = new Piece("Bishop", pieceColor, row, 5);
  board[row][6] = new Piece("Knight", pieceColor, row, 6);
  board[row][7] = new Piece("Rook", pieceColor, row, 7);
}

// Function to draw the game screen
void drawGame() {
    background(180, 180, 180);  // Light grey background

    // Existing game drawing logic here...
    drawBoard();
    drawPieces();
    drawNotations();
  fill(0);
  // blackbox
  rect(30,108,555,715,20);
  // line rect
  strokeWeight(1.7);
  fill(255);
  rect(30,145,555,3);
  // text of blackbox
  PImage blackbox = loadImage("blackbox.png");
  blackbox.resize(120,20);
  image(blackbox,250,120);
  
  //button
  PImage button = loadImage("button1.png");
  button.resize(305,190);
  image(button,1400,100);
  image(button,1400,325);
  image(button,1400,550);
  // button text
  PImage buttonText = loadImage("button1Text.png");
  buttonText.resize(178,35);
  image(buttonText,1460,155); 
  // get evaluation
  PImage buttonText2 = loadImage("getPtext.png");
  buttonText2.resize(225,25);
  image(buttonText2,1440,403);  
  //press w+l
  PImage insBut = loadImage("insBut.png");
  insBut.resize(115,20);
  image(insBut,1495,440);  
  //press h
  PImage hBut = loadImage("pressh.png");
  hBut.resize(105,20);
  image(hBut,1495,655);
  
  
  PImage buttonText3 = loadImage("buttonText3.png");
  buttonText3.resize(185,30);
  image(buttonText3,1460,368);

  
  PImage pressSpace = loadImage("pressSpace.png");
  pressSpace.resize(160,25);
  image(pressSpace,1468,205);
  
  
  PImage buttonText4 = loadImage("button4.png");
  buttonText4.resize(235,35);
  image(buttonText4,1433,605);
  
  //utillity bar have to make button
  rect(0,0,1798,25);
  //setting tab
  fill(0);
  strokeWeight(2);
  fill(255);
  rect(0,0,125,25);
  PImage settings = loadImage("settingLogo.png");
  settings.resize(110,15);
  image(settings,10,8);
  
  // information tab 
  PImage information = loadImage("informationTab.png");
  information.resize(150,14);
  image(information,135,7);
  
  line(125,0,125,25);
  line(289,0,289,25);
   if (showHeatmap) {
         drawHeatmap();
     }
 



  // Display the current turn
  PFont mono;
  // The font "andalemo.ttf" must be located in the 
  // current sketch's "data" directory to load successfully
  mono = createFont("blackBox.ttf", 16);
  textFont(mono);
  fill(0);
  text("Current Turn: " + currentTurn, width / 2, height - 50);
  //PImage blackbox = loadImage("blackbox.png");
  //image(blackbox,500,400);
  
  
}

// Function to draw the board grid
void drawBoard() {
  color lightSquare = color(210, 175, 120); // Light square color
  color darkSquare = color(70, 35, 5);     // Dark square color

  int boardOffsetX = (width - (8 * tileSize)) / 2;
  int boardOffsetY = 150;

  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if ((row + col) % 2 == 0) {
        fill(lightSquare);
      } else {
        fill(darkSquare);
      }
      rect(boardOffsetX + col * tileSize, boardOffsetY + row * tileSize, tileSize, tileSize);
    }
  }
}


// Function to draw the pieces
void drawPieces() {
  int piecePadding = 10; // Padding for piece image inside tile

  // Calculate board padding to align pieces with the board
  int boardOffsetX = (width - (8 * tileSize)) / 2;  // Horizontal padding
  int boardOffsetY = 150;  // Vertical padding below the title area

  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if (board[row][col] != null) {
        String imageName = board[row][col].pieceColor.toLowerCase() + board[row][col].type + ".png";
        PImage pieceImage = pieceImages.get(imageName);
        if (pieceImage != null) {
          image(pieceImage, boardOffsetX + col * tileSize + piecePadding / 2,
                          boardOffsetY + row * tileSize + piecePadding / 2,
                          tileSize - piecePadding,
                          tileSize - piecePadding);
        }
      }
    }
  }

  // If there's a piece being dragged, render it above the board
  if (selectedPiece != null) {
    PImage pieceImage = pieceImages.get(selectedPiece.pieceColor.toLowerCase() + selectedPiece.type + ".png");
    image(pieceImage, mouseX - offsetX, mouseY - offsetY, tileSize - 10, tileSize - 10);
  }
}


     void mousePressed() {
    // Check if mouse is near the setting tab
    if(mouseX > 0 && mouseX < 125 && mouseY > 0 && mouseY < 25){
         isControlPanelVisible = !isControlPanelVisible;
    }
     //check if mouse clicks the exit button
     if(isControlPanelVisible && mouseX > 845 && mouseX < 845 + 180 && mouseY > 700 && mouseY < 700+100){
       isControlPanelVisible = false;
     }
   if (isControlPanelVisible && mouseX > 605 && mouseX < 605 + 180 && mouseY > 700 - 40 && mouseY < 700+100) {
         sendEngineOptions();
       println("apply settings button has been clicked");
         return;
       }
  // Check if mouse is near the thermometer slider
  if (isControlPanelVisible && mouseX > thermometerX - 10 && mouseX < thermometerX + thermometerWidth + 10 &&
      mouseY > sliderY - sliderHeight / 2 && mouseY < sliderY + sliderHeight / 2) {
    isDragging = true;
  }

  // Check if mouse is near the twistable button's handle
  if (isControlPanelVisible){
      float indicatorX = buttonCenter.x + cos(angle) * buttonRadius;
    float indicatorY = buttonCenter.y + sin(angle) * buttonRadius;
    if (dist(mouseX, mouseY, indicatorX, indicatorY) < 10) {
        isDragging2 = true;
    }
       
        
    
  }

  
    // Menu logic
    if (isMenuScreen) {
        if (mouseX > 600 && mouseX < width / 2 + 100 && mouseY > 380 && mouseY < 460) {
            isMenuScreen = false;  // Go to the game screen
        }
        return; // Prevent further processing in the menu screen
    }

    // Game screen logic for moving pieces
    int col = (mouseX - (width - 8 * tileSize) / 2) / tileSize;
    int row = (mouseY - 150) / tileSize;

    // Validate row and col before accessing the board
    if (row >= 0 && row < 8 && col >= 0 && col < 8) {
        if (selectedPiece == null && board[row][col] != null && board[row][col].pieceColor.equals(currentTurn)) {
            // Select the piece only if it's the current player's turn
            selectedPiece = board[row][col];
            selectedRow = row;
            selectedCol = col;
            offsetX = mouseX - (col * tileSize + (width - 8 * tileSize) / 2); // Calculate offset
            offsetY = mouseY - (row * tileSize + 150); // Adjust for board offset
        }
    } else {
        println("Click outside the board. Ignoring input.");
    }
}



 


// handles promotion when u reach last row
void handlePromotion(Piece piece) {
  if (piece.type.equals("Pawn") && (piece.row == 0 || piece.row == 7)) {
    isPromoting = true;
    promotingPiece = piece;
  }
}
void performCastling(Piece king, int newRow, int newCol) {
    int rookCol = (newCol > king.col) ? 7 : 0; // Kingside: 7, Queenside: 0
    int newRookCol = (newCol > king.col) ? newCol - 1 : newCol + 1; // New rook position

    Piece rook = board[newRow][rookCol];
    board[newRow][newRookCol] = rook; // Move the rook
    board[newRow][rookCol] = null; // Clear the old rook position
    rook.move(newRow, newRookCol); // Update rook's position
}

void mouseDragged() {
  if (isDragging) {
    // Update slider position within thermometer bounds
    sliderY = constrain(mouseY, thermometerY, thermometerY + thermometerHeight);
    temperature = map(sliderY, thermometerY + thermometerHeight, thermometerY, minValue, maxValue);

  }

  if (isDragging2) {
    // Update twistable button's angle and movetime
    angle = atan2(mouseY - buttonCenter.y, mouseX - buttonCenter.x);
    moveTime = int(map(angle, -PI, PI, minMoveTime, maxMoveTime));
    moveTime = constrain(moveTime, minMoveTime, maxMoveTime);

  }
}
void mouseReleased() {
  isDragging = false;
  isDragging2 = false;
   if (selectedPiece != null) {
        int newCol = (mouseX - (width - 8 * tileSize) / 2) / tileSize;
        int newRow = (mouseY - 150) / tileSize;
        if (newRow < 0 || newRow > 7 || newCol < 0 || newCol > 7) {
            selectedPiece = null;
            return;
        }

        if (isMoveValid(selectedPiece, newRow, newCol)) {

             playerMove = convertToAlgebraicNotation(selectedRow, selectedCol) +
                   convertToAlgebraicNotation(newRow, newCol);


            moves.add(playerMove); // added to array list

             Piece tempPiece = board[newRow][newCol];
             boolean enPassantCapture = false;

            // EN PASSANT CHECK (BEFORE MOVE IS ACTUALLY DONE) used stack overflow logic
             if (selectedPiece.type.equals("Pawn") &&
                   Math.abs(selectedPiece.col - newCol) == 1 &&
                    (selectedPiece.row + (selectedPiece.pieceColor.equals("White") ? 1 : -1) == newRow) &&
                    board[newRow][newCol] == null &&
                   lastMove[0] != -1 &&
                   lastMove[2] == selectedPiece.row &&
                    Math.abs(lastMove[2] - lastMove[0]) == 2 &&
                    board[lastMove[2]][newCol] != null &&
                    board[lastMove[2]][newCol].type.equals("Pawn")) {
                    board[lastMove[2]][newCol] = null;
                     enPassantCapture = true;
                        println("En passant move, removing piece at "+ lastMove[2] + ", " + newCol);


                   }


            board[newRow][newCol] = selectedPiece;
             board[selectedRow][selectedCol] = null;



            if (isInCheck(currentTurn)) {
                 board[selectedRow][selectedCol] = selectedPiece;
                 board[newRow][newCol] = tempPiece;


            } else {
                 if (selectedPiece.type.equals("King") && Math.abs(newCol - selectedPiece.col) == 2) {
                      performCastling(selectedPiece,newRow,newCol);
                }



                 selectedPiece.move(newRow, newCol);
               if (selectedPiece.type.equals("Pawn") && (selectedPiece.row == 0 || selectedPiece.row == 7)) {
                     promotePawn(selectedPiece,selectedPiece.pieceColor,selectedPiece.row,selectedPiece.col);
                } else{

                      lastMove = new int[]{selectedRow, selectedCol, newRow, newCol};
                   currentTurn = (currentTurn.equals("Black")) ? "White" : "Black"; // Swapped colors
                }
            }
        }
       selectedPiece = null;
    }
}




void keyPressed() {
  // button for make Engine move
  if (key == ' ') {
    makeEngineMove();
    
        
      }
      // Button for heatmap
  if (key == 'h') {
        requestBestMove();
        showHeatmap = true;
    }
  if (key == 'w'){
   requestBestMove();
  }
  if(key == 'l'){
    displayedText = ""; // Reset displayed text
    charIndex = 0;      // Reset typing progress
    isTyping = true;    // Start typing
  }
  //R TO RESET
  if(key == 'r'){
    showHeatmap = false;
  }
    
    
    
    
    
    
    
    
  if (isPromoting && promotingPiece != null) {
    String promotionType = null;

    // Determine the promotion type based on key pressed
    if (key == 'q' || key == 'Q') {
      promotionType = "Queen";
    } else if (key == 'r' || key == 'R') {
      promotionType = "Rook";
    } else if (key == 'b' || key == 'B') {
      promotionType = "Bishop";
    } else if (key == 'k' || key == 'K') {
      promotionType = "Knight";
    }

    if (promotionType != null) {
      // Replace the pawn with the selected piece
      board[promotingPiece.row][promotingPiece.col] = new Piece(promotionType, promotingPiece.pieceColor, promotingPiece.row, promotingPiece.col);
      isPromoting = false; // End promotion mode
      promotingPiece = null; // Clear the promoting piece
      currentTurn = currentTurn.equals("Black") ? "White" : "Black"; // Switch turns - Swapped colors
    }
  }
}




// Load all piece images into the HashMap
void loadPieceImages() {
  String[] colors = {"black", "white"}; // Swapped order
  String[] types = {"King", "Queen", "Rook", "Bishop", "Knight", "Pawn"};

  for (String pieceColor : colors) {
    for (String type : types) {
      String imageName = pieceColor + type + ".png";
      pieceImages.put(imageName, loadImage(imageName));
    }
  }
}

// Handle piece selection and movement
Piece selectedPiece = null;
int selectedRow, selectedCol;
int offsetX, offsetY;
boolean isInCheckmate(String colour) {
  if (!isInCheck(colour)) {
    return false;  // Can't be in checkmate if not in check
  }

  // Find the position of the player's king
  int kingRow = -1;
  int kingCol = -1;
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if (board[row][col] != null && board[row][col].type.equals("King") && board[row][col].pieceColor.equals(colour)) {
        kingRow = row;
        kingCol = col;
      }
    }
  }

  // Check if there is any valid move to escape the check
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if (board[row][col] != null && board[row][col].pieceColor.equals(colour)) {
        // Check if the piece can move to a square that stops the check
        for (int newRow = 0; newRow < 8; newRow++) {
          for (int newCol = 0; newCol < 8; newCol++) {
            if (isMoveValid(board[row][col], newRow, newCol)) {
              Piece tempPiece = board[newRow][newCol];
              // Temporarily make the move
              board[newRow][newCol] = board[row][col];
              board[row][col] = null;
              // If the move removes the check, it's not checkmate
              if (!isInCheck(colour)) {
                board[row][col] = board[newRow][newCol];
                board[newRow][newCol] = tempPiece;
                return false;  // Not checkmate
              }
              // Undo the move
              board[row][col] = board[newRow][newCol];
              board[newRow][newCol] = tempPiece;
            }
          }
        }
      }
    }
  }

  return true;  // If no valid move to escape check, it's checkmate
}
boolean isCastlingValid(Piece king, int newRow, int newCol) {
    if (king.hasMoved) return false; // King must not have moved

    // Determine which rook to check
    int rookCol = (newCol > king.col) ? 7 : 0; // Kingside: 7, Queenside: 0
    Piece rook = board[newRow][rookCol];

    if (rook == null || !rook.type.equals("Rook") || rook.hasMoved) return false; // Rook must exist and not have moved

    // Check if squares between king and rook are empty
    int step = (newCol > king.col) ? 1 : -1; // Direction of movement
    for (int c = king.col + step; c != rookCol; c += step) {
        if (board[newRow][c] != null) return false; // Square is not empty
    }

    // Check that the king does not move through or into check
    for (int c = king.col; c != newCol + step; c += step) {
      if (isSquareUnderAttack(king.pieceColor, newRow, c)) return false; // King passes through or ends in check
    }

    return true;
}

void promotePawn( Piece piece,String colour,int row,int col){
    isPromoting = true;
    promotingPiece = piece;
}



// Check if a square is under attack
boolean isSquareUnderAttack(String colour, int row, int col) {
    String opponentColor = colour.equals("Black") ? "White" : "Black"; // Swapped colors
    for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
            if (board[r][c] != null && board[r][c].pieceColor.equals(opponentColor)) {
                if (isMoveValid(board[r][c], row, col)) {
                    return true; // Square is under attack
                }
            }
        }
    }
    return false;
}

// Function to check if the player is in stalemate
boolean isInStalemate(String colour) {
  // The player must not be in check
  if (isInCheck(colour)) {
    return false;  // Can't be in stalemate if in check
  }

  // Check if the player has any legal moves available
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if (board[row][col] != null && board[row][col].pieceColor.equals(colour)) {
        // Check if the piece has any valid move
        for (int newRow = 0; newRow < 8; newRow++) {
          for (int newCol = 0; newCol < 8; newCol++) {
            if (isMoveValid(board[row][col], newRow, newCol)) {
              return false;  // If there is any valid move, it's not stalemate
            }
          }
        }
      }
    }
  }

  // If no valid moves and not in check, it's a stalemate
  return true;
}

// Function to check if a move is valid
boolean isMoveValid(Piece piece, int newRow, int newCol) {
    // Prevent moving back to the original square
    if (piece.row == newRow && piece.col == newCol) {
         //println("Prevent move to the same position");
        return false;
    }

    // Castling logic
    if (piece.type.equals("King") && Math.abs(newCol - piece.col) == 2 && piece.row == newRow) {
        boolean valid = isCastlingValid(piece, newRow, newCol);
         //println("Checking castling validity, result = "+valid);
        return valid;
    }

    // Prevent moving onto a square occupied by a piece of the same color
    if (board[newRow][newCol] != null && board[newRow][newCol].pieceColor.equals(piece.pieceColor)) {
      //println("Cannot capture own color, isMoveValid = false");
        return false;
    }
    // Call separate movement validation functions based on piece type
    switch (piece.type) {
      case "Pawn":
            boolean pawnValid =  isValidPawnMove(piece, newRow, newCol);
             //println("Checking pawn move, valid =" + pawnValid + " current position row col:" +piece.row + ", " + piece.col + " dest: " + newRow + "," + newCol);
          return pawnValid;
      case "Knight":
            boolean knightValid = isValidKnightMove(piece, newRow, newCol);
            //println("Checking knight move, result ="+knightValid);
          return knightValid;
      case "Bishop":
            boolean bishopValid = isValidBishopMove(piece, newRow, newCol);
            //println("Checking bishop move, result = " + bishopValid);
          return bishopValid;
      case "Rook":
           boolean rookValid =  isValidRookMove(piece, newRow, newCol);
            //println("Checking rook move, result= "+rookValid);
          return rookValid;
      case "Queen":
           boolean queenValid = isValidQueenMove(piece, newRow, newCol);
          //println("Checking queen move, result = "+ queenValid);
          return queenValid;
      case "King":
           boolean kingValid = isValidKingMove(piece, newRow, newCol);
          //println("Checking king move, result= " +kingValid);
           return kingValid;
      default:
         return false;
    }
}
boolean isValidPawnMove(Piece piece, int newRow, int newCol) {
    int direction = piece.pieceColor.equals("Black") ? 1 : -1; // Swapped direction

    // 1. Check for one square forward move
    if (isRegularPawnMove(piece, newRow, newCol, direction)) {
        //println("Pawn regular forward one");
       return true;
    }
    // 2. Check for diagonal capture
    if (isDiagonalCaptureMove(piece, newRow, newCol, direction)) {
         //println("Pawn diagonal capture");
        return true;
    }
    // 3. Check for en passant capture
    if (isEnPassantCaptureMove(piece, newRow, newCol, direction)) {
          //println("Pawn en passant capture");
        return true;
    }
    // 4. Check for initial double move
     if (isInitialDoubleMove(piece, newRow, newCol, direction)) {
          //println("Pawn inital double move");
        return true;
    }
       //println("pawn cannot move");
    return false; // If no valid move, return false
}

boolean isEnPassantCaptureMove(Piece piece, int newRow, int newCol, int direction) {
        boolean enPassant =  Math.abs(piece.col - newCol) == 1 &&
           piece.row + direction == newRow &&
            board[newRow][newCol] == null &&
        lastMove[0] != -1 &&
       lastMove[2] == piece.row &&
          Math.abs(lastMove[2]-lastMove[0])==2 &&
            board[lastMove[2]][newCol] != null &&
            board[lastMove[2]][newCol].type.equals("Pawn");

            if (enPassant)
                  println("Enpassant parameters pass at location " + piece.row+ ", " + piece.col );

         return  enPassant;

}

boolean isRegularPawnMove(Piece piece, int newRow, int newCol, int direction) {
    boolean isRegular =  newCol == piece.col && piece.row + direction == newRow && board[newRow][newCol] == null;
  return isRegular;
}

boolean isDiagonalCaptureMove(Piece piece, int newRow, int newCol, int direction){
    return Math.abs(piece.col - newCol) == 1 &&
           piece.row + direction == newRow &&
           board[newRow][newCol] != null &&
           !board[newRow][newCol].pieceColor.equals(piece.pieceColor);
}



boolean isInitialDoubleMove(Piece piece, int newRow, int newCol, int direction){
       if (!piece.hasMoved) {
            if (piece.pieceColor.equals("Black") && piece.row == 1 && newRow == 3 && newCol == piece.col && board[newRow][newCol] == null) { // Swapped logic
                 if(board[2][newCol] == null) {
                   return true;
                 }
             }
             if (piece.pieceColor.equals("White") && piece.row == 6 && newRow == 4 && newCol == piece.col && board[newRow][newCol] == null) { // Swapped logic
                if(board[5][newCol] == null){
                  return true;
               }
            }
        }
       return false;
}

boolean isValidKnightMove(Piece piece, int newRow, int newCol) {
  int rowDiff = Math.abs(piece.row - newRow);
  int colDiff = Math.abs(piece.col - newCol);
  return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
}

boolean isValidBishopMove(Piece piece, int newRow, int newCol) {
  int rowDiff = Math.abs(piece.row - newRow);
  int colDiff = Math.abs(piece.col - newCol);
  if (rowDiff == colDiff) {
      int rowStep = (newRow > piece.row) ? 1 : -1;
      int colStep = (newCol > piece.col) ? 1 : -1;
      int r = piece.row + rowStep;
      int c = piece.col + colStep;
      while (r != newRow && c != newCol) {
          if (board[r][c] != null) {
              return false; // There's a piece blocking the path
          }
          r += rowStep;
          c += colStep;
      }
      return true;
  }
  return false;
}

boolean isValidRookMove(Piece piece, int newRow, int newCol) {
    if (piece.row == newRow) {
        // Horizontal movement
        int colStep = (newCol > piece.col) ? 1 : -1;
        for (int c = piece.col + colStep; c != newCol; c += colStep) {
            if (board[piece.row][c] != null) {
                return false; // There's a piece blocking the path
            }
        }
      return true;
    } else if (piece.col == newCol) {
        // Vertical movement
        int rowStep = (newRow > piece.row) ? 1 : -1;
        for (int r = piece.row + rowStep; r != newRow; r += rowStep) {
            if (board[r][piece.col] != null) {
                return false; // There's a piece blocking the path
            }
        }
        return true;
    }
    return false;
}

boolean isValidQueenMove(Piece piece, int newRow, int newCol) {
    int rowDiff = Math.abs(piece.row - newRow);
    int colDiff = Math.abs(piece.col - newCol);
    if (rowDiff == colDiff || piece.row == newRow || piece.col == newCol) {
        // Check if the path is clear (no pieces in the way)
        if (rowDiff == colDiff) {
            // Diagonal movement
            int rowStep = (newRow > piece.row) ? 1 : -1;
            int colStep = (newCol > piece.col) ? 1 : -1;
            int r = piece.row + rowStep;
            int c = piece.col + colStep;
            while (r != newRow && c != newCol) {
              if (board[r][c] != null) {
                 return false; // There's a piece blocking the path
              }
             r += rowStep;
            c += colStep;
         }
        } else if (piece.row == newRow) {
           // Horizontal movement
           int colStep = (newCol > piece.col) ? 1 : -1;
           for (int c = piece.col + colStep; c != newCol; c += colStep) {
             if (board[piece.row][c] != null) {
                return false; // There's a piece blocking the path
             }
           }
        } else if (piece.col == newCol) {
          // Vertical movement
          int rowStep = (newRow > piece.row) ? 1 : -1;
          for (int r = piece.row + rowStep; r != newRow; r += rowStep) {
            if (board[r][piece.col] != null) {
              return false; // There's a piece blocking the path
            }
          }
        }
        return true;
    }
    return false;
}

boolean isValidKingMove(Piece piece, int newRow, int newCol) {
    int rowDiff = Math.abs(piece.row - newRow);
    int colDiff = Math.abs(piece.col - newCol);
    return rowDiff <= 1 && colDiff <= 1;
}



 String bestMove;
ArrayList aiEval = new ArrayList();

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;

class ChessEngine {
    private Process engineProcess;
    private BufferedReader reader;
    private BufferedWriter writer;
    private List<String> outputBuffer = new ArrayList<>();

    public void startEngine(String enginePath) throws IOException {
        ProcessBuilder builder = new ProcessBuilder(enginePath);
        engineProcess = builder.start();

        reader = new BufferedReader(new InputStreamReader(engineProcess.getInputStream()));
        writer = new BufferedWriter(new OutputStreamWriter(engineProcess.getOutputStream()));

        sendUciCommand("uci"); // Send UCI command to initialize engine
        waitForEngineReady();
    }
      public void sendUciCommand(String command) {
        try {
            writer.write(command);
            writer.newLine();
            writer.flush();
            println("Command sent to engine: " + command);
        } catch (IOException e) {
            e.printStackTrace();
            println("Error sending command: " + e.getMessage());
        }
    }

    private void waitForEngineReady() throws IOException {
         String line;
        while ((line = reader.readLine()) != null) {
            outputBuffer.add(line);
          if(line.equals("uciok")){
            // get all the stats such as W/L, number of vists and more
            sendUciCommand("setoption name VerboseMoveStats value true");
            break;
        }
        }
        System.out.println("uciok recived!");
    }


    public void sendPosition(String fenString) throws IOException {
        sendUciCommand("position fen " + fenString);
    }
       public String getBestMove(int timeLimit) throws IOException {
     sendUciCommand("go movetime " + timeLimit);
     String line;
      List<String> moveStats = new ArrayList<>();
     boolean foundBestMove = false;
     while ((line = reader.readLine()) != null) {
         outputBuffer.add(line);
         if (line.startsWith("bestmove")) {
             bestMove = line.split(" ")[1];
            foundBestMove = true;
         } else if (line.startsWith("info") && !foundBestMove){
                 moveStats.add(line);
                 aiEval.add(line);
                 
                 
         }
         if(foundBestMove){
              for (String statLine : moveStats) {
               System.out.println(statLine);
             }
             break;
        }
      }
     return bestMove;
 }
    public void stopEngine() {
        if (engineProcess != null) {
            engineProcess.destroy();
        }
    }
    public List<String> getOutputBuffer(){
       return outputBuffer;
    }

}


void makeEngineMove() {
    isEngineMoveRequested = true;
    thread("requestEngineMove");

}


    

void requestEngineMove() {
    try {
        engine.sendUciCommand("position startpos moves " + String.join(" ", moves));
         String nextMove = engine.getBestMove(moveTime); // Pass the moveTime variable here
         List<String> outputBuffer = engine.getOutputBuffer();
         String ratio = parseWinLossRatio(outputBuffer, nextMove);
         println(ratio);

        if (nextMove != null) {
            moves.add(nextMove);
            println("Engine played move:" + nextMove);

            int startCol = nextMove.charAt(0) - 'a';
            int startRow = 8 - (nextMove.charAt(1) - '0');
            int endCol = nextMove.charAt(2) - 'a';
            int endRow = 8 - (nextMove.charAt(3) - '0');

            if (startRow < 0 || startRow > 7 || startCol < 0 || startCol > 7 ||
                endRow < 0 || endRow > 7 || endCol < 0 || endCol > 7) {
                println("invalid start or end locations given to applyEngineMove, not making the move");
                return;
            }

            Piece piece = board[startRow][startCol];
            if (piece == null) {
                println("There is no piece to move for engine, location given: " + startRow + ", " + startCol);
                return;
            }

            Piece tempPiece = board[endRow][endCol];

            board[endRow][endCol] = piece;
            board[startRow][startCol] = null;

            if (piece.type.equals("King") && Math.abs(endCol - piece.col) == 2) {
                performCastling(piece, endRow, endCol);
            }
            piece.move(endRow, endCol);

            if (piece.type.equals("Pawn") && (piece.row == 0 || piece.row == 7)) {
                promotePawn(piece, piece.pieceColor, piece.row, piece.col);
            } else {
                lastMove = new int[]{startRow, startCol, endRow, endCol};
                currentTurn = (currentTurn.equals("Black")) ? "White" : "Black";
            }
        }
    } catch (IOException e) {
        e.printStackTrace();
        println("Error getting move from engine");
    }
    isEngineMoveRequested = false;
}


void requestBestMove() {
    try {
        // Send position and moves to the engine
        engine.sendUciCommand("position startpos moves " + String.join(" ", moves));

        // Retrieve the best move from the engine
        String bestmove = engine.getBestMove(moveTime); // Waits for 3000ms to get the best move

        if (bestmove != null) {
            println("Best Move: " + bestmove);

            // Parse the engine output for win/loss ratio and nodes evaluated
            List<String> outputBuffer = engine.getOutputBuffer();
            String ratio = parseWinLossRatio(outputBuffer, bestmove);
            String nodesEvaluated = "N/A";

            // Extract nodes explored from the output buffer
            for (String line : outputBuffer) {
                String extractedNodes = extractNodesExplored(line);
                if (!extractedNodes.equals("N/A")) {
                    nodesEvaluated = extractedNodes;
                    break;
                }
            }

            // Display and store the evaluation text
            println("Win/Loss Ratio: " + ratio);
            println("Nodes Evaluated: " + nodesEvaluated);
            evalText = "Win/Loss Ratio: " + ratio + "\nNodes Evaluated: " + nodesEvaluated;

        } else {
            println("Best move not found!");
            evalText = "Engine failed to provide a move.";
        }

        // Clear the engine's output buffer
        engine.outputBuffer.clear();
    } catch (IOException e) {
        e.printStackTrace();
        println("Error retrieving the best move from the engine.");
    }
}

class HeatMapper {
  float[] visits;   // array of visit counts
  float minVisits;  
  float maxVisits;

  // Constructor
  HeatMapper(float[] visits) {
    this.visits = visits;
    computeMinMax();
  }

  // Finds the minimum and maximum values in the visits array
  void computeMinMax() {
    minVisits = Float.MAX_VALUE;
    maxVisits = Float.MIN_VALUE;
    for (float v : visits) {
      // simple contion checks for max and min
      if (v < minVisits)  minVisits = v;
      if (v > maxVisits)  maxVisits = v;
    }
  }

  // Converts a visit count into an (R, G, B) color in the range [0..255].
  // Fewer visits => Blue(0,0,255), more visits => Red(255,0,0).
  color colorForVisits(float v) {
    // Edge case: if everything is the same, pick a default color
    if (maxVisits == minVisits) {
      return color(128, 0, 128); // purple as fallback
    }

    // coNvert to [0..1]
    float n = (v - minVisits) / (maxVisits - minVisits);

    // Clamp just in case had some issues with this
    n = constrain(n, 0, 1);

    // R: 0..255, G: always 0, B: 255..0
    float r = 255 * n;
    float g = 0;
    float b = 255 * (1 - n);

    return color(r, g, b);
  }

  // Prints each visit and its color to the console
  void debugPrintColors() {
    for (int i = 0; i < visits.length; i++) {
      float v = visits[i];
      color c = colorForVisits(v);
      println("Visits =", v, 
              " -> color = ("
              + (int)red(c) + ", "
              + (int)green(c) + ", "
              + (int)blue(c) + ")");
    }
  }
}


  
  
  
  
  
  import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.ArrayList;
import java.util.List;

// Data class for storing a move's visits + WL (like you had before).
// We'll keep it as vistsPerMove for consistency with your code.
class vistsPerMove {
  String move;
  int visits;
  double wl;

  vistsPerMove(String move, int visits, double wl) {
    this.move = move;
    this.visits = visits;
    this.wl = wl;
  }
}

 String parseWinLossRatio(List<String> moveStats, String bestmove) {
     double winLossValue = 0.0;
     String winningSide = "N/A";
     String percentageString = "";
     boolean foundWL = false;

     // We'll store data from each "info string" line (move, visits, wl)
     List<vistsPerMove> moveDataList = new ArrayList<>();
     heatmapColors.clear(); // clearing the moves, so we can put the new moves
     heatMapMoves.clear();

     // --- 1) Collect data from each line ---
     for (String line : moveStats) {
         // Only parse lines that start with "info string"
         if (line.startsWith("info string")) {
             // Extract the move name
             String move = extractMove(line);

             // Extract node visits
             String nodeCountStr = extractNodesExplored(line);
             int nodeCount = 0;
             if (!nodeCountStr.equals("N/A")) {
                 try {
                     nodeCount = Integer.parseInt(nodeCountStr);
                 } catch (NumberFormatException e) {
                     // ignore or print error if you wish
                 }
             }

             // Extract WL ratio
             double wlVal = extractWinLossRatio(line);

             // Add to our list
             moveDataList.add(new vistsPerMove(move, nodeCount, wlVal));

             // Check if this line’s move is bestmove
             if (move.equals(bestmove) && !Double.isNaN(wlVal)) {
                 winLossValue = wlVal;
                 foundWL = true;
             }
         }
     }

     // --- 2) Determine if we found WL for the best move ---
     if (!foundWL) {
         return "No win/loss info";
     }

     // --- 3) Determine winning side from WL ---
     if (winLossValue > 0) {
         winningSide = "Black";  // positive => black favored
     } else if (winLossValue < 0) {
         winningSide = "White";  // negative => white favored
     } else {
         winningSide = "Even";
     }

     double percentage = Math.abs(winLossValue) * 100;
     percentageString = String.format(
             "The engine thinks %s is winning with a W/L value of %.2f%%.",
             winningSide, percentage
     );

     // --- 4) (New Step) Compute min and max visits in the moveDataList ---
     int minVisits = Integer.MAX_VALUE;
     int maxVisits = Integer.MIN_VALUE;
     for (vistsPerMove vpm : moveDataList) {
         if (vpm.visits < minVisits) minVisits = vpm.visits;
         if (vpm.visits > maxVisits) maxVisits = vpm.visits;
     }

     // --- 5) Print each move with its visits and a heat color ---
     // (Blue for few visits, Red for many visits)
     println("==== Move Heat Map ====");
     for (vistsPerMove vpm : moveDataList) {
         // 5a) Compute the normalized value n in [0..1]
         float n = 0;
         if (maxVisits != minVisits) {
             n = (float)(vpm.visits - minVisits) / (float)(maxVisits - minVisits);
         }

         // 5b) Map n to RGB:  (R=255*n, G=0, B=255*(1-n))
         int R = (int)(255 * n);
         int G = 0;
         int B = (int)(255 * (1 - n));

         // 5c) Print the result
         // You can also store it somewhere else, or do actual color ops in Processing
           Integer[] colors = {R,G,B};
          heatmapColors.put(vpm.move, colors);
           heatMapMoves.add(vpm.move);
         println(
                 "Move=" + vpm.move
                         + "  Visits=" + vpm.visits
                         + "  HeatRGB=(" + R + "," + G + "," + B + ")"
         );
     }

     // --- 6) Return the final summary string about bestmove ---
     return percentageString;
 }

// ------------------------------
// Extract WL
// ------------------------------
double extractWinLossRatio(String line) {
  try {
    if (line.contains("WL:")) {
      String[] parts = line.split("WL:");
      if (parts.length > 1) {
        String afterWL = parts[1];
        // e.g. " -0.31415) ..."
        String ratioPart = afterWL.split("\\)")[0].trim();
        return Double.parseDouble(ratioPart);
      }
    }
  } catch (NumberFormatException e) {
    println("Error parsing the win-loss value: " + e.getMessage());
  }
  return Double.NaN;
}

// ------------------------------
// Extract Nodes
// ------------------------------
String extractNodesExplored(String line) {
  try {
    // e.g. "info string c5e7  (712 ) N:       0 (+ 0) (P:  0.37%) ..."
    // Regex: look for (digits)
    Pattern pattern = Pattern.compile("\\((\\d+)\\s*\\)");
    Matcher matcher = pattern.matcher(line);
    if (matcher.find()) {
      return matcher.group(1);
    }
  } catch (Exception e) {
    println("Error extracting nodes explored: " + e.getMessage());
  }
  return "N/A";
}

// ------------------------------
// Extract Move
// ------------------------------
String extractMove(String line) {
  try {
    String prefix = "info string";
    if (line.startsWith(prefix)) {
      String remainder = line.substring(prefix.length()).trim();
      // remainder might be "c5e7  (712 ) N:  0 (+ 0) (P: 0.37%) ..." this time should not give error
      String[] tokens = remainder.split("\\s+");
      if (tokens.length > 0) {
        return tokens[0];
      }
    }
  } catch (Exception e) {
    println("Error extracting move from line: " + line);
  }
  return "N/A";
}
