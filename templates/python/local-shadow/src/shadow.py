import json
import traceback
import awsiot.greengrasscoreipc
from awsiot.greengrasscoreipc.model import GetThingShadowRequest
from awsiot.greengrasscoreipc.model import UpdateThingShadowRequest

TIMEOUT = 10

def sample_get_thing_shadow_request(thing_name, shadow_name):
    try:
        # Set up the IPC client
        ipc_client = awsiot.greengrasscoreipc.connect()

        # Create a GetThingShadow request
        get_thing_shadow_request = GetThingShadowRequest()
        get_thing_shadow_request.thing_name = thing_name
        get_thing_shadow_request.shadow_name = shadow_name
        
        # Call GetThingShadow asynchronously
        op = ipc_client.new_get_thing_shadow()
        op.activate(get_thing_shadow_request)

        # Get the response asynchronously
        fut = op.get_response()

        # Wait for the result
        result = fut.result(TIMEOUT)

        # result.payload contains the state document (JSON-encoded byte string)
        payload = result.payload
        
        # Convert the payload to JSON if necessary (decode byte string and convert to JSON)
        state_document = json.loads(payload.decode('utf-8'))

        return state_document

    except ResourceNotFoundError as e:
        print(f"ResourceNotFoundError: Shadow '{shadow_name}' does not exist.")
        return None
    except Exception as e:
        # Handle other exceptions
        print(f"An error occurred: {e}")
        traceback.print_exc()  # Print the full stack trace for debugging
        return None


def create_shadow(thing_name, shadow_name, initial_state):
    try:
        # Set up the IPC client
        ipc_client = awsiot.greengrasscoreipc.connect()

        # Create an UpdateThingShadow request
        update_request = UpdateThingShadowRequest()
        update_request.thing_name = thing_name
        update_request.shadow_name = shadow_name
        update_request.payload = json.dumps(initial_state).encode('utf-8')

        # Call UpdateThingShadow asynchronously
        op = ipc_client.new_update_thing_shadow()
        op.activate(update_request)

        # Wait for the response
        fut = op.get_response()
        result = fut.result(10)

        print(f"Shadow '{shadow_name}' successfully created/updated.")
        return result.payload

    except Exception as e:
        print(f"An error occurred while creating the shadow: {e}")
        traceback.print_exc()
        return None


thing_name = "MyThingName"
shadow_name = "myNamedShadow"

# Create shadow
initial_state = {
    "state": {
        "desired": {
            "key1": "value1"
        }
    }
}
create_shadow(thing_name, shadow_name, initial_state)

# Get shadow
state_document = sample_get_thing_shadow_request(thing_name, shadow_name)
if state_document:
    print("State document:", state_document)
else:
    print("Failed to retrieve state document.")