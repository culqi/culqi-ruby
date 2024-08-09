require 'minitest/autorun'
require 'culqi-ruby'

Culqi.public_key = 'INSERTE_SU_LLAVE_PUBLICA'
Culqi.secret_key = 'INSERTE_SU_LLAVE_PRIVADA'
Culqi.rsa_id = 'INSERTE_SU_RSA_ID'
Culqi.rsa_key = "INSERTE_SU_LLAVE_RSA"

# Parameters or Configuration of headers optional
Culqi.headers = {
  'charges' => {
    'X-Charge-Channel' => 'recurrent',
  },
  'plans' => {
    'X-Plan-Type' => 'premium'
  },
  'allow' => {
    'X-Header-Config' => true,
  }
}
