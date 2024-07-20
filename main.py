import subprocess
import time

def start_process(command):
    process = subprocess.Popen(command, shell=True)
    return process
backend_command = "python3 backend/server.py"
backend_process = start_process(backend_command)
time.sleep(4)
http_server_command = "python -m http.server 8080"
http_server_process = start_process(http_server_command)

print("Both backend server and HTTP server are running.")
print("View website at 'http://localhost:8080/frontend/templates/'")
try:
    backend_process.wait()
    http_server_process.wait()
except KeyboardInterrupt:
    print("Terminating the servers...")
    backend_process.terminate()
    http_server_process.terminate()
    backend_process.wait()
    http_server_process.wait()
    print("Servers terminated.")
