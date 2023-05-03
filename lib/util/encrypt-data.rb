require 'openssl'
require 'chilkat'
require 'base64'
require 'json'



module Encrypt
  def self.generate_random_bytes(length)
    prng = Chilkat::CkPrng.new()
    return prng.genRandom(length, "base64")
  end

  def self.encrypt_with_aes_rsa(data, public_key, is_json)
    key = generate_random_bytes(24) # Generate a 256-bit random key for AES encryption
    iv = generate_random_bytes(12) # Generate a 128-bit random initialization vector for AES encryption

    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv

    encrypted = if is_json
                  cipher.update(data.to_json) + cipher.final
                else
                  cipher.update(data) + cipher.final
                end

    encrypted_data = Base64.strict_encode64(encrypted)

    ####
    pubkey = Chilkat::CkPublicKey.new()
    success = pubkey.LoadFromString(public_key)
    if (success != true)
      print pubkey.lastErrorText() + "\n";
      exit
    end

    rsa = Chilkat::CkRsa.new()
    rsa.put_OaepPadding(true)
    rsa.put_OaepHash("sha256")
    rsa.put_OaepMgfHash("sha256")
    rsa.ImportPublicKeyObj(pubkey)
    rsa.put_EncodingMode("base64")

    bUsePrivateKey = false
    encrypted_key = rsa.encryptStringENC(key, bUsePrivateKey)
    encrypted_iv = rsa.encryptStringENC(iv, bUsePrivateKey)
    if (rsa.get_LastMethodSuccess() != true)
      print rsa.lastErrorText() + "\n";
      exit
    end

    { encrypted_data: encrypted_data, encrypted_key: encrypted_key, encrypted_iv: encrypted_iv }
  end

end