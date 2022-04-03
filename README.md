# LAH (LMMS Additional HotKeys)
Additional HotKeys for LMMS using AutoHotKey (only for windows) <br>
Inspired after checking the https://enhancementsuite.me/ project, that is something similar but for Ableton Live. <br>

It uses acc.ahk Standard Library by Sean Updated by jethrow <br>
	http://www.autohotkey.com/board/topic/77303-acc-library-ahk-l-updated-09272012/ <br>
 	https://dl.dropbox.com/u/47573473/Web%20Server/AHK_L/Acc.ahk <br>
It also uses additional acc functions (acc-extended.ahk) Sorry, I don't know the author <br>
------------------------------------------------------------------------------ <br>

The object of the project is to have additional hotkeys for LMMS.<br>
Actions are implemented using AutoHotKey: https://www.autohotkey.com/ <br><br>
Developed and tested on LMMS 1.2.2. Since it uses GUI elements Id it may not work on other LMMS version.<br>
When the interaction is with GUI objects, they have to be visible. Sometimes the hotkey can make the window active, but if the objects are hidden in the own window (like in FX-Mixer with the scroll bar) the hotkey won't work properly.

If you have AutoHotKey in your system you can load the script directly. You will need:
<ul>
	<li>LMMSAdditionalHotKeys.ahk : main script</li>
	<li>acc-for-lah.ahk : acc.ahk + acc-extended.ahk scripts + some minor changes to make it work with LMMS</li>
	<li>config.xml : config file for context menu. Edit it to your liking before using it</li>
</ul>
If you don't have AutoHotKey, you will need:
<ul>
	<li>LMMSAdditionalHotKeys.exe : main script</li>
	<li>config.xml : config file for context menu. Edit it to your liking before using it</li>
	<li>Store the two files in the same directory. Upon executing the exe an icon try will be added from where you can exit the script, suspend the HotKeys or pause the script</li>
</ul>


<b>Current Hotkeys are:</b><br>

<ul>
<li><b>Ctrl+Space</b>: Global Song-Editor Play/Pause. It works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Alt+Space</b>: Global Piano-Roll Play/Pause. It plays the notes on Piano-Roll (if there is any) Works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Ctrl+Alt+Space</b>: Piano-Roll record while playing </li><br>
<li><b>Ctrl+l</b>: Enable/Disable Loop-points. It works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Ctrl+Alt+v</b>: LMMS: hide/show all visible VST (only works when Plugin embedding option is set to "no embedding")</li><br>
<li><b>Ctrl+Alt+w</b>: Clear the workspace, closing all windows (except VST if Plugin embedding option is set to "no embedding") and then opens de Song-Editor, as a default window.</li><br>
<li><b>Alt+p</b>: Click on "Mute this FX channel" for all Pinned FX Channels (pinned trough context menu) </li><br>
<li><b>Ctrl+Shift+LeftMouseButton</b>: (context action) show context menu, for effects and for VesTIge instruments (menus are defined in config.xml file)</li><br>
</ul>
<b>Context menus are available for:</b><br>
<ul>
<li>Adding an effect. If the user clicks on "Add effect" button either on sample/instrument FX tab or in FX-Mixer the popup menu is shown
	&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img src="https://user-images.githubusercontent.com/68785450/161311587-3fd7b4cd-a3ae-42d8-8dde-cf9888b2d840.png" alt="Adding an effect menu"></li><br>
<li>Adding an VST instrument. If the user clicks on the VeTIge folder icon to load a VST instrument
	&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img src="https://user-images.githubusercontent.com/68785450/161311910-b52f1eb9-0c82-4f52-9086-fdb1c949f06e.png" alt="Adding an VST menu"></li><br>
<li>Helps with navigating samples folder. If you are like me an have samples inside the project directory, then every time you need to go to that folder is not direct, so if you define your project samples directories in the config.xml file you can navigate easier. It works on the folder icon on "AudioFileProcessor" or in a sample-track, helps you go to an establish folder where your project sampler are.
	&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img src="https://user-images.githubusercontent.com/68785450/161312994-acb257ce-a391-4624-8ff0-3645753fda0f.png" alt="Project Samples Folders"></li><br>
<li>Pin/UnPin FX channels. With this option you can select/unselect the channels that would be clicked on "Mute this FX channel" with Ctrl+Alt+P hotkey. Useful if you have Group or Send Channels that need to be activated always, so when you click on "Solo this FX channel" you can turn all those channels on with easy. Unfortunately, showing this context menu is kind of slow, so be patient.
	&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<img src="https://user-images.githubusercontent.com/68785450/161425718-09cca76a-81ca-418a-a477-f0fd83b33aac.png" alt="FX Channels Pin/UnPin menu"></li><br>
</ul>
	
<br>
Config file is quite straight forward.
In <ConfigVariables> you set the VST-dir that you have in you LMMS (In LMMS settings: VST plugin directory)<br>
There are three menus called "MenuSampleFolders", "MenuFX" and "MenuVeSTige". Every menu works the same way. There is a "show" text, which is the label that is visible in the menu, and a "value" text that is the information that is passed to the controls to execute the actions. In the case os "MenuSampleFolders" is the full path to your project folders. In the other two cases is the full name of the Effect or VST. Menus can have submenus by adding a slash "/". Have in mind that there is no control over the xml file. Therefore, if it's incorrect, unexpected behaviour can happens ;-)
<br><br>
<b>Known issues:</b>
<ul>
<li>Although the directive "#IfWinActive" is used to avoid the hotkeys to work outside LMMS, apparently it doesn't work.</li>
<li>In order to make the context menu to work I use the library acc.ahk to locate the objects in the GUI. Apparently, it doesn't work when there is more than one object in the screen (in the same position). Therefore, in order for it to work, it is best if the object you click has nothing behind, otherwise no menu will be shown. I believe is something related to how QT build the GUI.</li>
</ul>


