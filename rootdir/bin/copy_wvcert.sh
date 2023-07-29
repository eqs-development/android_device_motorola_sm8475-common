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


if [ -f $SRC ]
then
    prop=`getprop $SECURE_PROP`
    if [ "$prop" == "0" -a ! -f $HAS_COPIED ]
	then
		notice "copy widevine to perist:"
		cp $SRC $DEST
		echo "1" > /mnt/vendor/persist/data/pfm/licenses/.wv_copy_done
	fi
fi
