require 'openssl'
require 'base64'
require 'json'

module Encrypt
  def self.generate_random_bytes(length)
    OpenSSL::Random.random_bytes(length)
  end

  def self.encrypt_with_aes_rsa(data, public_key, is_json)
    key = generate_random_bytes(32) # Generate a 256-bit random key for AES encryption
    iv = generate_random_bytes(12)  # GCM mode requires a 96-bit (12 bytes) random initialization vector

    cipher = OpenSSL::Cipher.new('AES-256-GCM')
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
    encrypted_key = rsa_encrypt(key, rsa_public_key)
    encrypted_iv = rsa_encrypt(iv, rsa_public_key)

    # Get the authentication tag from the cipher after encryption
    authentication_tag = cipher.auth_tag

    { encrypted_data: encrypted_data, encrypted_key: encrypted_key, encrypted_iv: encrypted_iv, authentication_tag: Base64.strict_encode64(authentication_tag) }
  end

  def self.rsa_encrypt(data, public_key)
    label = ''

    md = OpenSSL::Digest::SHA256
    cipher_text = public_key.public_encrypt(data, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)

    Base64.strict_encode64(cipher_text)
  end
end
