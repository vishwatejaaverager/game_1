import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
    : super(
        camera: CameraComponent.withFixedResolution(
          width: gameWidth,
          height: gameHeight,
        ),
      );

  final ValueNotifier<int> score = ValueNotifier(0);
  final rand = math.Random();
  late WebSocketChannel _channel;
  late StreamController _webSocketStreamController;
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());

    // Start WebSocket server on port 8080
    _startWebSocketServer();

    playState = PlayState.welcome;
  }

  void _startWebSocketServer() async {
    _webSocketStreamController = StreamController.broadcast();
    final handler = webSocketHandler((dynamic webSocket, String? protocol) {
      _channel = webSocket as WebSocketChannel;
      _webSocketStreamController.addStream(_channel.stream);

      const double sensitivity = 50.0; // Scale accelX to pixels

      _webSocketStreamController.stream.listen(
        (message) {
          print('Received: $message');
          final data = message.toString().split(',');
          final accelX =
              double.tryParse(data[0]) ?? 0.0; // X-axis acceleration (m/s²)

          if (playState == PlayState.playing) {
            final bat = world.children.query<Bat>().firstOrNull;
            if (bat == null) {
              print('Error: No bat found in world');
              return;
            }

            // Map accelX directly to bat position without calculations
            final batTargetX = (accelX * sensitivity) + (gameWidth / 2);
            bat.position.x = batTargetX.clamp(
              bat.size.x / 2, // Left boundary
              gameWidth - bat.size.x / 2, // Right boundary
            );
            print('Bat position: ${bat.position.x}');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('Phone disconnected');
        },
      );
    });

    try {
      await shelf_io.serve(handler, '0.0.0.0', 8080);
      print('WebSocket server running on ws://<TV-IP>:8080');
    } catch (e) {
      print('Error starting WebSocket server: $e');
    }
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    score.value = 0;

    world.add(
      Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity:
            Vector2(
                (rand.nextDouble() - 0.5) * width,
                height * 0.2,
              ).normalized()
              ..scale(height / 4),
      ),
    );

    world.add(
      Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95),
      ),
    );

    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i],
          ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.select:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);

  @override
  void onRemove() {
    _webSocketStreamController.close();
    super.onRemove();
  }
}
