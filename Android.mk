#
# Copyright (C) 2022 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

ifneq ($(filter eqs zeekr,$(TARGET_DEVICE)),)
subdir_makefiles=$(call first-makefiles-under,$(LOCAL_PATH))
$(foreach mk,$(subdir_makefiles),$(info including $(mk) ...)$(eval include $(mk)))

include $(CLEAR_VARS)

# A/B builds require us to create the mount points at compile time.
# Just creating it for all cases since it does not hurt.
FIRMWARE_MOUNT_POINT := $(TARGET_OUT_VENDOR)/firmware_mnt
$(FIRMWARE_MOUNT_POINT): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating $(FIRMWARE_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/firmware_mnt

BT_FIRMWARE_MOUNT_POINT := $(TARGET_OUT_VENDOR)/bt_firmware
$(BT_FIRMWARE_MOUNT_POINT): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating $(BT_FIRMWARE_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/bt_firmware

DSP_MOUNT_POINT := $(TARGET_OUT_VENDOR)/dsp
$(DSP_MOUNT_POINT): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating $(DSP_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/dsp

FSG_MOUNT_POINT := $(TARGET_OUT_VENDOR)/fsg
$(FSG_MOUNT_POINT): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating $(FSG_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/fsg

SUPER_FSG_MOUNT_POINT := $(TARGET_OUT_VENDOR)/super_fsg
$(SUPER_FSG_MOUNT_POINT): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating $(SUPER_FSG_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/super_fsg

SUPER_MODEM_MOUNT_POINT := $(TARGET_OUT_VENDOR)/super_modem
$(SUPER_MODEM_MOUNT_POINT): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating $(SUPER_MODEM_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/super_modem

ALL_DEFAULT_INSTALLED_MODULES += $(FIRMWARE_MOUNT_POINT) $(BT_FIRMWARE_MOUNT_POINT) $(DSP_MOUNT_POINT) $(FSG_MOUNT_POINT) \
    $(SUPER_FSG_MOUNT_POINT) $(SUPER_MODEM_MOUNT_POINT)

WIFI_FIRMWARE_SYMLINKS := $(TARGET_OUT_VENDOR)/firmware/wlan/qca_cld
$(WIFI_FIRMWARE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating wifi firmware symlinks: $@"
	@mkdir -p $@/kiwi
	@mkdir -p $@/qca6490
	@mkdir -p $@/qca6750
	$(hide) ln -sf /vendor/etc/wifi/WCNSS_qcom_cfg.ini $@/WCNSS_qcom_cfg.ini
	$(hide) ln -sf /mnt/vendor/persist/kiwi/wlan_mac.bin $@/kiwi/wlan_mac.bin
	$(hide) ln -sf /vendor/etc/wifi/kiwi/WCNSS_qcom_cfg.ini $@/kiwi/WCNSS_qcom_cfg.ini
	$(hide) ln -sf /mnt/vendor/persist/qca6490/wlan_mac.bin $@/qca6490/wlan_mac.bin
	$(hide) ln -sf /vendor/etc/wifi/qca6490/WCNSS_qcom_cfg.ini $@/qca6490/WCNSS_qcom_cfg.ini
	$(hide) ln -sf /mnt/vendor/persist/qca6750/wlan_mac.bin $@/qca6750/wlan_mac.bin
	$(hide) ln -sf /vendor/etc/wifi/qca6750/WCNSS_qcom_cfg.ini $@/qca6750/WCNSS_qcom_cfg.ini

ALL_DEFAULT_INSTALLED_MODULES += $(WIFI_FIRMWARE_SYMLINKS)

CNE_APP_SYMLINKS := $(TARGET_OUT_VENDOR)/app/CneApp/lib/arm64
$(CNE_APP_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating CneApp symlinks: $@"
	@mkdir -p $@
	$(hide) ln -sf /vendor/lib64/libvndfwk_detect_jni.qti.so $@/libvndfwk_detect_jni.qti.so

ALL_DEFAULT_INSTALLED_MODULES += $(CNE_APP_SYMLINKS)

EXPAT_SYMLINKS := $(TARGET_OUT_VENDOR_EXECUTABLES)/expat
$(EXPAT_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Expat bin link: $@"
	@rm -rf $@
	@mkdir -p $(dir $@)
	$(hide) ln -sf motobox $@

ALL_DEFAULT_INSTALLED_MODULES += $(EXPAT_SYMLINKS)

EGL_LIB_SYMLINKS := $(TARGET_OUT_VENDOR)/lib
$(EGL_LIB_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating EGL LIB symlinks: $@"
	@mkdir -p $@
	$(hide) ln -sf egl/libEGL_adreno.so $@/libEGL_adreno.so
	$(hide) ln -sf egl/libGLESv2_adreno.so $@/libGLESv2_adreno.so
	$(hide) ln -sf egl/libq3dtools_adreno.so $@/libq3dtools_adreno.so

EGL_LIB64_SYMLINKS := $(TARGET_OUT_VENDOR)/lib64
$(EGL_LIB64_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating EGL LIB64 symlinks: $@"
	@mkdir -p $@
	$(hide) ln -sf egl/libEGL_adreno.so $@/libEGL_adreno.so
	$(hide) ln -sf egl/libGLESv2_adreno.so $@/libGLESv2_adreno.so
	$(hide) ln -sf egl/libq3dtools_adreno.so $@/libq3dtools_adreno.so

ALL_DEFAULT_INSTALLED_MODULES += $(EGL_LIB_SYMLINKS) $(EGL_LIB64_SYMLINKS)

endif
