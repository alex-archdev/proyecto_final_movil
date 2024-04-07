# proyecto-final-movil
Aplicativo movil para el proyecto final de la maestria

Este aplicativo se encuentra escrito en flutter

## internacionalization 
cada vez que se haga una actualización de algún archivo de traduccion que se encuentra en lib/src/l10n se debe lanzar el comando
```
flutter gen-l10n
```
fuente: https://lokalise.com/blog/flutter-i18n/

## ejecucion del proyecto
para que el proyecto se conecte con el backend se debe configurar en el archivo lib/.env los valores necesarios, una vez se tenga esta información lo siguiente es:


para pruebas locales:
```
flutter run --dart-define-from-file="lib/.env" 
```

para generar el build:
```
flutter build --dart-define-from-file="lib/.env" 
```