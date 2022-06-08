from stem import Signal
from stem.control import Controller

with Controller.from_port(port=9051) as controller:
  # Authenticating to our controller with the password
  # we used when we used the 'tor --hash-password' command
  controller.authenticate(password="we@kT@r")
  # Send signal to Tor controller to create new identity
  # (a new exit node IP)
  controller.signal(Signal.NEWNYM)

