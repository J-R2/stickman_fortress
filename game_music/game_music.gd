extends AudioStreamPlayer

const MUSIC = [
	preload("res://game_music/8bit_bossa.mp3"),
	preload("res://game_music/peachtea_somewhere_in_the_elevator.ogg"),
	preload("res://game_music/two_left_socks.ogg"),
]
var song_index := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Play the first song at random.
	randomize()
	song_index = randi() % MUSIC.size()
	stream = MUSIC[song_index]
	play()
	finished.connect(_play_next_song)
	# connect to the game over and stop the music
	get_tree().get_first_node_in_group("tower").game_over.connect(stop)
	
	
func _play_next_song() -> void :
	song_index = wrapi(song_index+1, 0, MUSIC.size())
	stream = MUSIC[song_index]
	var timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.start()
	timer.timeout.connect(play)
	timer.timeout.connect(timer.queue_free)
