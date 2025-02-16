import sys
import time
import awsiot.greengrasscoreipc.clientv2 as clientV2

args = sys.argv
                    
topic = 'my/topic'
payload = args[1]
qos = '1'

ipc_client = clientV2.GreengrassCoreIPCClientV2()

try:
    while True:
        try:
            resp = ipc_client.publish_to_iot_core(topic_name=topic, qos=qos, payload=payload)
            print(f"Published to {topic} with payload: {payload}")
        except Exception as e:
            print(f"Error publishing message: {e}")

        time.sleep(5)
except KeyboardInterrupt:
    print("Interrupted by user. Closing IPC client.")
finally:
    ipc_client.close()
    print("IPC client closed.")