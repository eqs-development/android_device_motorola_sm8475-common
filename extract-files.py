#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

from __future__ import annotations

from typing import List


from extract_utils.main import (
    ExtractUtilsModule,
)

from extract_utils.fixups_blob import (
    blob_fixups_user_type,
    blob_fixup,
)

from extract_utils.fixups_lib import (
    lib_fixups_user_type,
    lib_fixup_vendorcompat,
    libs_proto_3_9_1,
)

from extract_utils.extract import extract_fns_user_type
from extract_utils.extract_star import extract_star_firmware


namespace_imports = [
    'device/motorola/sm8475-common',
    'hardware/qcom-caf/sm8450',
    'hardware/qcom-caf/wlan',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/dataservices',
]


libs_add_vendor_suffix = (
    'vendor.qti.hardware.qccsyshal@1.0',
    'vendor.qti.hardware.qccsyshal@1.1',
    'vendor.qti.qspmhal@1.0',
    'vendor.qti.imsrtpservice@3.0',
    'vendor.qti.diaghal@1.0',
    'com.qualcomm.qti.dpm.api@1.0',
)

libs_remove = (
    'vendor.qti.hardware.pal@1.0-impl',
    'libagmclient',
    'libpalclient',
    'libwpa_client',
    'libqsap_sdk',
)


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    if partition != 'vendor':
        return None

    return f'{lib}-{partition}'


def lib_fixup_remove(lib: str, *args, **kwargs):
    return ''


lib_fixups: lib_fixups_user_type = {
    libs_proto_3_9_1: lib_fixup_vendorcompat,
    libs_add_vendor_suffix: lib_fixup_vendor_suffix,
    libs_remove: lib_fixup_remove,
}


blob_fixups: blob_fixups_user_type = {
    'system_ext/etc/permissions/moto-telephony.xml': blob_fixup().regex_replace(
        '/system/', '/system_ext/'
    ),
    (
        'vendor/bin/hw/android.hardware.security.keymint-service-qti',
        'vendor/lib64/libqtikeymint.so',
    ): blob_fixup()
    .replace_needed(
        'android.hardware.security.keymint-V1-ndk_platform.so',
        'android.hardware.security.keymint-V1-ndk.so',
    )
    .replace_needed(
        'android.hardware.security.secureclock-V1-ndk_platform.so',
        'android.hardware.security.secureclock-V1-ndk.so',
    )
    .replace_needed(
        'android.hardware.security.sharedsecret-V1-ndk_platform.so',
        'android.hardware.security.sharedsecret-V1-ndk.so',
    )
    .add_needed('android.hardware.security.rkp-V1-ndk.so'),
    'vendor/bin/qcc-trd': blob_fixup().replace_needed(
        'libgrpc++_unsecure.so', 'libgrpc++_unsecure_prebuilt.so'
    ),
    'vendor/lib64/libmotext_inf.so': blob_fixup().remove_needed('libril.so'),
    'system_ext/priv-app/ims/ims.apk': blob_fixup().apktool_patch(
        'ims-patches'
    ),
    'vendor/lib64/vendor.libdpmframework.so': blob_fixup().add_needed(
        'libhidlbase_shim.so'
    ),
    'vendor/lib64/libqcodec2_core.so': blob_fixup().add_needed(
        'libcodec2_shim.so'
    ),
}

extract_fns: extract_fns_user_type = {
    r'(bootloader|radio)\.img': extract_star_firmware,
}

module = ExtractUtilsModule(
    'sm8475-common',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    extract_fns=extract_fns,
    check_elf=True,
)
