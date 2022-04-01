# LAH (LMMSAdditionalHotKeys)
Additional HotKeys to LMMS using AutoHotKey (only for windows) <br>
Inspired after checking the https://enhancementsuite.me/ project, that is something similar but for Ableton Live. <br>

It uses acc.ahk Standard Library by Sean Updated by jethrow <br>
	http://www.autohotkey.com/board/topic/77303-acc-library-ahk-l-updated-09272012/ <br>
 	https://dl.dropbox.com/u/47573473/Web%20Server/AHK_L/Acc.ahk <br>
It also uses additional acc functions (acc-extended.ahk) Sorry, I don't know the author <br>
------------------------------------------------------------------------------ <br>

The object of the project is to have additional hotkeys for LMMS.<br>
Actions are implemented using AutoHotKey: https://www.autohotkey.com/ <br>
If you have AutoHotKey in your system you can load the script directly. You will need:
<ul>
	<li>LMMSAdditionalHotKeys.ahk : main script</li>
	<li>acc.ahk : main script</li>
</ul>	


<b>Current Hotkeys are:</b><br>

<ul>
<li><b>Ctrl+Space</b>: Global Song-Editor Play/Pause. It works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Alt+Space</b>: Global Piano-Roll Play/Pause. It plays the notes on Piano-Roll (if there is any) Works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Ctrl+Alt+Space</b>: Piano-Roll record while playing </li><br>
<li><b>Ctrl+l</b>: Enable/Disable Loop-points. It works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Ctrl+Alt+v</b>: LMMS: hide/show all visible VST (only works when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Ctrl+Alt+w</b>: Clear the workspace, closing all windows (except VST if Plugin embedding option is set to "no embedding") and then opens de Song-Editor, as a default window.</li><br>
<li><b>MiddleMouseButton</b>: (context action) delete the FX the cursor is over</li><br>
<li><b>Ctrl+LeftMouseButton</b>: (context action) show context menu, for effects and for VesTIge instruments (menus are defined in config.xml file)</li><br>
<br>
</ul>
<b>Context menu are available for:</b><br>

<ul>
<li>Adding an effect. If the user clicks on "Add effect" button either on smple/instrument FX tab or in FX-Mixer the popup menu is shown</li>
	&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img src="https://user-images.githubusercontent.com/68785450/161311587-3fd7b4cd-a3ae-42d8-8dde-cf9888b2d840.png" alt="Adding an effect menu">
<li>Adding an VST instrument. If the user clicks on the VeTIge folder icon to load a VST instrument</li>
	&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img src="https://user-images.githubusercontent.com/68785450/161311910-b52f1eb9-0c82-4f52-9086-fdb1c949f06e.png" alt="Adding an VST menu">
<li>Helps with navigating samples folder. If you are like me an have samples inside the project directory, then every time you need to go to that folder is not direct, so if you define your project samples directories in the config.xml file you can navigate easier. It works on the folder icon on "AudioFileProcessor" or in a sample-track, helps you go to an establish folder where your project sampler are.</li>
	&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img src="https://user-images.githubusercontent.com/68785450/161312994-acb257ce-a391-4624-8ff0-3645753fda0f.png" alt="Project Samples Folders">
</ul>
	
<br>
Config file is quite straight forward.
In <ConfigVariables> you set the VST-dir that you have in you LMMS (In LMMS settings: VST plugin directory)<br>
There are three menus called "MenuSampleFolders", "MenuFX" and "MenuVeSTige". Every menu works the same way. There is a "show" text, which is the label that is visible in the menu, and a "value" text that is the information that is passed to the controls to execute the actions. In the case os "MenuSampleFolders" is the full path to your project folders. In the other two cases is the full name of the Effect or VST. Menus can have submenus by adding a slash "/". Have in mind that there is no control over the xml file. Therefore, if it's incorrect, unexpected behaviour can happens ;-)
<br>	
<b>Known issues:</b>
<ul>
<li>Although the directive "#IfWinActive" is used to avoid the hotkeys to work outside LMMS, apparently it doesn't work.</li>
<li>In order to make the context menu to work I use the library acc.ahk to locate the objects in the GUI. Apparently, it doesn't work when there is more than one object in the screen (in the same position). Therefore, in order for it to work, it is best if the object you click has nothing behind, otherwise no menu will be shown. I believe is something related to how QT build the GUI.</li>
</ul>
		
		
		

