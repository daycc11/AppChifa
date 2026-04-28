# 🌐 Uso de Ngrok para conectar API (.NET) con iOS (Xcode)

Este documento explica cómo exponer una API local desarrollada en .NET utilizando Ngrok y consumirla desde una aplicación iOS en Xcode.

---

## 🔑 1. Configurar Auth Token de Ngrok

1. Crear cuenta en: https://dashboard.ngrok.com/signup
2. Obtener tu token en: https://dashboard.ngrok.com/get-started/your-authtoken
3. Descargar y ejecutar Ngrok
4. Ejecutar en terminal:

```bash
ngrok config add-authtoken TU_TOKEN
```

---

## 🚀 2. Ejecutar la API en .NET

Ejecuta tu proyecto:

```bash
dotnet run
```

Ejemplo de salida:

```
http://localhost:5012
```

---

## 🌐 3. Exponer la API con Ngrok

En otra terminal, ejecuta:

```bash
ngrok http 5012
```

Ngrok generará una URL pública como:

```
https://xxxx.ngrok-free.dev
```

⚠️ Nota: La URL cambia cada vez que reinicias Ngrok (versión gratuita).

---

## 🔗 4. Probar la URL de Ngrok

Abrir en navegador:

```
https://xxxx.ngrok-free.dev/api
```

O un endpoint específico:

```
https://xxxx.ngrok-free.dev/api/productos
```

* 👉 Si responde → todo correcto
* 👉 Si no → revisar API o rutas

---

## 📱 5. Configurar en Xcode (iOS)

En el archivo `APIService.swift`, define:

```swift
private let baseURL = "https://xxxx.ngrok-free.dev/api"
```

---

## 🔐 6. Permitir conexiones en iOS (si falla)

En el archivo `Info.plist`, agregar:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## ▶️ 7. Ejecutar la aplicación

* Ejecutar en simulador o dispositivo físico
* Probar consumo de la API

---

## ⚠️ Problemas comunes

### ❌ Error de conexión

* Verificar que la API esté corriendo
* Verificar que Ngrok esté activo
* Revisar que la URL sea correcta

### ❌ URL de Ngrok cambió

* Ngrok genera una nueva URL cada vez que se reinicia
* Actualizar `baseURL` en Xcode

### ❌ API no responde

* Revisar rutas (`/api/...`)
* Verificar controladores en .NET

---

## 💡 Recomendaciones

* No usar Ngrok en producción
* Centralizar la configuración del `baseURL`
* Considerar usar dominio fijo (Ngrok de pago)
* Mantener buenas prácticas de seguridad

---

<!-- Sección opcional futura:
## 🔐 Autenticación con JWT
Aquí puedes documentar login, token y headers Authorization
-->
# AppChifa
