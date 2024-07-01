# Pinball
 Code used on a touchscreen connected to a Raspberry Pi for High scores

 Tested functional on a Raspberry Pi 4B connected to a BIGTREETECH PITFT50 V2.1 touchscreen.

 Notes on getting the install functional:
 1. Install Raspbian Lite
 2. Set a static IP for connecting to it later. Either do this by setting a static IP on the Pi, or a DHCP reservation on your network.
 4. Install Openbox as the front-end GUI (It is extremely lightweight without any menus, thus not having *any* overhead).
 5. Upon boot-up, use "sudo raspi-config" to configure the pi to login automatically to the gui. Reboot.
 6. Either SSH to the Pi (easiest to not need a second keyboard), or plug a keyboard into the Pi along with a mouse to open the terminal.
 7. Install Vulkan and all its dependencies (Just Google this. Pi 4 is a single command after dependencies, Pi 3 and earlier is harder).
 8. When packaging the game, use the "Include PCK" option and make sure you are building it for "arm64"
 9. Transfer the compiled game to the Raspberry Pi; I recommend using SFTP
 10. In a terminal window, perform "sudo chmod a+x Pinball.*" to make the *.sh and *.arm64 files executable.
 11. *Note:* Anytime you update these files (such as a re-upload via SFTP from a recompile), you will need to do #10 again
 12. Add Pinball.sh to Openbox's autostart list.
 13. Reboot.

 CONGRATS! You're all done!
