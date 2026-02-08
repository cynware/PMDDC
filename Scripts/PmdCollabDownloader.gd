extends Node
class_name PmdCollabDownloader

signal download_progress(text: String)
signal download_completed(success: bool)

var zip_url = "https://github.com/cynware/PMDDC-SpriteCollab/archive/refs/heads/master.zip"
var local_zip_path = "user://pmd_collab.zip"
var extract_path = "user://PMDCollab/"

var extraction_thread: Thread

static func is_installed() -> bool:
	return FileAccess.file_exists("user://PMDCollab/tracker.json")

func start_download():
	emit_signal("download_progress", "Starting download...")
	print("Starting download from: " + zip_url)
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._on_download_completed.bind(http_request))
	http_request.download_file = local_zip_path
	
	var error = http_request.request(zip_url)
	if error != OK:
		print("Error starting download")
		emit_signal("download_completed", false)
		http_request.queue_free()

func _on_download_completed(result, response_code, headers, body, http_request):
	http_request.queue_free()
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		print("Download failed. Code: ", response_code)
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
	call_deferred("emit_signal", "download_completed", true)
func _exit_tree():
	if extraction_thread and extraction_thread.is_started():
		extraction_thread.wait_to_finish()

