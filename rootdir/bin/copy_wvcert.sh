#!/vendor/bin/sh

SCRIPT_NAME="copy_wvcert.sh"
SRC="/vendor/etc/qcom_widevine_licenses.pfm"
DEST="/mnt/vendor/persist/data/pfm/licenses/qcom_widevine_licenses.pfm"
SECURE_PROP="ro.boot.secure_hardware"
HAS_COPIED="/mnt/vendor/persist/data/pfm/licenses/.wv_copy_done"

debug()
{
    echo "Debug: $*"
}

notice()
{
    echo "Debug: $*"
    echo "$SCRIPT_NAME: $*" > /dev/kmsg
}

current_md5=`md5sum $DEST.inst | cut -d" " -f1`
source_md5=`md5sum $SRC | cut -d" " -f1`
notice "current_md5:$current_md5"
notice "source_md5:$source_md5"

if [ -f $SRC ]
then
    if [ ! -f $HAS_COPIED ]
    then
       notice "copy widevine to persist:"
       cp $SRC $DEST
       echo "1" > /mnt/vendor/persist/data/pfm/licenses/.wv_copy_done
    elif [ -f $HAS_COPIED -a "$current_md5" != "$source_md5" ]
    then
       notice "remove old widevine licenses"
       rm /mnt/vendor/persist/data/pfm/licenses/.wv_copy_done
       rm /mnt/vendor/persist/data/pfm/licenses/qcom_widevine_licenses.pfm
       rm /mnt/vendor/persist/data/pfm/licenses/qcom_widevine_licenses.pfm.inst
       notice "copy widevine to persist:"
       cp $SRC $DEST
       echo "1" > /mnt/vendor/persist/data/pfm/licenses/.wv_copy_done
    fi
fi

fsync $HAS_COPIED
fsync $DEST