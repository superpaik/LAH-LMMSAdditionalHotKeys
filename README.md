# LAH (LMMSAdditionalHotKeys)
Additional HotKeys to LMMS using AutoHotKey (only for windows) <br>
Inspired after checking the https://enhancementsuite.me/ project, that is something similar but for Ableton Live. <br>

It uses acc.ahk Standard Library by Sean Updated by jethrow <br>
	http://www.autohotkey.com/board/topic/77303-acc-library-ahk-l-updated-09272012/ <br>
 	https://dl.dropbox.com/u/47573473/Web%20Server/AHK_L/Acc.ahk <br>
It also uses additional acc functions (acc-extended.ahk) Sorry, I don't know the author <br>
------------------------------------------------------------------------------ <br>

<b>Current Hotkeys are</b><br>

<b>Ctrl+Space</b>: Global Song-Editor Play/Pause. It works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")<br>
<b>Alt+Space</b>: Global Piano-Roll Play/Pause. It plays the notes on Piano-Roll (if there is any) Works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")<br>
<b>Ctrl+Alt+Space</b>: Piano-Roll record while playing <br>
<b>Ctrl+l</b>: Enable/Disable Loop-points. It works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")<br>
<b>Ctrl+Alt+v</b>: LMMS: hide/show all visible VST (only works when Plugin embedding option is set to "no embedding")<br>
<b>Ctrl+Alt+w</b>: Clear the workspace, closing all windows (except VST if Plugin embedding option is set to "no embedding") and then opens de Song-Editor, as a default window.<br>
<b>MiddleMouseButton</b>: (context action) delete the FX the cursor is over<br>
<b>Ctrl+LeftMouseButton</b>: (context action) show context menu, for effects and for VesTIge instruments (menus are defined in config.xml file)<br>
; 	Context menu are defined in the file config.xml<br>
; 	Context menu are available for:<br>
;		- Adding an effect. If the user clicks on "Add effect" button either on smple/instrument FX tab or in FX-Mixer the popup menu is shown<br>
;		- Adding an VST instrument. If the user clicks on the VeTIge folder icon to load a VST instrument<br>
;		- Helps with navigating samples folder. If you are like me an have samples inside the project directory, then every time you need to go to that folder is not direct, so if you define your project samples directories in the config.xml file you can navigate easier.<br>
;		  It works on the folder icon on "AudioFileProcessor" or in a sample-track, helps you go to an establish folder where your project sampler are.
; 		  Config file is quite straight forward. Here is an example:
;<?xml version="1.0" encoding="utf-8" standalone="yes"?>
;<ConfigFile>
;	<ConfigVariables>
;		<Var VST-dir="C:\Program Files\Steinberg\VstPlugins"/>   ; identifies the user VST folder
;	</ConfigVariables>
;	<MenuSamplesFolders>   
		<MenuItem show="Chill trap Project Folder" value="C:\Users\superpaik\lmms\projects\Mis EDM\2. In progress\Chill trap 27-02"/>
		<MenuItem show="Chill trap SAMPLES Folder" value="C:\Users\superpaik\lmms\projects\Mis EDM\2. In progress\Chill trap 27-02\Samples"/>
	</MenuSamplesFolders>
	<MenuFX>
		<MenuItem show="Effects/Delay/BabyComeback" value=""/>
		<MenuItem show="Effects/Delay/Echo Delay Line 0.1s" value="Echo Delay Line (Maximum Delay 0.1s)"/>
		<MenuItem show="Effects/Delay/GDuckDly" value=""/>
		<MenuItem show="Effects/Delay/ValhallaFreqEcho" value="ValhallaFreqEcho_x64"/>
		<MenuItem show="Mixing/Compresor/BUSTERse" value=""/>
		<MenuItem show="TAP AutoPanner" value=""/>
	</MenuFX>
	<MenuVeSTige>
		<MenuItem show="Piano/Keyzone Classic" value="Bitsonic\Keyzone Classic"/>
		<MenuItem show="Piano/Salamander Piano" value="Salamander Piano\Salamander Piano - 64"/>
		<MenuItem show="Sampler/Poise" value="OneSmallClue\Poise"/>
		<MenuItem show="Sampler/Sitala" value="Decomposer\Sitala"/>
		<MenuItem show="Synths/Surge" value="Surge\Surge"/>
		<MenuItem show="Synths/Tal-NoiseMaker-64" value="Tal\Tal-NoiseMaker-64"/>
		<MenuItem show="Vital" value="Vital\Vital"/>
	</MenuVeSTige>
</ConfigFile>
