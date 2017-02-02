# culqi-ruby

[![Gem Version](https://badge.fury.io/rb/culqi-ruby.svg)](https://badge.fury.io/rb/culqi-ruby)

Biblioteca de CULQI para el lenguaje Ruby, pagos simples en tu sitio web. Consume el Culqi API.

| Versión actual|Culqi API|
|----|----|
| [0.0.3](https://rubygems.org/gems/culqi-ruby) (2017-01-20) |[v2](https://beta.culqi.com)|

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
  :cvv => "123",
  :email => "will@culqi.com",
  :expiration_month => 9,
  :expiration_year => 2020,
  :fingerprint => "fffqweqwq"
)

jsonToken = JSON.parse(token)

puts jsonToken["id"]

```

### Crear Cargo

```ruby

charge = Culqi::Charge.create(
  :amount => 1000,
  :antifraud_details => {
    :address => "Avenida Lima 1232",
    :address_city => "LIMA",
    :country_code => "PE",
    :email => "will@culqi.com",
    :first_name => "Will",
    :last_name => "Aguirre",
    :phone_number => 3333339,
  }
  :capture => true,
  :currency_code => "PEN",
  :description => "Venta de prueba",
  :installments => 0,
  :metadata => "",
  :source_id => jsonToken["id"]
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
  :card_id => "{card_id}",
  :plan_id => jsonPlan["id"]
)

jsonSubscription = JSON.parse(subscription)

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
