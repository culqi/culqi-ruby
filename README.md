# culqi-ruby

[![Gem Version](https://badge.fury.io/rb/culqi-ruby.svg)](https://badge.fury.io/rb/culqi-ruby)

Biblioteca de CULQI para el lenguaje Ruby, pagos simples en tu sitio web. Consume el Culqi API.

| Versión actual|Culqi API|
|----|----|
| [0.0.4](https://rubygems.org/gems/culqi-ruby) (2017-02-13) |[v2](https://beta.culqi.com)|

## Requisitos

- Ruby >= 2.0.0
- Credenciales de comercio en Culqi (1).


## Ejemplos

### Inicialización

```ruby

require 'securerandom'
require 'culqi-ruby'

Culqi.public_key = 'pk_test_vzMuTHoueOMlgUPj'
Culqi.secret_key = 'sk_test_UTCQSGcXW8bCyU59'

```

### Crear Token

```ruby

token = Culqi::Token.create(
    :card_number => '4111111111111111',
    :cvv => '123',
    :currency_code => 'PEN',
    :email => 'test@culqi.com',
    :expiration_month => 9,
    :expiration_year => 2020
)

jsonToken = JSON.parse(token)

puts jsonToken["id"]

```

### Crear Cargo

```ruby

charge = Culqi::Charge.create(
    :amount => 1000,
    :capture => true,
    :currency_code => "PEN",
    :description => "Venta de prueba",
    :email => 'wmuro@me.com',
    :installments => 0,
    :metadata => ({
        :test => 'test123'
    }),
    :source_id => jsonToken["id"]
)

jsonCharge = JSON.parse(charge)

```

### Crear Plan

```ruby

plan = Culqi::Plan.create(
    :amount => 1000,
    :currency_code => 'PEN',
    :interval => 'dias',
    :interval_count => 2,
    :limit => 10,
    :metadata => ({
    :alias => 'plan_test'
    }),
    :name => 'plan-test-'+SecureRandom.uuid,
    :trial_days => 50
)

jsonPlan = JSON.parse(plan)

```

### Crear Costumer

```ruby
customer = Culqi::Customer.create(
    :address => 'Avenida Lima 123213',
    :address_city => 'LIMA',
    :country_code => 'PE',
    :email => 'test'+SecureRandom.uuid+'@culqi.com',
    :first_name => 'William',
    :last_name => 'Muro',
    :metadata => ({
      :other_number => '789953655'
    }),
    :phone_number => 998989789
)

jsonCustomer = JSON.parse(customer)

```

### Crear Card

```ruby
card = Culqi::Card.create(
  :customer_id => jsonCustomer["id"],
  :token_id => jsonToken["id"]
)

jsonCard = JSON.parse(card)

```

### Crear Suscripción

```ruby

subscription = Culqi::Subscription.create(
  :card_id => jsonCard["id"],
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
gem push culqi-ruby-{VERSION}.gem
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
