from Crypto.Cipher import AES

def AES_Encryption(input, key) :
    plaintext = bytes.fromhex(input)
    key = bytes.fromhex(key)
    cipher = AES.new(key, AES.MODE_ECB).encrypt(plaintext)
    return cipher.hex()

if __name__ == "__main__":
    input = "00112233445566778899aabbccddeeff"
    key = "000102030405060708090a0b0c0d0e0f"
    encrypted_output = AES_Encryption(input, key)
    print("Encrypted Output:", encrypted_output)
    # Expected Output: 69c4e0d86a7b0430d8cdb78070b4c55a