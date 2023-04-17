require 'openssl'
require 'base64'
require 'json'


module Encrypt
    def self.generate_random_bytes(length)
      OpenSSL::Random.random_bytes(length)
    end

    def self.encrypt_with_aes_rsa(data, public_key, is_json)
      key = generate_random_bytes(32) # Generate a 256-bit random key for AES encryption
      iv = generate_random_bytes(16) # Generate a 128-bit random initialization vector for AES encryption

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

      rsa_public_key = OpenSSL::PKey::RSA.new(public_key)
      encrypted_key = rsa_public_key.public_encrypt(key, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
      encrypted_iv = rsa_public_key.public_encrypt(iv, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)

      encrypted_key_base64 = Base64.strict_encode64(encrypted_key)
      encrypted_iv_base64 = Base64.strict_encode64(encrypted_iv)

      { encrypted_data: encrypted_data, encrypted_key: encrypted_key_base64, encrypted_iv: encrypted_iv_base64 }
    end

    def self.get_json_encrypt_aes_rsa(json, public_key)
      encrypted_data = encrypt_with_aes_rsa(json, public_key, true)

      json_encrypt = {
        encrypted_data: encrypted_data[:encryptedData],
        encrypted_key: encrypted_data[:encryptedKey],
        encrypted_iv: encrypted_data[:encryptedIv]
      }

      json_encrypt.to_json
    end
  end