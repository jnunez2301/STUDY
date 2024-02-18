from base64 import urlsafe_b64encode
  
b_str = b'Python is awesome!'
print('Data type of \'b_str\': ', type(b_str))

enc_str = urlsafe_b64encode(b_str)
print('Data type of encoded \'enc_str\': ', type(enc_str))

print('Encoded string: ', enc_str)