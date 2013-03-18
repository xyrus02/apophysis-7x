# 7x.15a
* Added experimental thumbnail embedding - default is off since it has no real-world use right now
* Added a better notification system for missing plugins
* Added options to toggle thumbnail embedding and missing plugin warnings on/off
* Added background features to support dynamic plugin loading/unloading as well
* Added a (disabled yet) module to load the new and old parameter format - the old parameter format is still used solely in this version
* Added multilanguage support so users can write their own translation files for their native languages using a text-editor
* Added an option to generate a quick flame report
* Added built-in Chaotica export functionality
* Changed resize code in editor window to allow users setting higher font sizes in their system without the editor being messed up
* Changed most parts of the GUI to allow dynamic strings being placed in while loading translation files
* Changed thumbnail code to allow non-square thumbnails (maintains original aspect ratio)
* Changed thumbnail loading code to be threaded (loading in background)
* Changed loading progress bar in main window to be at the status panel (was on the image frame)
* Changed default flame list size to make the thumbnails appear centered
* Changed "Export flame" to "Export to flam3" in order to better integrate the new Chaotica support
* Fixed a bug with the time-attribute on unnamed flames ('' is not a valid integer)
* Fixed assembly code for some built-in variations
* Fixed a bug where the system shut down after first flame when rendering all flames if shutdown option was enabled
* Fixed a bug where the options window was always nagging the user with restart
* Fixed Flame.GammaThreshold in the scripting system - it now reads and writes like the option in the adjust window (please edit your scripts)
* Fixed the internal script-from-flame feature which placed weight modifier settings at the wrong place resulting in the flame being inaccurate when using Xaos

# 7x.14
* Fixed a memory leak within the thumbnail generation code.
* Merged the Apophysis7X/DC-branch into the main code. DirectColoring is now generally available for Apophysis 7X.
* Added a transform property named "var_color" which blends DirectColoring for an individual transform between zero (off) and one (on) - you can access this feature on the color-tab in the editor window. (captioned "Direct color")
* Added script support for var_color. (access with "Transform.VarColor")
* Added descriptive icons in the variation lost of the editor which indicate whether the individual variation supports 3D or DC.
* Fixed the "multithreading"-glitch in the options window. The field now represents the actual setting again.
* If you hover a triangle in the editor, the text on the bottom right now also contains the variation weights for each variation applied.
* Added dc_linear, dc_bubble and dc_carped as optional plugins to the installer. All of these support DirectColoring.
* Fixed a bug which prevented the mouse cursors from changing when hovering a transform "widget" in the editor window.
* Changed the script procedure "ShowStatus([string])" so it now displays a status message again in the first panel of the main status bar.
* Rotating the gradient using a drag operation on the gradient display now updates the value text box.
* Fixed some random weirdness within the built-in curl- and curl3D-variations.

7x.13
* Enabled the "Opacity" field in the editor to react on double clicks. (changes to zero if opacity is set to one, elsewise to one)
* Fixed a bug which could made the script system unable to change the transform data after using an AddTransform-command in some very rare cases.
* Made some "cosmetic" changes to the application icon and title string.
* Changed the guidelines notice in the options window as it is indeed possible to show them when transparency is not enabled in the main preview.
* Fixed numerous "Floating point"-errors in the 32- and 48-bit renderer code.
* Added an enumeration of scripts within the "[ApoDirectory]\Scripts" folder. This enumeration is shown in the scripts menu to quick-access your script library.
* "GammaTreshold" is now accessible in scripts. ("Flame.GammaTreshold := value")
* You can now also use "ColorSpeed" to access the symmetry property in scripts. ("Transform.ColorSpeed := value")
* Added functionality to turn a given flame into a script which reproduces the flame except of its gradient.
* Renamed "randFilename" to "Apophysis7X.rand" (was "apophysis.rand"), "undoFilename" to "Apophysis7X.undo" (was "apophysis.undo") and "templateFilename" to "Apophysis7X.temp" (was "default.temp")
* You can now specify a script which executes automatically when Apophysis starts. You have to name this file "autoexec.asc" and it must be in the Apophysis directory.
* The plugin selection in the installer was simplified to groups rather than individual plugins.
* The installer contains the official plugin pack from SourceForge now.
* The default scripts from Apo2.02 were replaced by a smaller set of example scripts. These remain optional and can be selected in the installer.
* The default path of the function library is now [ApoDirectory]\functions.asc (moved out of the scripts folder as it will be enumerated in the program)
* Changed the plugin enumeration code so that the plugins folder must now be at the location of the EXE-file rather than the location specified by the "Work Directory"-variable (CDIR)
* Added file type registration of .flam and .asc files to the installer so they open with Apo7X on double-click and assigned an icon to them (located at [ApoDirectory]\Resources\*.ico) - flames are simply being opened and displayed, scripts are opened and the script editor is shown.
* Template files (.template) got a file type registration as well. Double-clicking those will start a new tool which installs them into the correct directory. This tool works with the following command line: "resinstall.exe template [file name]". If you want to use this install tool separately, replace "file name" with the source path of the template pack wrapped in quotes (usually you don't need to do that)
* Disabled the (unfunctional yet) distance estimation tab in the adjust-window as this feature is still not ready in this release (sorry...)
* When clicking "save all parameters" in the file menu after editing one flame in a batch, the changes were reverted and the target file did not appear in the file system. This has been fixed.
* Included a new and recent help file as the previous versions were still using an ancient version from Apophysis 2.02. The new help file is way more detailed and should cover (almost) every recent feature of Apophysis 7X.

# 7x.12
* Enabled the renderer to write EXIF-data in JPEG files. This feature is optional. If it is enabled, Flame name, Apophysis version and optionally a custom author string and the corresponding parameters are written into the metatags of the JPEG render. This data will remain if you postwork your render in Photoshop.
* Added optional guidelines in the main window preview panel (originally appeared in Jed Kelseys Apo2.09 JK)
* Added functionality to change help file path (so you can insert the tutorial of your choice)
* Changed the entry "The fractal flame algorithm" in the help menu to open the following document in your default browser: http://www.flam3.com/flame_draves.pdf
* The plugin code had some little burps. Fixed these
* You can now distinguish whether you started the normal or the T500-version from the titlebar text

# 7x.11
* Following the 2.09 update, I've renamed the "symmetry" parameter to "color speed" to avoid any confusion among the new users
* Finally implemented the "transform opacity" option from 2.09 replacing the older "plotmode" a.k.a. "invisibility" parameter. It also can be scripted
* Apophysis 7X can now autosave in 1, 2, 5 and 10 minute intervals! You can set the autosave target as well as the interval in the option dialog. This is also the place where you enable and disable it
* Added a "T500" version which can handle up to 500 transforms
* Prepared the code for density estimation. It is an inactive feature yet but I try to finish it as soon as possible to help you kill the grain
* Performed tiny little fixes all over the code

# 7x.10
* Added copy and paste buttons in editor toolbar
* Added value textbox and reset button in gradient adjustment window
* Moved "Add linked XForm" button to the end of toolbar in editor window
* Gradient now randomized when a new flame is created from template
* Fixed the issue where the render dialog did not properly pass the default file extension to the Commdlg32-library (always ".bmp" extension selected)
* Fixed a bug which caused some variables to reset when duplicating an XForm
* Changed the toolbar routine back to fixed layout on popular demand
* Removed the update feature
* Reverted the plugin code to 7X.8 state (the most stable version)
* Removed countless smaller bugs

# 7x.9
* Added functionality to check for updates on startup
* Added "opacity" tag in XML parser to make flames compatible to official 2.09 version of Apophysis
* Added "Reset file content list width" button in options menu
* Added possibility to set a name for an XForm
* Improved update system to get the list of changes visible in the program
* Fixed a bug where the color box in post render window did not react on clicks

# 7x.8
* Added "create linked xform" button in editor toolbar
* Fixed loading glitch in template system
* Fixed a bug where the "open" dialogs have a "save" button instead of an "open" one
* Removed confirm box when selecting .flame file in the "Save flame" dialog

# 7x.7
* Added template system
* Moved weight box below transform selection in editor
* Changed open/save file dialogs to those natively offered by OS

# 7x.6
* Added possibility to remember last open flame file
* Added possibility to change thumbnail size out of small (96x96) and large (128x128)
* Replaced main toolbar component to make sub-toolbars able to be reordered
* Fixed OnClick procedure in editor's color bar
* Fixed a bug causing "Invalid ImageList Index" when deleting flame in classic list view mode

# 7x.5
* Added "New flame" and "Render all" buttons in main toolbar
* Added progress bar for preview rendering
* Added gradient display bar in editor's color tab
* Added a button to clear out variations in editor's variation tab
* Added a "Go to folder" button in render window
* Moved "Options" button in main toolbar
* Resized quality box in main toolbar
* Resized thumbnails to 96x96 pixels
* Made "hide unused variables" default
* Changed main toolbar to wrap when window is too small
* Made variation names case-insensitive in scripts
* Made color box in editor react on clicks again
* Fixed background color box in options window

# 7x.4
* Fixed a bug which caused "Access violation" error when deleting a flame
* Fixed a bug which caused the clear-out of "renders3D.flame"
* Fixed a bug which caused editor background being white when there are no registry settings yet
* Fixed a bug which made the paste feature malfunctioning and giving "Cannot open clipboard" error sometimes
* Fixed a bug where the script engine did not translate from radians to angle and vice versa when using Flame.Pitch or Flame.Yaw
* Renamed "renders3D.flame" to "renders7X.flame"

# 7x.3
* Added security checks to avoid "List Index out of Bounds" error on several places
* Changed thumbnail feature to be disabled by default

# 7x.2
* Added possibility to check for updates within Apophysis
* Added possibility to hide unused variations and variables

# 7x
* Added loading progress bar and decreased thumbnail quality for faster loading
* Re-enabled export flame feature
* Fixed the batch render function

# 2.06b
* Single-transform flames are now understood by scripts.

# 2.06a
* Fixed incorrectly quoted output filename, wile exporting to flam3-render

# 2.06
* Flame.Angle property in scripting language
* Missing flam3-render.exe file message clarified
* Getting a random gradient from a given file
* Added *.flam3 file extension to the 'Open File' dialog
* 'Render all flames' function added
* Application exiting warning dialog
* Stopping a render confirmation dialog
* Stretching a gradient with ctrl+drag
* .flame files are now renamed to .bak before saving to them
* fixed PostXForm bug in non-asm code
* Changing a background color doesn't require a flame recalculation
* Two new variations: rectangles and super_shape
* Output file path fixed, when exporting a flame to flam3
* Transparency option flag taken into account, when exporting a flame to flam3
* Plugin engine for adding custom variations
* Nonsense limitation of a minimum 2-transforms flame scrapped. 
*  Additionally, "New blank flame" function produces a single-transform flame.
* Other minor bugs and changes

# 2.03b
* Fixed swapped rings and fan variations
* Fixed Contrast button label
* Fixed "Undo list index out of range" bug
* Added new variation: bubble
* Some minor fixes

# 2.03a
* Fixed save flame naming problem
* Integration with 2.02z
* Save png transparent images
* multithread rendering
* Parameterized variations
* blob variation
* pdj variation
* Added definable limit of added variations count when generating symmetric flames

# 2.02i
* Fixed Randomize gradient in batch bug
* Fixed Randomize gradient floating point error
* Fixed spiral batch script bug
* B1227562 Background will remain the same (depending on options)
* Fixed Zoom out
* Fixed Offset problems in editor and mutation form
* Added triangle scale buttons in editor
* Shift-Alt-Ctrl mouse actions in editor are bound to the values on the triangle tab
* FR1221967 'Randomize color value' got Ctrl+N shortcut
* Added 'Save all parameters' option to the main menu
* Added screensaver
* Added triangle rotating pivot controls
* fixed Copy/Paste on scripting form
* fixed Resize On load

# 2.02h
* Disable screen saver when rendering to disk
* Automatic system shutdown after rendering completion
* B1116907 Values Editing events
* FR1183940 Added triangle rotation functions in the editors popup menu.
* Added gradient drawing in a tooltip form in the gradient browser window.
* Editor window now has controls for precise moving and rotating triangles.
* Fixed a bug causing floating point errors on big unzooming and other editing tasks.
* Added form to modify the image after rendering.
* B1199407 'Use current' gradient option bug
* Add zoom out functionality on main form
* compact format for copy/paste

# 2.02g
* Delphi2005 Project
* Extra performance in transformations
* 32-bits renderer
* B1105518 writing large jpeg fails
* B1102823 Renderer still hangs
* B1111184 fixed remainder of clock not on 00:00:00 when finished
* B1115635 Menu Item 'Stop Script' now has the shortcut (ctrl-T)
* Menu Item 'Open Script' now has the shortcut (ctrl-E)
* Script function CopyFile works as in 2.02, with 2 parameters
* Rotation export for flame2.3
* added new variants
* Bugfix filter difference between Apo and Flame3
* Added an end date (20/06/2005)
* B1162083 problem with sliced render to disk
* Fixed some floating point problems
