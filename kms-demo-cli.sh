# 1) encryption
aws kms encrypt --key-id alias/demo-key --plaintext fileb://example-secret.txt --output text --query CiphertextBlob  --region eu-central-1 > example-secret-encrypted.base64

# base64 decode for Linux or Mac OS 
cat example-secret-encrypted.base64 | base64 --decode > example-secret-encrypted

# base64 decode for Windows
certutil -decode .\ExampleSecretFileEncrypted.base64 .\ExampleSecretFileEncrypted


# 2) decryption

aws kms decrypt --ciphertext-blob fileb://example-secret-encrypted   --output text --query Plaintext > example-secret-decrypted.base64  --region eu-central-1

# base64 decode for Linux or Mac OS 
cat example-secret-decrypted.base64 | base64 --decode > example-secret-decrypted.txt


# base64 decode for Windows
certutil -decode .\ExampleFileDecrypted.base64 .\ExampleFileDecrypted.txt