#!/bin/sh

# create a helper script in /usr/local/bin to start the jar like a binary
printf "#!/bin/sh\njava -jar %s \"\$@\"" "$1" > "/usr/local/bin/$2"
chmod +x "/usr/local/bin/$2"
