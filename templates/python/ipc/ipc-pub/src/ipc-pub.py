import sys
import time
import traceback

from awsiot.greengrasscoreipc.clientv2 import GreengrassCoreIPCClientV2
from awsiot.greengrasscoreipc.model import (
    PublishMessage,
    BinaryMessage
)


def main():
    args = sys.argv[1:]
    topic = args[0]
    message = args[1]
    print(f"Publishing to topic: {topic}")

    try:
        ipc_client = GreengrassCoreIPCClientV2()

        while True:
            try:
                publish_binary_message_to_topic(ipc_client, topic, message)
                print(f'Successfully published to topic: {topic}')
            except Exception:
                print('Exception occurred while publishing', file=sys.stderr)
                traceback.print_exc()

            time.sleep(1)

    except Exception:
        print('Exception occurred', file=sys.stderr)
        traceback.print_exc()
        exit(1)


def publish_binary_message_to_topic(ipc_client, topic, message):
    binary_message = BinaryMessage(message=bytes(message, 'utf-8'))
    publish_message = PublishMessage(binary_message=binary_message)
    return ipc_client.publish_to_topic(topic=topic, publish_message=publish_message)


if __name__ == '__main__':
    main()

