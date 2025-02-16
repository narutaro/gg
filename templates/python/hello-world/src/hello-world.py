import sys
import time

message = "Hello, I'm a Greengrass python component - %s!" % sys.argv[1]

while True:
  print(message)
  time.sleep(5)
