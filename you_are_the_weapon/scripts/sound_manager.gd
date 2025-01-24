extends Node

var _sound_queue: Array[AudioStreamWAV] = []

func play_sound(sound_player: AudioStreamPlayer2D, sound: AudioStreamWAV):
	sound_player.stream = sound
	sound_player.play()
