#!/bin/bash

# 30分钟的时间间隔，以秒为单位
time_interval=120
last_change_time=$(date +%s)

while true; do
    # 检查git状态
    git_status=$(git status -s)

    if [ -n "$git_status" ]; then
        # 如果有文件变化，更新最后变化时间
        last_change_time=$(date +%s)
    else
        # 检查自上次变更以来是否过去了30分钟
        current_time=$(date +%s)
        time_elapsed=$((current_time - last_change_time))

        if [ $time_elapsed -ge $time_interval ]; then
            echo "No changes detected in the last 30 minutes. Committing changes..."

            # 添加所有变更的文件、提交并推送到远程仓库
			git status
            git add .
            git commit -m "Auto-update"
            git push origin main

            # 重置最后变更时间
            last_change_time=$(date +%s)
        fi
    fi

    # 每60秒检查一次
    sleep 60
done
