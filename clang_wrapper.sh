#!/bin/bash
# 将传入的所有参数中的 target 强制替换为 aarch64-linux-gnu
# 注意：使用 clang-r547379 路径，请确保与你的构建环境一致
CLANG_PATH="/mnt/data/pixelos-16/prebuilts/clang/host/linux-x86/clang-r547379/bin/clang"

# 处理参数：将 --target=aarch64-linux-android 替换为 --target=aarch64-linux-gnu
# 同时也处理可能的 -target 参数
ARGS=("${@//--target=aarch64-linux-android/--target=aarch64-linux-gnu}")
ARGS=("${ARGS[@]//-target aarch64-linux-android/-target aarch64-linux-gnu}")

exec "$CLANG_PATH" "${ARGS[@]}"
