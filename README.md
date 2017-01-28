# culqi-ruby

[![Gem Version](https://badge.fury.io/rb/culqi-ruby.svg)](https://badge.fury.io/rb/culqi-ruby)

Biblioteca de CULQI para el lenguaje Ruby, pagos simples en tu sitio web. Consume el Culqi API.

| Versión actual|Culqi API|
|----|----|
| [0.0.2](https://rubygems.org/gems/culqi-ruby) (2017-01-20) |[v2](https://beta.culqi.com)|

## Requisitos

- Ruby >= 2.0.0
- Credenciales de comercio en Culqi (1).


## Ejemplos

### Inicialización

```ruby

require 'securerandom'
require 'culqi-ruby'

Culqi.code_commerce = 'pk_test_vzMuTHoueOMlgUPj'
Culqi.api_key = 'sk_test_UTCQSGcXW8bCyU59'

```

### Crear Token

```ruby

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

jsonToken = JSON.parse(token)

puts jsonToken["id"]

```

### Crear Cargo

```ruby

charge = Culqi::Charge.create(
  :address => "Avenida Lima 1232",
  :address_city => "LIMA",
  :amount => 1000,
  :country_code => "PE",
  :currency_code => "PEN",
  :email => "will@culqi.com",
  :first_name => "Will",
  :installments => 0,
  :last_name => "Aguirre",
  :metadata => "",
  :phone_number => 3333339,
  :product_description => "Venta de prueba",
  :token_id => jsonToken["id"]
)

jsonCharge = JSON.parse(charge)

```

### Crear Plan

```ruby

plan = Culqi::Plan.create(
  :alias => "plan-test-"+SecureRandom.uuid,
  :amount => 1000,
  :currency_code => "PEN",
  :interval => "day",
  :interval_count => 2,
  :limit => 10,
  :name => "Plan de Prueba "+SecureRandom.uuid,
  :trial_days => 50
)

jsonPlan = JSON.parse(plan)

```

### Crear Suscripción

```ruby

subscription = Culqi::Subscription.create(
  :address => "Avenida Lima 123213",
  :address_city => "LIMA",
  :country_code => "PE",
  :email => "wmuro@me.com",
  :last_name => "Muro",
  :first_name => "William",
  :phone_number => 1234567789,
  :plan_alias => jsonPlan["alias"],
  :token_id => jsonToken["id"]
)

jsonSubscription = JSON.parse(plan)

```

### Crear Reembolso

```ruby

refund = Culqi::Refund.create(
  :amount => 500,
  :charge_id => jsonCharge["id"],
  :reason => "bought an incorrect product"
)

jsonRefund = JSON.parse(refund)

```

## Build

```bash
gem build culqi-ruby.gemspec
gem install ./culqi-ruby-{VERSION}.gem
```


## Changelog

Todos los cambios en las versiones de esta biblioteca están listados en [CHANGELOG](CHANGELOG).

## Testing

Solo debe ejecutar el siguiente comando

```ruby
rake test
```

## Autor

Willy Aguirre ([@marti1125](https://github.com/marti1125) - Team Culqi)

## Licencia

El código fuente de culqi-python está distribuido bajo MIT License, revisar el archivo [LICENSE](https://github.com/culqi/culqi-ruby/blob/master/LICENSE).
