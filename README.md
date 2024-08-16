# Culqi-Ruby

[![Gem Version](https://badge.fury.io/rb/culqi-ruby.svg)](https://badge.fury.io/rb/culqi-ruby)

Nuestra Biblioteca Culqi-Ruby oficial, es compatible con la v2.0 del Culqi API, con el cual tendrás la posibilidad de realizar cobros con tarjetas de débito y crédito, Yape, PagoEfectivo, billeteras móviles y Cuotéalo con solo unos simples pasos de configuración.

Nuestra biblioteca te da la posibilidad de capturar el `status_code` de la solicitud HTTP que se realiza al API de Culqi, así como el `response` que contiene el cuerpo de la respuesta obtenida.

| Versión actual|Culqi API|
|----|----|
| [1.0.0](https://rubygems.org/gems/culqi-ruby) (2023-08-11) |[v2](https://culqi.com/api)|


## Requisitos

- Ruby 3.0.0+
- Afiliate [aquí](https://afiliate.culqi.com/).
- Si vas a realizar pruebas obtén tus llaves desde [aquí](https://integ-panel.culqi.com/#/registro), si vas a realizar transacciones reales obtén tus llaves desde [aquí](https://mipanel.culqi.com/#/registro).

> Recuerda que para obtener tus llaves debes ingresar a tu CulqiPanel > Desarrollo > ***API Keys***.

![alt tag](http://i.imgur.com/NhE6mS9.png)

> Recuerda que las credenciales son enviadas al correo que registraste en el proceso de afiliación.

* Para encriptar el payload debes generar un id y llave RSA  ingresando a CulqiPanel > Desarrollo  > RSA Keys.

## Instalar Dependencias

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

## Configuracion

Para empezar a enviar peticiones al API de Culqi debes configurar tu llave pública (pk), llave privada (sk).
Para habilitar encriptación de payload debes configurar tu rsa_id y rsa_public_key.

```ruby

require 'minitest/autorun'
require 'culqi-ruby'

Culqi.public_key = 'pk_test_e94078b9b248675d'
Culqi.secret_key = 'sk_test_c2267b5b262745f0'
Culqi.rsa_id = 'de35e120-e297-4b96-97ef-10a43423ddec'
Culqi.rsa_key = "-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDswQycch0x/7GZ0oFojkWCYv+g
r5CyfBKXc3Izq+btIEMCrkDrIsz4Lnl5E3FSD7/htFn1oE84SaDKl5DgbNoev3pM
C7MDDgdCFrHODOp7aXwjG8NaiCbiymyBglXyEN28hLvgHpvZmAn6KFo0lMGuKnz8
HiuTfpBl6HpD6+02SQIDAQAB
-----END PUBLIC KEY-----"
```

### Encriptar payload

Para encriptar el payload necesitas agregar el siguiente codigo en caso de token.

Ejemplo

```ruby
token_string =  CulqiCRUD.createTokenEncrypt
token_json = JSON.parse(JSON.generate(token_string[0]))
id_value = token_json['object']
assert_equal 'token', id_value
```

## Servicios

### Crear Token

Antes de crear un Cargo o Card es necesario crear un `token` de tarjeta. 
Lo recomendable es generar los 'tokens' con [Culqi Checkout v4](https://docs.culqi.com/es/documentacion/checkout/v4/culqi-checkout/) o [Culqi JS v4](https://docs.culqi.com/es/documentacion/culqi-js/v4/culqi-js/) **debido a que es muy importante que los datos de tarjeta sean enviados desde el dispositivo de tus clientes directamente a los servidores de Culqi**, para no poner en riesgo los datos sensibles de la tarjeta de crédito/débito.

> Recuerda que cuando interactúas directamente con el [API Token](https://apidocs.culqi.com/#tag/Tokens/operation/crear-token) necesitas cumplir la normativa de PCI DSS 3.2. Por ello, te pedimos que llenes el [formulario SAQ-D](https://listings.pcisecuritystandards.org/documents/SAQ_D_v3_Merchant.pdf) y lo envíes al buzón de riesgos Culqi.

```ruby
params ={
      :card_number => '4111111111111111',
      :cvv => '111',
      :currency_code => 'PEN',
      :email => 'test1231@culqi.com',
      :expiration_month => 9,
      :expiration_year => 2025
    }
token, statusCode = Culqi::Token.create(params,  rsa_key, rsa_id)

jsonToken = JSON.parse(token)

puts jsonToken['id']
```

### Crear Cargo

Crear un cargo significa cobrar una venta a una tarjeta. Para esto previamente deberías generar el  `token` y enviarlo en parámetro **source_id**.

Los cargos pueden ser creados vía [API de cargo](https://apidocs.culqi.com/#tag/Cargos/operation/crear-cargo).

```ruby
params = {
      :amount => 1000,
      :capture => false,
      :currency_code => 'PEN',
      :description => 'Venta de prueba',
      :email => 'test'+SecureRandom.uuid+'@culqi.com',
      :installments => 0,
      :metadata => ({
        :test => 'test123'
      }),
      :source_id => token_json['id']
    }
charge, statusCode = Culqi::Charge.create(params)

jsonCharge = JSON.parse(charge)
```

### Crear Cargo con Configuración Adicional

**¿Cómo funciona la configuración adicional?**

Puedes agregar campos configurables en la sección **custom_headers** para personalizar las solicitudes de cobro. Es importante tener en cuenta que no se permiten campos con valores **false**, **null**, o cadenas vacías (**''**).

**Explicación:**
- **params**: Contiene la información necesaria para crear el cargo, como el monto, la moneda, y el correo del cliente.
- **custom_headers**: Define los encabezados personalizados para la solicitud. Recuerda que solo se permiten valores válidos.
- **Filtrado de encabezados**: Antes de realizar la solicitud, se eliminan los encabezados con valores no permitidos (**false, null, o vacíos**) para garantizar que la solicitud sea aceptada por la API.

**¿Quieres realizar cobros a una lista de comercios en un tiempo y monto determinado?**

Para realizar un cobro recurrente, puedes utilizar el siguiente código (**Configuración Adicional -> custom_headers**):

```ruby
params = {
  :amount => 1000,
  :capture => false,
  :currency_code => 'PEN',
  :description => 'Venta de prueba',
  :email => 'test'+SecureRandom.uuid+'@culqi.com',
  :installments => 0,
  :metadata => ({
    :test => 'test123'
  }),
  :source_id => token_json['id']
}

custom_headers  = {
  'X-Charge-Channel' => 'recurrent',
}

charge, statusCode = Culqi::Charge.create(params, '', '', custom_headers)

jsonCharge = JSON.parse(charge)
```

### Crear Devolución

Solicita la devolución de las compras de tus clientes (parcial o total) de forma gratuita a través del API y CulqiPanel. 

Las devoluciones pueden ser creados vía [API de devolución](https://apidocs.culqi.com/#tag/Devoluciones/operation/crear-devolucion).

```ruby
refund, statusCode = Culqi::Refund.create(
  :amount => 500,
  :charge_id => jsonCharge['id'],
  :reason => 'solicitud_comprador'
)

jsonRefund = JSON.parse(refund)
```

### Crear Cliente

El **cliente** es un servicio que te permite guardar la información de tus clientes. Es un paso necesario para generar una [tarjeta](/es/documentacion/pagos-online/recurrencia/one-click/tarjetas).

Los clientes pueden ser creados vía [API de cliente](https://apidocs.culqi.com/#tag/Clientes/operation/crear-cliente).

```ruby
params = {
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
    }
customer, statusCode = Culqi::Customer.create(params)

jsonCustomer = JSON.parse(customer)
```

### Actualizar Cliente

```ruby
updatecustomer, statusCode = Culqi::Customer.update('cus_test_F5voBd1yHsCkjSwF',
      :address => 'Av. Lima 123',
      :first_name => 'Will')
```

### Obtener Cliente

```ruby
getcustomer = Culqi::Customer.get('cus_test_F5voBd1yHsCkjSwF')
```

### Crear Card

La **tarjeta** es un servicio que te permite guardar la información de las tarjetas de crédito o débito de tus clientes para luego realizarles cargos one click o recurrentes (cargos posteriores sin que tus clientes vuelvan a ingresar los datos de su tarjeta).

Las tarjetas pueden ser creadas vía [API de tarjeta](https://apidocs.culqi.com/#tag/Tarjetas/operation/crear-tarjeta).

```ruby
card, statusCode = Culqi::Card.create(
  :customer_id => jsonCustomer['id'],
  :token_id => jsonToken['id']
)

jsonCard = JSON.parse(card)
```

### Crear Plan

El plan es un servicio que te permite definir con qué frecuencia deseas realizar cobros a tus clientes.

Un plan define el comportamiento de las suscripciones. Los planes pueden ser creados vía el [API de Plan](https://apidocs.culqi.com/#/planes#create) o desde el **CulqiPanel**.

```ruby
params = {
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
    }

plan, statusCode = Culqi::Plan.create(params)

jsonPlan = JSON.parse(plan)
```

### Crear Suscripción

La suscripción es un servicio que asocia la tarjeta de un cliente con un plan establecido por el comercio.

Las suscripciones pueden ser creadas vía [API de suscripción](https://apidocs.culqi.com/#tag/Suscripciones/operation/crear-suscripcion).

```ruby
subscription, statusCode = Culqi::Subscription.create(
  :card_id => jsonCard['id'],
  :plan_id => jsonPlan['id']
)

jsonSubscription = JSON.parse(subscription)
```

### Crear Orden

Es un servicio que te permite generar una orden de pago para una compra potencial.
La orden contiene la información necesaria para la venta y es usado por el sistema de **PagoEfectivo** para realizar los pagos diferidos.

Las órdenes pueden ser creadas vía [API de orden](https://apidocs.culqi.com/#tag/Ordenes/operation/crear-orden).

```ruby
params = {
  :amount => 10000,
  :currency_code => 'PEN',
  :description => 'Venta de prueba',
  :order_number => 'pedido-ruby-'+SecureRandom.random_number(50).to_s,
  :client_details => ({
    :first_name => 'Richard',
    :last_name => 'Hendricks',
    :email => 'richar3d@piedpiper.com',
    :phone_number => '+51945145280'
  }),
  :expiration_date => (Time.now + (2*7*24*60*60)).to_i,
  :confirm => false
}
order, statusCode = Culqi::Orden.create(params)

jsonSubscription = JSON.parse(order)
```


## Pruebas

En la carpeta **/test** encontraras ejemplos para crear un token, charge, plan, órdenes, card, suscripciones, etc.

> Recuerda que si quieres probar tu integración, puedes utilizar nuestras [tarjetas de prueba.](https://docs.culqi.com/es/documentacion/pagos-online/tarjetas-de-prueba/)

Solo debe ejecutar el siguiente comando

```ruby
rake test test_culqi-create.rb
```

Si queremos ejecutar un especifico test método

```ruby
rake test TEST=test/test_culqi-create.rb
rake test TEST=test/test_culqi-create.rb TESTOPTS="--name=test_create_token -v"
```


### Ejemplo Prueba Token

```ruby
token_string =  CulqiCRUD.createToken
token_json = JSON.parse(JSON.generate(token_string[0]))
id_value = token_json['object']
assert_equal 'token', id_value
```

### Ejemplo Prueba Cargo

```ruby
charge_string =  CulqiCRUD.createCharge
charge_json = JSON.parse(JSON.generate(charge_string[0]))
id_value = charge_json['object']
assert_equal 'charge',id_value
```

## Documentación

- [Referencia de Documentación](https://docs.culqi.com/)
- [Referencia de API](https://apidocs.culqi.com/)
- [Demo Checkout V4 + Culqi 3DS](https://github.com/culqi/culqi-ruby-demo-checkoutv4-culqi3ds)
- [Wiki](https://github.com/culqi/culqi-ruby/wiki)


## Changelog

Todos los cambios en las versiones de esta biblioteca están listados en [CHANGELOG](CHANGELOG).

## Autor
Team Culqi

## Licencia
El código fuente de culqi-net está distribuido bajo MIT License, revisar el archivo LICENSE.
