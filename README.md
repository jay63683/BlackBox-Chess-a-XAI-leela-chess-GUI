(this is an ongoing project the features described below are the only ones avaliable as of now, I will be adding more in depth XAI features other than the heatmap using ONNX tools in the future)

♚ BlackBoxChess: Neural Network Chess Visualization

💡 Overview
BlackBoxChess is an interactive chess visualization platform built in Processing that provides unique insights into chess engine decision-making processes. The project combines classical chess gameplay with neural network analysis visualization, allowing players to understand and explore how chess engines evaluate positions and select moves.

🎯 Core Features
leela chess engine Integration
Full UCI (Universal Chess Interface) protocol support
Real-time engine analysis and move calculation
showcasing of NNs processes and move evaluation.


🎨 Visualization System

Neural Network Analysis Heatmap

Color-coded move evaluation visualization (red: high visits( high NN value), blue: low visits(low NN value))
30% transparency overlay for piece visibility
Toggle with 'h' key


Real-time Engine Analysis Display

Win/loss probability
Node exploration count
Dynamic typing animation in the analysis panel



⚙️ Engine Control Panel

Temperature Control: Adjusts move selection randomness
Move Time Configuration: Set analysis duration (milliseconds)
moveTime Settings: Configure how much time engine takes to think
Accessible via "settings" tab

🎮 Gameplay Modes

Human vs Engine

Intuitive drag-and-drop interface
Real-time position evaluation
Dynamic move validation


Engine vs Engine

(may have some issues with)

Auto-play functionality
Real-time analysis visualization
Configurable engine parameters



🎹 Control Reference
Keyboard Shortcuts
CopySPACE   → Request engine move
H       → Toggle heatmap visualization
W       → Display engine's best move analysis
L       → Show position evaluation stats
R       → Disable heatmap overlay


UI Controls

Settings Tab: Access engine configuration panel
Apply Settings: Confirm parameter changes
Get Nodes: Request detailed position analysis
Engine Move: Trigger AI move calculation

🛠️ Technical Implementation
Required Components


Processing development environment
Compatible UCI chess engine
Asset files:

Piece images (.png)
https://opengameart.org/content/pixel-chess-pieces

 fonts (.ttf)
https://www.fontspace.com/category/retro,pixel?p=3

leela Engine executable



Setup Process

Install Processing IDE
Configure engine path in engine.startEngine()
Launch through Processing IDE

Architecture Notes

UI positions utilize algebraic coordinates
Engine path requires manual configuration
Move history tracked in algebraic notation
Real-time game state management
Event-driven visualization updates

🤝 Community Engagement

feedback is welcome
if you have any inquiries or contributions you can message me via my linkedIn     www.linkedin.com/in/jagbir-brar-14ab91308
Created by Jagbir Brar





This documentation provides a comprehensive guide to BlackBoxChess while maintaining accessibility for users of all technical levels. The project combines sophisticated chess engine analysis with intuitive visualization tools, making complex AI decision-making processes observable and understandable.
