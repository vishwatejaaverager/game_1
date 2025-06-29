# 🎮 Brick Breaker Game with Gyroscope Control

A modern Flutter-based brick breaker game built with the Flame game engine that features innovative gyroscope control via WebSocket communication over WiFi.

![Game Demo](https://www.youtube.com/shorts/zeoROLXsV-A)

## 🚀 Features

- **Classic Brick Breaker Gameplay**: Break bricks with a bouncing ball and paddle
- **Gyroscope Control**: Control the paddle using your phone's gyroscope sensor
- **WebSocket Communication**: Real-time data transmission over WiFi network
- **Cross-Platform**: Built with Flutter for multiple platform support
- **Modern UI**: Beautiful animations and smooth gameplay
- **Score Tracking**: Real-time score display and tracking

## 🎯 How It Works

The game consists of two main components:

1. **TV/Display Application**: Runs the main game on a larger screen (TV, computer, etc.)
2. **Mobile Controller**: Uses your phone's gyroscope to send control data via WebSocket

### Control Mechanism

- The game runs a WebSocket server on port 8080
- Your phone connects to the game via WiFi and sends gyroscope data
- The paddle position is controlled by tilting your phone left/right
- Real-time, low-latency control with smooth responsiveness

## 🛠️ Technology Stack

- **Flutter**: Cross-platform UI framework
- **Flame**: 2D game engine for Flutter
- **WebSocket**: Real-time bidirectional communication
- **Shelf**: Web server framework for WebSocket handling
- **Google Fonts**: Typography
- **Flutter Animate**: Smooth animations

## 📱 Game Controls

### On TV/Display:
- **Arrow Keys**: Manual paddle control (left/right)
- **Space/Enter**: Start game
- **Tap**: Start game

### On Mobile (Gyroscope):
- **Tilt Left**: Move paddle left
- **Tilt Right**: Move paddle right
- **Sensitivity**: Configurable gyroscope sensitivity

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.7.0)
- Dart SDK
- A device to run the game (TV, computer, etc.)
- A mobile device for gyroscope control

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd game_1
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the game**
   ```bash
   flutter run
   ```

### Setup Instructions

1. **Start the Game**: Run the Flutter application on your TV/display device
2. **Note the IP Address**: The game will display the WebSocket server address
3. **Connect Mobile Controller**: Use a WebSocket client app on your phone to connect to `ws://<TV-IP>:8080`
4. **Send Gyroscope Data**: Configure your mobile app to send gyroscope data in the format: `accelX,accelY,accelZ`
5. **Start Playing**: Tap or press space to start the game and control with your phone!

## 🎮 Game Mechanics

- **Ball Physics**: Realistic bouncing with paddle angle affecting ball direction
- **Brick Layout**: Colorful brick arrangement with different colors
- **Scoring**: Points awarded for each brick destroyed
- **Difficulty**: Ball speed increases as you progress
- **Game States**: Welcome screen, playing, game over, and victory states

## 🔧 Configuration

The game can be customized by modifying `lib/config.dart`:

- **Game Dimensions**: Adjust `gameWidth` and `gameHeight`
- **Ball Properties**: Modify `ballRadius` and `difficultyModifier`
- **Paddle Settings**: Change `batWidth`, `batHeight`, and `batStep`
- **Brick Layout**: Adjust `brickGutter`, `brickWidth`, and `brickHeight`
- **Colors**: Customize `brickColors` array

## 📁 Project Structure

```
lib/
├── main.dart              # Application entry point
├── brick_breaker.dart     # Main game logic and WebSocket server
├── config.dart           # Game configuration constants
├── components/           # Game components
│   ├── ball.dart         # Ball physics and behavior
│   ├── bat.dart          # Paddle component
│   ├── brick.dart        # Brick component
│   ├── play_area.dart    # Game boundaries
│   └── components.dart   # Component exports
└── widgets/              # UI widgets
    ├── game_app.dart     # Main app widget
    ├── overlay_screen.dart # Game overlay screens
    └── score_card.dart   # Score display widget
```

## 🌟 Key Features

- **Real-time WebSocket Communication**: Low-latency gyroscope control
- **Responsive Design**: Adapts to different screen sizes
- **Smooth Animations**: Fluid gameplay with Flutter Animate
- **Collision Detection**: Accurate ball-paddle-brick interactions
- **State Management**: Clean game state handling
- **Error Handling**: Robust WebSocket connection management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Flame](https://flame-engine.org/) game engine
- Inspired by classic brick breaker games
- Uses [Flutter](https://flutter.dev/) for cross-platform development

---

**Enjoy playing! 🎮✨**
