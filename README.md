# culqi-ruby
Biblioteca de Culqi en Ruby

## Ejemplos

### Inicialización

```ruby
require 'culqi-ruby'
```

### Crear Token

```ruby
Culqi.code_commerce = 'pk_test_vzMuTHoueOMlgUPj'

token = Culqi::Token.create(
  :card_number => "4111111111111111",
  :currency_code => "PEN",
  :cvv => "123",
  :expiration_month => 9,
  :expiration_year => 2020,
  :last_name => "will",
  :email => "will@culqi.com",
  :first_name => "Aguirre"
)

data = JSON.parse(token)

puts data["id"]

```
