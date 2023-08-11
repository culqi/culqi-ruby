# Culqi-Ruby

[![Gem Version](https://badge.fury.io/rb/culqi-ruby.svg)](https://badge.fury.io/rb/culqi-ruby)

Nuestra Biblioteca Culqi-Ruby oficial, es compatible con la v2.0 del Culqi API, con el cual tendrás la posibilidad de realizar cobros con tarjetas de débito y crédito, Yape, PagoEfectivo, billeteras móviles y Cuotéalo con solo unos simples pasos de configuración.


| Versión actual|Culqi API|
|----|----|
| [0.2.0](https://rubygems.org/gems/culqi-ruby) (2023-08-11) |[v2](https://culqi.com/api)|

## Requisitos

- Ruby >= 3.0.0
- Afiliate [aquí](https://afiliate.culqi.com/).
- Si vas a realizar pruebas obtén tus llaves desde [aquí](https://integ-panel.culqi.com/#/registro), si vas a realizar transacciones reales obtén tus llaves desde [aquí](https://mipanel.culqi.com/#/registro).

> Recuerda que para obtener tus llaves debes ingresar a tu CulqiPanel > Desarrollo > ***API Keys***.

![alt tag](http://i.imgur.com/NhE6mS9.png)

> Recuerda que las credenciales son enviadas al correo que registraste en el proceso de afiliación.

## Instalar Dependecies

```bash
gem install bundler
bundle install
```

## Build

```bash
gem build culqi-ruby.gemspec
gem install ./culqi-ruby-{VERSION}.gem
gem push culqi-ruby-{VERSION}.gem
```

## Testing

Solo debe ejecutar el siguiente comando

```ruby
rake test test_culqi-create.rb
```

Si queremos ejecutar un especifico test método

```ruby
rake test TEST=test/test_culqi-create.rb
rake test TEST=test/test_culqi-create.rb TESTOPTS="--name=test_create_token -v"
```

## Ejemplos

### Inicialización

```ruby

require 'securerandom'
require 'culqi-ruby'

Culqi.public_key = '{LLAVE_PUBLICA}'
Culqi.secret_key = '{LLAVE_SECRETA}'

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

puts jsonToken['id']

```

### Crear Cargo

```ruby

charge = Culqi::Charge.create(
    :amount => 1000,
    :capture => true,
    :currency_code => 'PEN',
    :description => 'Venta de prueba',
    :email => 'wmuro@me.com',
    :installments => 0,
    :metadata => ({
        :test => 'test123'
    }),
    :source_id => jsonToken['id']
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

### Actualizar Costumer

```ruby
updatecustomer = Culqi::Customer.update('cus_test_F5voBd1yHsCkjSwF',
      :address => 'Av. Lima 123',
      :first_name => 'Will')
```

### Obtener Costumer

```ruby
getcustomer = Culqi::Customer.get('cus_test_F5voBd1yHsCkjSwF')
```

### Crear Card

```ruby
card = Culqi::Card.create(
  :customer_id => jsonCustomer['id'],
  :token_id => jsonToken['id']
)

jsonCard = JSON.parse(card)

```

### Crear Suscripción

```ruby

subscription = Culqi::Subscription.create(
  :card_id => jsonCard['id'],
  :plan_id => jsonPlan['id']
)

jsonSubscription = JSON.parse(subscription)

```

### Crear Reembolso

```ruby

refund = Culqi::Refund.create(
  :amount => 500,
  :charge_id => jsonCharge['id'],
  :reason => 'solicitud_comprador'
)

jsonRefund = JSON.parse(refund)

```

## Documentación
¿Necesitas más información para integrar `culqi-ruby`? La documentación completa se encuentra en [https://culqi.com/docs/](https://culqi.com/docs/)

## Changelog

Todos los cambios en las versiones de esta biblioteca están listados en [CHANGELOG](CHANGELOG).


## Autor

Team Culqi

## Licencia

El código fuente de culqi-ruby está distribuido bajo MIT License, revisar el archivo [LICENSE](https://github.com/culqi/culqi-ruby/blob/master/LICENSE).
