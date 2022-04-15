# LAH (LMMS Additional HotKeys)
Additional HotKeys for LMMS using AutoHotKey (only for windows) <br>

The object of the project is to have additional hotkeys for LMMS.<br>
Actions are implemented using AutoHotKey: https://www.autohotkey.com/ <br><br>
Developed and tested on LMMS 1.2.2. Since it uses GUI elements Id it may not work on other LMMS versions.<br>

Inspired after checking the https://enhancementsuite.me/ project, that is something similar but for Ableton Live. <br>

It uses acc.ahk Standard Library by Sean Updated by jethrow <br>
	http://www.autohotkey.com/board/topic/77303-acc-library-ahk-l-updated-09272012/ <br>
 	https://dl.dropbox.com/u/47573473/Web%20Server/AHK_L/Acc.ahk <br>
It also uses additional acc functions (acc-extended.ahk) Sorry, I don't know the author <br>
------------------------------------------------------------------------------ <br>

If you have AutoHotKey in your system you can load the script directly. You will need:
<ul>
	<li>LMMSAdditionalHotKeys.ahk : main script</li>
	<li>acc-for-lah.ahk : acc.ahk + acc-extended.ahk scripts + some minor changes to make it work with LMMS</li>
</ul>
If you don't have AutoHotKey, you will need:
<ul>
	<li>LMMSAdditionalHotKeys.exe : main script</li>
	<li>Yo can download it to any local folder. Upon executing the exe an icon try will be added from where you can exit the script, suspend the HotKeys or pause the script in case it alters the behaviour of other program's hotkeys.</li>
</ul>


<b>The defined Hotkeys are:</b><br>

<table>
  <tr>
    <th><b>HotKey</b></th>
    <th><b>Description</b></th>
  </tr>
  <tr>
    <td><b>Ctrl+Space</b></td>
    <td>Song-Editor Play/Stop. It works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</td>
  </tr>
  <tr>
  <td><b>Alt+Space</b></td>
    <td>Global Piano-Roll Play/Stop. It plays the notes on Piano-Roll (if there is any) Works from whatever window you are in LMMS or even in a VST window (when Plugin embedding option is set to "no embedding")</td>
  </tr>
  <tr>
    <td><b>Ctrl+Alt+Space</b></td>
    <td>Piano-Roll Record while Playing</td>
  </tr>
  <tr>
    <td><b>Ctrl+l (el)</b></td>
    <td>Enable/Disable Loop-points. The Song-Editor and the Enable/disable Loop-points button should be visible for it to work</td>
  </tr>
  <tr>
    <td><b>Ctrl+Alt+w</b></td>
    <td>Clear the workspace, closing all windows in the LMMS workspace, and then opens de Song-Editor, as a default window. It doesn't close VSTs windows if embedding option is set to "no embedding". Use Ctrl+Alt+v to hide VSTs</td>
  </tr>
  <tr>
    <td><b>Ctrl+Alt+v</b></td>
    <td>Hide/Show all visible VSTs (only works when Plugin embedding option is set to "no embedding")</td>
  </tr>
</table>

