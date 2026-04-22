#
# Copyright (C) 2018-2019 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_ENFORCE_SYSPROP_OWNER := true

BOARD_VENDOR := oneplus

VENDOR_PATH := device/oneplus/sm8150-common

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a76
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

ifeq (,$(filter %_64,$(TARGET_PRODUCT)))
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a76
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a76
endif

# scudo-free libc32
MALLOC_SVELTE_FOR_LIBC32 := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msmnile
TARGET_NO_BOOTLOADER := true

# Kernel
#BOARD_BOOT_HEADER_VERSION := 2
#BOARD_KERNEL_BASE := 0x00000000
#BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048 loop.max_part=7 androidboot.usbcontroller=a600000.dwc3  kpti=off
#BOARD_KERNEL_CMDLINE += androidboot.vbmeta.avb_version=1.0 buildvariant=userdebug
#BOARD_KERNEL_IMAGE_NAME := Image
#BOARD_KERNEL_PAGESIZE := 4096
#BOARD_KERNEL_SEPARATED_DTBO := true
#BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
#BOARD_RAMDISK_USE_LZ4 := true
#TARGET_KERNEL_ADDITIONAL_FLAGS := LLVM=1 LD=ld.lld AS=llvm-as AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument"
#TARGET_KERNEL_CLANG_VERSION := r547379
#TARGET_KERNEL_CONFIG := gulch_defconfig vendor/debugfs.config
#TARGET_KERNEL_SOURCE := kernel/oneplus/sm8150

# --- Kernel 配置部分 ---
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048 loop.max_part=7 androidboot.usbcontroller=a600000.dwc3 kpti=off
BOARD_KERNEL_CMDLINE += androidboot.vbmeta.avb_version=1.0 buildvariant=userdebug
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_RAMDISK_USE_LZ4 := true

# --- 修复核心：强制指定编译器和三元组 ---
# 1. 显式指定 clang_triple，这是影响编译 ABI 的最关键参数
# 2. 使用绝对路径指向 wrapper，彻底拦截 Soong 的参数污染
TARGET_KERNEL_CLANG_TRIPLE := aarch64-linux-gnu-
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-gnu-

# 这里的 TARGET_KERNEL_CC 必须使用绝对路径
# $(LOCAL_PATH) 通常指向设备树目录
TARGET_KERNEL_CC := $(shell pwd)/device/oneplus/sm8150-common/clang_wrapper.sh

# 补充 LLVM 编译所需变量，并注入 CC 指向我们的 Wrapper
TARGET_KERNEL_ADDITIONAL_FLAGS := \
    LLVM=1 \
    LLVM_IAS=1 \
    CLANG_TRIPLE=$(TARGET_KERNEL_CLANG_TRIPLE) \
    CROSS_COMPILE=$(TARGET_KERNEL_CROSS_COMPILE_PREFIX) \
    CC=$(TARGET_KERNEL_CC) \
    LD=ld.lld \
    AS=llvm-as \
    AR=llvm-ar \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument"

TARGET_KERNEL_CLANG_VERSION := r547379
TARGET_KERNEL_CONFIG := gulch_defconfig vendor/debugfs.config
TARGET_KERNEL_SOURCE := kernel/oneplus/sm8150

# Platform
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := msmnile

# Properties
TARGET_PRODUCT_PROP += $(VENDOR_PATH)/product.prop
TARGET_SYSTEM_PROP += $(VENDOR_PATH)/system.prop
TARGET_SYSTEM_EXT_PROP += $(VENDOR_PATH)/system_ext.prop
TARGET_VENDOR_PROP += $(VENDOR_PATH)/vendor.prop

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    system \
    vendor \
    vbmeta

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "qualcomm-hidl"

# Audio
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
USE_CUSTOM_AUDIO_POLICY := 1

# Camera
TARGET_USES_QTI_CAMERA_DEVICE := true
USE_DEVICE_SPECIFIC_CAMERA := true
TARGET_CAMERA_SERVICE_EXT_LIB := //$(VENDOR_PATH):libcameraservice_extension.opsm8150

# FOD
$(call soong_config_set,surfaceflinger,udfps_lib,//hardware/oneplus:libudfps_extension.oneplus)
# Display
MAX_VIRTUAL_DISPLAY_DIMENSION := 4096
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_USES_FOD_ZPOS := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_ION := true

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(VENDOR_PATH)/config.fs

# HIDL
DEVICE_MATRIX_FILE += $(VENDOR_PATH)/compatibility_matrix.xml
DEVICE_MANIFEST_FILE += $(VENDOR_PATH)/manifest.xml
ODM_MANIFEST_FILES += $(VENDOR_PATH)/manifest-qva.xml

# Init
$(call soong_config_set,libinit,vendor_init_lib,//$(VENDOR_PATH):libinit_oneplus-sm8150)
TARGET_RECOVERY_DEVICE_MODULES := libinit_oneplus-sm8150

# Disable sparse on all filesystem images
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
TARGET_USERIMAGES_SPARSE_EROFS_DISABLED := true

# Metadata
BOARD_USES_METADATA_PARTITION := true

# Partitions
BOARD_EROFS_COMPRESSOR := lz4
BOARD_EROFS_PCLUSTER_SIZE := 262144
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_VENDOR := vendor

# Recovery
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 120
TARGET_USERIMAGES_USE_F2FS := true

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2022-06-01

# SELinux
include device/qcom/sepolicy_vndr/SEPolicy.mk

BOARD_VENDOR_SEPOLICY_DIRS += $(VENDOR_PATH)/sepolicy/vendor
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(VENDOR_PATH)/sepolicy/private
PRODUCT_PUBLIC_SEPOLICY_DIRS += $(VENDOR_PATH)/sepolicy/public

# Sensors
SOONG_CONFIG_NAMESPACES += ONEPLUS_MSMNILE_SENSORS
SOONG_CONFIG_ONEPLUS_MSMNILE_SENSORS := ALS_POS_X ALS_POS_Y

# Verified Boot
BOARD_AVB_ENABLE := true
ifneq (user,$(TARGET_BUILD_VARIANT))
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
else ifneq (,$(wildcard vendor/yaap/signing/keys/releasekey.key))
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := vendor/yaap/signing/keys/releasekey.key
else
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
endif


# WiFi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_EVENT := "ON"
WIFI_DRIVER_DEFAULT := qca_cld3
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# FCM
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    device/oneplus/sm8150-common/vendor_framework_compatibility_matrix.xml \
    $(VENDOR_PATH)/configs/vintf/oneplus_vendor_framework_compatibility_matrix.xml

