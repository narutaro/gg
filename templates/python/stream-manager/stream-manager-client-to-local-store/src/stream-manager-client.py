from datetime import datetime
import json
import time
from stream_manager import (
    StreamManagerClient,
    MessageStreamDefinition,
    StrategyOnFull,
    Persistence,
    ReadMessagesOptions,
    exceptions
)

class StreamManagerHandler:
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
        Close the Stream Manager client connection.
        """
        if self.client:
            self.client.close()
            print("Connection to Stream Manager closed.")

    def create_stream(self, stream_name):
        """
        Create a new stream in Stream Manager.
        """
        try:
            self.connect()
            self.client.create_message_stream(MessageStreamDefinition(
                name=stream_name,
                max_size=268435456,  # 256 MB
                strategy_on_full=StrategyOnFull.OverwriteOldestData,
                persistence=Persistence.File
            ))
            print(f"Stream '{stream_name}' created successfully!")
        except exceptions.InvalidRequestException as e:
            # Check if the exception is due to the stream already existing
            if "the message stream already exists" in str(e):
                print(f"Stream '{stream_name}' already exists. Continuing...")
            else:
                raise  # Re-raise other InvalidRequestExceptions
        except exceptions.ConnectFailedException:
            print("Failed to connect to Stream Manager. Is it running?")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

    def list_streams(self):
        """
        List all available streams in Stream Manager.
        """
        try:
            self.connect()
            streams = self.client.list_streams()
            print("Available streams:", streams)
        except exceptions.ConnectFailedException:
            print("Failed to connect to Stream Manager. Is it running?")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

    def send_data_to_stream(self, stream_name, message):
        """
        Send data to the specified stream in Stream Manager.
        """
        try:
            self.connect()
            sequence_number = self.client.append_message(stream_name=stream_name, data=message)
            print(f"Message sent to stream '{stream_name}' with sequence number: {sequence_number}")
        except exceptions.StreamNotFoundException:
            print(f"Stream '{stream_name}' does not exist. Please create it first.")
        except exceptions.ConnectFailedException:
            print("Failed to connect to Stream Manager. Is it running?")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

    def read_messages_from_stream(self, stream_name):
        """
        Read messages from the specified stream in Stream Manager.
        """
        try:
            self.connect()
            message_list = self.client.read_messages(
                stream_name=stream_name,
                options=ReadMessagesOptions(
                    desired_start_sequence_number=0,
                    min_message_count=1,
                    max_message_count=10,
                    read_timeout_millis=5000
                )
            )
            print(f"Read {len(message_list)} message(s) from stream '{stream_name}':")
            for msg in message_list:
                print(f"Sequence: {msg.sequence_number}, Data: {msg.payload.decode('utf-8')}")
        except exceptions.StreamNotFoundException:
            print(f"Stream '{stream_name}' does not exist. Please create it first.")
        except exceptions.NotEnoughMessagesException:
            print(f"Not enough messages available in stream '{stream_name}'.")
        except exceptions.ConnectFailedException:
            print("Failed to connect to Stream Manager. Is it running?")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

# Usage
stream_manager = StreamManagerHandler()
stream_name = "Stream1"

stream_manager.create_stream(stream_name)
stream_manager.list_streams()

# Send multiple messages
try:
    for i in range(10):  # Simulate a loop to send and read messages
        timestamp = datetime.utcnow().isoformat() + "Z"
        message = {"timestamp": timestamp, "data": f"Message {i}"}
        message_json = json.dumps(message).encode('utf-8')

        stream_manager.send_data_to_stream(stream_name, message_json)

        # Optional: Read messages after each write to simulate stream processing
        stream_manager.read_messages_from_stream(stream_name)

        time.sleep(1)  # Wait 1 second between messages
finally:
    stream_manager.close()

# Send single message
'''
stream_manager.send_data_to_stream(stream_name, b"This is a test message.")
stream_manager.read_messages_from_stream(stream_name)
stream_manager.close()
'''