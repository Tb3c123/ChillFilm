import 'package:equatable/equatable.dart';

abstract class PlayerState extends Equatable {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool showControls;

  const PlayerState({
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.showControls,
  });

  @override
  List<Object?> get props => [isPlaying, position, duration, showControls];
}

class PlayerActiveState extends PlayerState {
  const PlayerActiveState({
    required bool isPlaying,
    required Duration position,
    required Duration duration,
    required bool showControls,
  }) : super(
          isPlaying: isPlaying,
          position: position,
          duration: duration,
          showControls: showControls,
        );
}

class PlayerBloc {
  PlayerState _state = const PlayerActiveState(
    isPlaying: true,
    position: Duration.zero,
    duration: Duration.zero,
    showControls: true,
  );

  PlayerState get state => _state;

  void updateState({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? showControls,
  }) {
    _state = PlayerActiveState(
      isPlaying: isPlaying ?? _state.isPlaying,
      position: position ?? _state.position,
      duration: duration ?? _state.duration,
      showControls: showControls ?? _state.showControls,
    );
  }
}
