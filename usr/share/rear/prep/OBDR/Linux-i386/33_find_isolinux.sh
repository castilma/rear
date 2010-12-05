# find isolinux.bin or abort if it cannot be found

# find isolinux.bin
if ! test -s "$ISO_ISOLINUX_BIN" ; then
	for file in /usr/{share,lib,libexec}/*/isolinux.bin ; do
		if test -s "$file" ; then
			ISO_ISOLINUX_BIN="$file"
			break # for loop
		fi
	done

fi
test -s "$ISO_ISOLINUX_BIN" 
ProgressStopIfError $? "Could not find 'isolinux.bin'. Maybe you have to set ISO_ISOLINUX_BIN [$ISO_ISOLINUX_BIN] or install the syslinux package ?"
