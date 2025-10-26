extends OptionButton
# This godot dropdown is absolutely incredible how did you make this
# Some idiot didn't add a transparency option into the theme customization
# Godot i swear to god
# XX$$X$&&X:...............;....::.....;.:$&&$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# X&&:.......&:.&:;:&.&.$:.&+;.$;;$....x.......:&&Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# :..........&x$:.$Xx;;xx..x.x$:::.x...+...........&&xxxxxxxxxxxxxxxxxxxxxxxxxxxx++++++xxxxxxxxxxXXXxx
# ..........................:...................x...&&xxxxxxxxxxxxxxxxxxxxxx+xx++++++++++xxxxxXXXxxxxx
# ..&;::&:x:&.&::X::;&.$...:x:+.;;..&..&:+.;;&.:X..:&$xxxxxxxxxxxxxxxXxxxXxxxx++++++++++++xxXXX$XXxxxx
# &x:x+..;.;...x;.:x:+.:....;.:x:...:;:&.:x:.:x::;&&XXXXXXXXXXXXXXXxXxxxxxxXX++++++++++$x++xXXX$$XXXXX
# XX$&&x.....................................+&&$XXXXXXXXXXXXXXXXXXxxXXXXXXX++++++++x++++++xXXXX$$$$$$
# XX$$$$X$$&&&&x;:.................::.......$&XXX$X$$$X$$$X$$XX$$XXxxXXX;::::::x::::::::;+++XXXXXXX$$X
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$XxXX$XX&&&x:..&&$$$$$$$$$$$$$$$$$$$$$$;;&&&:::X+&&&$:::::$++X$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$XX$$$X$$$$$&&&&$$$$$$$$$$$$$$$$$$$$$x&;&&:::$&+&&;::xxxxxx$$$$$$$$$
# X$$$$$$$Xx$$$$$$$$$$$$$$$$$$X$$$Xx+xxxxxxxxx+;xx++xx$$$$$$$$$$$$$$$$x+++++++++++++x$&&&++++$$$$$$$$$
# xXxXXxxxxxxxx;;;;;;;;;;;;;;;:;;;;;;;::;:;;;;&;:;+;:;x;;xxxxxxxxxxxxxxx++&&&&x:::&&&&&&+++++xxxxxxxxx
# XX$$XXxxxxxxx;$$$X;;;;xx+;&xxx$&&&&;;;;+;x&&&&$$&&;;:;;xxxxxxxxxxxxx+++&&&&&&&&&&&&&x+++++++x+++++++
# xxxxxxxx+x++;;+Xx;;;;x;x::X$&&&::::;&&+:x&&&&x:::&&&;;+;;++;;;++;;xx++X&&$XXXXXX$x++++++++++x;++;++;
# ++++++++x;++;;x$;;;+;;;:::$+&&&&&&&&&&x;:x+&&&&&&&&x$;;;;;;;;;;:;x;x+++Xx+++++xx+++++++++++++x;;;;;;
# +++;;;;;;;;;;;;;;;+;;+;;;;::;xxxxxxxx:X:::x+x:;:+;;;;+;;;;;:;;;;xxxxX++++++++++++++x++++++++++x;;;;;
# ;;;;;;;;;;;;;;x$X;;+;++++;;+::::::+x:;;xxx;;;;;;;;+;;x:xx+;;xx+++++++++++++++++++++x+++++++x+++x;;;;
# ;;;;;;;;;;;;;;$X+;x;;;;;+$$$$$$$&$xxxxX$xx;;$$$$$;;;;+::xx++++x;+++++++++++++++++++++++++++x++++x;;;
# ;;;;;;;;;;;;;;;+;;;;;x;:;;;xxxxxxxX$$$$$$$$$$$+;xxx+;;;++xxxX;:;;;xxxx+++xx+++++++x++++++++x+++++x;;
# ::;:::::::;:;;;;;;;;xX+;+;;;;x+x$xx+;;;;;+xxxxxxxx;;;x++++++++xx;xX+x+++++++++++++x++++++x++++++++x;
# :::::::::;:::;;;;x+:::::;X;:;;;:;;;:;;;;;;;;;;;;;;;++xx+xxx+++++xXx+++++++++++++++++++++++++xx+xXx++
# :::::::::::;;;;;;;;;+:::::::::::x;x::$xx;+xxxXXxxxxxx$;;xxxxxxxxxX$XxxxxxxxxxxxxxxxXXxx+;;+++;;;;;;+
# ;::;;:;;;;:;;;$&&&&$&xx$$&&&&&$xx&&&$XxXXxxxxxxxxxxxxx;+;Xxxx+xxxxx+Xxxxxxxx;;;;;;;+;;;;;;;;;;;+++x;

# Called when the node enters the scene tree for the first time.

func _ready():
	get_popup().transparent = true
	get_popup().transparent_bg = true
