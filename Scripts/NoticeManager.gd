extends Control

var latestVersion:String;
var githubReleasesLink:String = "https://github.com/cynware/PMDDC/releases"
var itchLink:String = "https://rem521.itch.io/pmddc"

@export var infoText:RichTextLabel;
@export var gitButton:Button;
@export var itchButton:Button;

@export_category("Close Button Stuff")
@export var closeButton:Button;
@export var normalCloseButtonPosition:Vector2;
@export var updateAvailableCloseButtonPosition:Vector2;# = Vector2.new(158, 83);

func _ready():
	RequestChangeLog()
	pass
	

func RequestChangeLog():
	var changelog_http_request = HTTPRequest.new()
	add_child(changelog_http_request)
	changelog_http_request.request_completed.connect(self.OnChangelogRequestCompleted)

	# Replace this with your actual URL
	var url = "https://raw.githubusercontent.com/cynware/PMDDC-Data/refs/heads/main/changelog.txt"
	changelog_http_request.request(url)

func OnChangelogRequestCompleted(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var text = body.get_string_from_utf8()
		var lines = text.split("\n")
		latestVersion = lines[0];
		
		print("BUILD VERSION: " + ProjectSettings.get_setting("application/config/version") + "\n" + "LATEST VERSION: " + latestVersion);
		
		if(latestVersion != ProjectSettings.get_setting("application/config/version")):
			lines.remove_at(0);
			
			ShowNoticeScreen("There is a new update available!\n\n" + "\n".join(lines), true);
			print("[[[ BUILD IS OUT OF DATE ]]]");
	else:
		print("Failed to grab changelog. Error code: ", result)
		
func ShowNoticeScreen(txt:String, updateAvailable:bool = false):
	
	itchButton.visible = updateAvailable;
	gitButton.visible = updateAvailable;
	
	if(updateAvailable):
		closeButton.position = updateAvailableCloseButtonPosition;
	else:
		closeButton.position = normalCloseButtonPosition;

	visible = true;
	infoText.text = txt;
	
func OpenGithubReleasesPage():
	OS.shell_open(githubReleasesLink);

func OpenItchioPage():
	OS.shell_open(itchLink);

func CloseNotice():
	visible = false;
