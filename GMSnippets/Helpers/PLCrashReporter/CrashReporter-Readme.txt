For Mac Users:

1. Connect the testing device to a Mac running iTunes.
2. In the Finder, choose Go > Go to Folder.
3. Enter ~/Library/Logs/CrashReporter/MobileDevice.
4. Open the folder identified by your device’s name.
5. Select the crash logs named after the app (e.g. "GMSnippets").
6. Zip the files and send them in an email message.

To avoid sending duplicate reports later, delete the crash reports you’ve sent.


For Windows Users:
1. Enter the crash log directory for your operating system in the Windows search field, replacing <user_name> with your Windows user name.

For crash log storage on Windows, type:
C:\Users\<user_name>\AppData\Roaming\Apple computer\Logs\CrashReporter/MobileDevice

For crash log storage on Windows XP, type:
C:\Documents and Settings\<user_name>\Application Data\Apple computer\Logs\CrashReporter

2. Open the folder named after your device's name, and send the crash logs for the app (e.g. "GMSnippets") in an email message.


Symbolicating Crash Logs:

1. Locate “symbolicatecrash” file e.g. /Applications/Xcode.app/Contents/SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash

Note: Use following terminal command to find the path of symbolicatecrash file:

> find . -name "symbolicatecrash"

2. Create an alias to easily use the symbolicatecrash commands.

> alias symbolicatecrash='/Applications/Xcode.app/Contents/SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash'

3. The symbolicatecrash needs the DEVELOPER_DIR environment variable to be set:

> export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"

4. Run the following command to symbolicate the crash log:

> symbolicatecrash applog.crash App.app.dSYM

or 

> symbolicatecrash -o applog-symbolicated.crash applog.crash App.app.dSYM

5. If the above doesn’t work, try the following:

> xcrun atos -o App.app/App -arch armv7 -l 0x10d51d000 0x000000010d53fbb3

or

> xcrun atos -o App.app/App -arch armv7s -l 0x10d51d000 0x000000010d53fbb3

or, for the simulator

> xcrun atos -o App.app/App -arch x86_64 -l 0x10d51d000 0x000000010d53fbb3
