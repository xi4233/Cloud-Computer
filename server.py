from flask import Flask, jsonify, request
from flask_cors import CORS
import subprocess
import os

app = Flask(__name__)
CORS(app)

VMRUN = r"E:\vm\vmrun.exe"
VMWARE = r"E:\vm\vmware.exe"
VMX_PATH = r"E:\win 11\文件\日常使用win11.vmx"
VM_NAME = "日常使用win11"


def is_vm_running():
    try:
        result = subprocess.run(
            [VMRUN, "-T", "ws", "list"],
            capture_output=True, text=True, timeout=10
        )
        if result.returncode != 0:
            return None
        return VMX_PATH in result.stdout
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return None


@app.route("/start_vm", methods=["POST", "OPTIONS"])
def start_vm():
    if request.method == "OPTIONS":
        return jsonify(), 200

    running = is_vm_running()

    if running is None:
        return jsonify({
            "status": "failed",
            "message": f"无法获取虚拟机状态，请确认 vmrun 可用（路径: {VMRUN}）"
        })

    if running:
        return jsonify({
            "status": "already_running",
            "message": f"虚拟机 \"{VM_NAME}\" 已在运行中"
        })

    try:
        result = subprocess.run(
            [VMWARE, "-x", VMX_PATH],
            capture_output=True, text=True, timeout=30
        )
        import time
        time.sleep(3)

        running_after = is_vm_running()
        if running_after:
            return jsonify({
                "status": "success",
                "message": f"虚拟机 \"{VM_NAME}\" 已启动（弹出窗口中请输入解密密码）"
            })

        return jsonify({
            "status": "failed",
            "message": "虚拟机未成功启动，请在弹出的 VMware 窗口中输入解密密码"
        })
    except FileNotFoundError:
        return jsonify({
            "status": "failed",
            "message": f"vmware.exe 未找到，请确认路径正确: {VMWARE}"
        })
    except subprocess.TimeoutExpired:
        return jsonify({
            "status": "failed",
            "message": "启动虚拟机超时"
        })


@app.route("/vm_status", methods=["GET"])
def vm_status():
    running = is_vm_running()
    if running is None:
        return jsonify({"status": "unknown", "message": "无法获取虚拟机状态"})
    state = "running" if running else "stopped"
    return jsonify({"status": state, "message": f"虚拟机 \"{VM_NAME}\" 当前状态: {state}"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
