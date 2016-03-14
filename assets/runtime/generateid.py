import base64
import binascii
import hashlib
import sys

mod = binascii.unhexlify(sys.argv[1])
exp = bytearray([int(sys.argv[2])])
enc = base64.b64encode(mod) + ' ' + base64.b64encode(exp)
print(hashlib.sha1(enc).hexdigest())
