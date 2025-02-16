import json
import time
from datetime import datetime, timezone
from stream_manager import (
    StreamManagerClient,
    MessageStreamDefinition,
    StrategyOnFull,
    ExportDefinition,
    KinesisConfig,
    exceptions
)

class StreamManagerHelper:
    def __init__(self):
        self.client = None

    def connect(self):
        """
        Connect to Stream Manager and initialize the client.
        """
        if not self.client:
            self.client = StreamManagerClient()
            print("Successfully connected to Stream Manager!")

    def close(self):
        """
        Close the connection to Stream Manager.
        """
        if self.client:
            self.client.close()
            self.client = None
            print("Connection to Stream Manager closed.")

    def delete_stream(self, stream_name):
        """
        Delete a stream in Stream Manager if it exists.
        """
        try:
            self.connect()
            self.client.delete_message_stream(stream_name=stream_name)
            print(f"Stream '{stream_name}' deleted successfully!")
        except exceptions.ResourceNotFoundException:
            # Handle case where the stream does not exist
            print(f"Stream '{stream_name}' does not exist. Skipping deletion.")
        except exceptions.InvalidRequestException as e:
            print(f"Invalid request while deleting the stream '{stream_name}': {e}")
        except Exception as e:
            print(f"An unexpected error occurred while deleting the stream: {e}")

    def create_kinesis_stream(self, stream_name, kinesis_stream_name):
        """
        Create a stream in Stream Manager and configure it for Kinesis Data Streams export.
        """
        try:
            self.connect()
            kinesis_config = KinesisConfig(
                identifier="MyKinesisExport",
                kinesis_stream_name=kinesis_stream_name,
                batch_size=2,  # Send data in batches of 2 messages
                batch_interval_millis=60000,  # Send data every 60 seconds
                priority=1,  # High priority
                start_sequence_number=0,  # Start from the beginning
                disabled=False  # Enable export
            )
            self.client.create_message_stream(MessageStreamDefinition(
                name=stream_name,
                max_size=268435456,  # 256 MB
                strategy_on_full=StrategyOnFull.OverwriteOldestData,
                export_definition=ExportDefinition(kinesis=[kinesis_config])
            ))
            print(f"Stream '{stream_name}' created and configured for Kinesis export successfully!")
        except exceptions.InvalidRequestException as e:
            if "the message stream already exists" in str(e):
                print(f"Stream '{stream_name}' already exists. Continuing...")
            else:
                raise
        except Exception as e:
            print(f"An error occurred while creating the stream: {e}")

    def send_json_messages(self, stream_name, count=5):
        """
        Send JSON messages with timestamps to the specified stream multiple times.
        """
        try:
            self.connect()
            for i in range(count):
                message = {
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                    "message": f"This is message {i + 1}"
                }
                sequence_number = self.client.append_message(
                    stream_name=stream_name,
                    data=json.dumps(message).encode('utf-8')
                )
                print(f"Sent message {i + 1} to stream '{stream_name}' with sequence number: {sequence_number}")
                time.sleep(1)
        except Exception as e:
            print(f"An error occurred while sending messages: {e}")

# Usage
stream_name = "Stream1"
kinesis_stream_name = "Stream1"  # Ensure this exists in Kinesis

stream_manager = StreamManagerHelper()

# Delete the stream if it exists
stream_manager.delete_stream(stream_name)

# Create the stream for Kinesis export
stream_manager.create_kinesis_stream(stream_name, kinesis_stream_name)

# Send messages to the stream
stream_manager.send_json_messages(stream_name, count=60000)

# Close the Stream Manager client
stream_manager.close()