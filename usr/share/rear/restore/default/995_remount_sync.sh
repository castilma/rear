#
# At the end of the restoreonly WORKFLOW
# remount all what is mounted below /mnt/local with sync option.
# cf. finalize/default/900_remount_sync.sh in the recover WORKFLOW
#
# User can still do stuff after "rear recover" had finished
# but rebooting without umount is not so tragic any more.
# On the other hand remounting with sync option could become
# in practice a major annoyance because it makes writing
# anything below /mnt/local basically unusable slow,
# see https://github.com/rear/rear/issues/1097
#
# Remounting with sync option is no longer needed when systemd is used because
# when systemd is used reboot, halt, poweroff, and shutdown are replaced by
# scripts that do umount plus sync to safely shut down the recovery system,
# cf. https://github.com/rear/rear/pull/1011

# Skip if not restoreonly WORKFLOW:
test "restoreonly" = "$WORKFLOW" || return 0

# Skip if systemd is used
# systemctl gets copied into the recovery system as /bin/systemctl:
test -x /bin/systemctl && return 0

while read mountpoint device mountby filesystem junk ; do
    if ! mount -o remount,sync "${device}" $TARGET_FS_ROOT"$mountpoint" ; then
        LogPrint "Remount sync of '${device}' failed. Do not reboot without umount."
        # Cf. /bin/reboot in the ReaR rescue/recovery system:
        LogPrint "syncing disks and waiting 3 seconds..."
        sync
        sleep 3
    fi
done < "${VAR_DIR}/recovery/mountpoint_device"

