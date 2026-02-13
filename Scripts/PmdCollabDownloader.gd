extends Node
class_name PmdCollabDownloader

signal download_progress(text: String)
signal download_completed(success: bool)
signal download_percent(value: float)
signal size_fetched(size_text: String)

var zip_url = "https://github.com/cynware/PMDDC-SpriteCollab/archive/refs/heads/master.zip"
var local_zip_path = "user://pmd_collab.zip"
var extract_path = "user://PMDCollab/"

var extraction_thread: Thread
var current_http_request: HTTPRequest

static func is_installed() -> bool:
	return FileAccess.file_exists("user://PMDCollab/tracker.json")

func _process(_delta):
	if is_instance_valid(current_http_request):
		var status = current_http_request.get_http_client_status()
		if status == HTTPClient.STATUS_BODY or status == HTTPClient.STATUS_REQUESTING:
			var total = current_http_request.get_body_size()
			var downloaded = current_http_request.get_downloaded_bytes()
			if total > 0:
				var percent = (float(downloaded) / total) * 100.0
				emit_signal("download_percent", percent * 0.8)
			else:
				# If total is unknown, we just show some progress based on a rough estimate (e.g. 100MB)
				var estimate = 100 * 1024 * 1024 
				var percent = min((float(downloaded) / estimate) * 80.0, 75.0)
				emit_signal("download_percent", percent)

func start_download():
	emit_signal("download_progress", "Starting download...")
	print("Starting download from: " + zip_url)
	
	current_http_request = HTTPRequest.new()
	add_child(current_http_request)
	current_http_request.request_completed.connect(self._on_download_completed.bind(current_http_request))
	current_http_request.download_file = local_zip_path
	
	var error = current_http_request.request(zip_url)
	if error != OK:
		print("Error starting download")
		if FileAccess.file_exists(local_zip_path):
			DirAccess.remove_absolute(local_zip_path)
		emit_signal("download_completed", false)
		current_http_request.queue_free()
		current_http_request = null

func _on_download_completed(result, response_code, headers, body, http_request):
	current_http_request = null
	http_request.queue_free()
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		print("Download failed. Code: ", response_code)
		if FileAccess.file_exists(local_zip_path):
			DirAccess.remove_absolute(local_zip_path)
		emit_signal("download_completed", false)
		return
		
	emit_signal("download_progress", "Extracting files... (This may take a while)")
	print("Download finished. Starting extraction thread...")
	
	extraction_thread = Thread.new()
	extraction_thread.start(_threaded_extract)

func _threaded_extract():
	var global_zip_path = ProjectSettings.globalize_path(local_zip_path)
	var global_extract_path = ProjectSettings.globalize_path(extract_path)
	
	# Ensure extraction dir exists
	if !DirAccess.dir_exists_absolute(extract_path):
		DirAccess.make_dir_recursive_absolute(extract_path)
	
	print("Attempting fast extraction via tar...")
	call_deferred("emit_signal", "download_progress", "Extracting files (Fast Mode)...")
	

	var output = []
	var exit_code = OS.execute("tar", ["-xf", global_zip_path, "-C", global_extract_path, "--strip-components=1"], output, true)
	
	if exit_code == 0:
		print("Fast extraction successful!")
		# Clean up zip
		DirAccess.remove_absolute(local_zip_path)
		print("Extraction complete")
		call_deferred("emit_signal", "download_percent", 100.0)
		call_deferred("emit_signal", "download_completed", true)
		return
	else:
		print("Fast extraction failed (Code: " + str(exit_code) + "). Output: " + str(output))
		print("Falling back to internal ZIPReader...")

		_extract_fallback()

func _extract_fallback():
	var reader = ZIPReader.new()
	var err = reader.open(local_zip_path)
	if err != OK:
		print("Failed to open zip")
		if FileAccess.file_exists(local_zip_path):
			DirAccess.remove_absolute(local_zip_path)
		call_deferred("emit_signal", "download_completed", false)
		return
		
	var files = reader.get_files()
	var total_files = files.size()
	
	if !DirAccess.dir_exists_absolute(extract_path):
		DirAccess.make_dir_recursive_absolute(extract_path)
	
	var root_folder = ""
	if files.size() > 0:
		var first_file = files[0]
		if "/" in first_file:
			root_folder = first_file.split("/")[0] + "/"
	
	var created_dirs = {}
	var processed_count = 0
	
	for path in files:
		processed_count += 1
		
		if processed_count % 200 == 0:
			var percent = int((float(processed_count) / total_files) * 100)
			call_deferred("emit_signal", "download_progress", "Extracting: %d%% (%d/%d)" % [percent, processed_count, total_files])
			call_deferred("emit_signal", "download_percent", 80.0 + (percent * 0.2))
		
		if path.ends_with("/"):
			continue
			
		var relative_path = path
		if root_folder != "" and path.begins_with(root_folder):
			relative_path = path.trim_prefix(root_folder)
		
		if relative_path == "":
			continue
			
		var write_path = extract_path.path_join(relative_path)
		var base_dir = write_path.get_base_dir()
		
		if !created_dirs.has(base_dir):
			if !DirAccess.dir_exists_absolute(base_dir):
				DirAccess.make_dir_recursive_absolute(base_dir)
			created_dirs[base_dir] = true
			
		var buffer = reader.read_file(path)
		var file = FileAccess.open(write_path, FileAccess.WRITE)
		if file:
			file.store_buffer(buffer)
			file.close()
		
	reader.close()
	
	DirAccess.remove_absolute(local_zip_path)
	
	print("Extraction complete")
	call_deferred("emit_signal", "download_percent", 100.0)
	call_deferred("emit_signal", "download_completed", true)

func _exit_tree():
	if extraction_thread and extraction_thread.is_started():
		extraction_thread.wait_to_finish()

func fetch_size():
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(
		func(result, response_code, headers, body):
			var size_str = "Unknown"
			if result == HTTPRequest.RESULT_SUCCESS:
				for header in headers:
					if header.to_lower().contains("content-length:"):
						var bytes = header.split(":")[1].to_int()
						size_str = "%.2f MB" % (bytes / 1024.0 / 1024.0)
						break
			emit_signal("size_fetched", size_str)
			http.queue_free()
	)
	http.request(zip_url, [], HTTPClient.METHOD_HEAD)

