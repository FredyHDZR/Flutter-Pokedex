# Flutter Pokédex

Aplicación Pokédex desarrollada en Flutter con soporte para iOS, Android y Web, implementando arquitectura limpia, manejo de estado reactivo, persistencia local y funcionalidad offline.

## Comandos para Ejecutar la Aplicación

### Instalación de Dependencias
```bash
flutter pub get
```

### Generación de Código
Antes de ejecutar la aplicación, es necesario generar el código de los modelos con freezed y json_serializable:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Ejecutar en iOS
```bash
flutter run -d ios
```

### Ejecutar en Android
```bash
flutter run -d android
```

### Ejecutar en Web
```bash
flutter run -d chrome
```

## Arquitectura y Escalabilidad

La aplicación implementa Clean Architecture (Arquitectura Limpia) con separación en tres capas principales: Domain, Data y Presentation. Esta arquitectura es adecuada para escalar a un producto real porque:

- **Independencia de capas**: La capa de dominio no depende de implementaciones concretas, permitiendo cambios en la fuente de datos sin afectar la lógica de negocio.
- **Testabilidad**: Cada capa puede ser testeada de forma independiente mediante mocks y stubs.
- **Mantenibilidad**: La separación de responsabilidades facilita la comprensión y modificación del código.
- **Escalabilidad**: Nuevas features pueden agregarse sin modificar código existente, siguiendo el principio Open/Closed.

Para Flutter Web, la arquitectura se mantiene idéntica, aprovechando que Flutter compila a JavaScript. La única consideración adicional es el manejo de rutas con go_router para soportar deep linking y navegación del navegador.

**Paquetes utilizados**: La arquitectura se implementa mediante la organización del código en carpetas (domain, data, ui) y el uso de interfaces abstractas en la capa de dominio.

## Trade-offs por Timebox de 1 Día

Dado el timebox de 1 día, se tomaron los siguientes trade-offs:

- **Testing limitado**: Se priorizó la funcionalidad core sobre tests exhaustivos. Los tests se enfocaron en la lógica crítica de negocio (Cubits y Repository) usando bloc_test y mocktail.
- **Optimizaciones de performance**: Se implementaron optimizaciones básicas (caché de imágenes, lazy loading) pero se dejaron optimizaciones avanzadas (compresión de imágenes, prefetching inteligente) para futuras iteraciones.
- **UI simplificada**: Se implementó una UI funcional y responsive, pero se dejaron mejoras visuales avanzadas (animaciones complejas, micro-interacciones) para mejoras futuras.
- **Manejo de errores**: Se implementó un sistema robusto de manejo de errores, pero se priorizaron mensajes genéricos sobre mensajes específicos por tipo de error.
- **Documentación**: Se documentó la arquitectura y decisiones técnicas, pero se dejó documentación detallada de cada componente para futuras iteraciones.

**Paquetes utilizados**: bloc_test y mocktail para testing, cached_network_image para optimización básica de imágenes.

## Gestión de Estado y Side-effects

El flujo de datos sigue el patrón unidireccional: UI → Cubit → Repository → DataSource → API/Cache.

**Flujo detallado**:
1. La UI (Widget) dispara una acción mediante un método del Cubit.
2. El Cubit emite un estado de carga y llama al Repository.
3. El Repository implementa la estrategia Cache-Aside: verifica conectividad con NetworkInfo, intenta obtener datos del RemoteDataSource, y en caso de fallo o sin conexión, recurre al LocalDataSource.
4. El resultado se retorna como Either<Failure, Success> usando dartz.
5. El Cubit procesa el Either y emite el estado correspondiente (Loaded o Error).
6. La UI reacciona automáticamente a los cambios de estado mediante BlocBuilder.

**Prevención de acoplamiento**:
- La capa UI no conoce implementaciones concretas de DataSource, solo interactúa con Cubits.
- Los Cubits no conocen detalles de implementación del Repository, solo la interfaz abstracta definida en Domain.
- El Repository no conoce detalles de UI, solo retorna Either con datos o errores.
- La inyección de dependencias mediante get_it permite cambiar implementaciones sin modificar código cliente.

**Paquetes utilizados**: flutter_bloc para gestión de estado (Cubit), dartz para Either (manejo funcional de errores), get_it para dependency injection, equatable para comparación de estados.

## Offline y Caché

La estrategia de persistencia implementa el patrón Cache-Aside con las siguientes características:

**Qué se guarda**:
- Lista de Pokémon: se guarda cada Pokémon individualmente usando su ID como clave en Hive.
- Detalle de Pokémon: se guarda el detalle completo de cada Pokémon consultado.
- Metadata de caché: se mantiene información sobre última actualización, versión y timestamps por ítem.

**Versionado e invalidación**:
- TTL (Time To Live): cada ítem en caché tiene un timestamp que se compara contra una duración configurable (por defecto 24 horas) usando CacheMetadata.
- Invalidación por ítem: se puede verificar si un ítem específico está expirado sin invalidar todo el caché.
- Invalidación manual: se proporciona un método clearCache para limpiar completamente el caché cuando sea necesario.

**Resolución de conflictos**:
- Prioridad a datos remotos: cuando hay conexión, siempre se intenta obtener datos de la API primero.
- Fallback a caché: si la API falla o no hay conexión, se utilizan datos del caché local.
- Actualización asíncrona: cuando se obtienen datos de la API, se guardan en caché de forma asíncrona (fire and forget) para no bloquear la respuesta al usuario.
- Sin merge: no se realiza merge entre datos remotos y locales. Si hay datos remotos disponibles, se usan; si no, se usan locales.

**Paquetes utilizados**: hive y hive_flutter para persistencia local NoSQL, path_provider para rutas de almacenamiento, connectivity_plus para detección de conectividad de red.

## Flutter Web

Para asegurar una buena experiencia en Web se tomaron las siguientes decisiones:

**Responsive Design**:
- Se implementó un sistema de breakpoints (mobile, tablet, desktop) para ajustar el layout según el ancho de pantalla.
- El GridView del listado se ajusta dinámicamente: 3 columnas en móvil, 5 columnas en pantallas grandes (web/tablet).
- Se utiliza LayoutBuilder y MediaQuery para detectar cambios de tamaño y ajustar el layout en tiempo real.

**Navegación**:
- go_router se utiliza para manejar rutas declarativas y soportar deep linking.
- Las URLs son amigables (/pokemon/:id) y permiten navegación con botones del navegador (back/forward).
- Se implementó transición fade personalizada para mejorar la experiencia de navegación.

**Performance**:
- cached_network_image se utiliza para cachear imágenes y reducir requests redundantes.
- Lazy loading mediante GridView.builder para renderizar solo los ítems visibles.
- Los modelos se serializan eficientemente usando json_serializable.

**Interacción Desktop**:
- Los widgets son interactivos tanto con touch como con mouse.
- El scroll funciona correctamente con rueda del mouse.
- Los gestos de navegación (back button) funcionan correctamente.

**Limitaciones y Mitigaciones**:
- Limitación: Flutter Web puede tener problemas de performance con listas muy grandes. Mitigación: se implementó paginación y lazy loading.
- Limitación: Las imágenes pueden tardar en cargar. Mitigación: se utiliza cached_network_image con placeholders.
- Limitación: El almacenamiento local en Web usa IndexedDB (a través de Hive). Mitigación: se validó que Hive funciona correctamente en Web.

**Paquetes utilizados**: go_router para navegación web, cached_network_image para optimización de imágenes, LayoutBuilder y MediaQuery (nativos de Flutter) para responsive design.

## Calidad de Código

Se aplicaron las siguientes decisiones de código limpio:

**1. Separación de Responsabilidades (SRP)**:
Cada clase tiene una única responsabilidad. Por ejemplo, PokemonRepositoryImpl solo se encarga de orquestar la obtención de datos entre RemoteDataSource y LocalDataSource, sin conocer detalles de implementación. Los DataSources se encargan únicamente de obtener datos de su fuente específica.

**2. Nombres Descriptivos**:
Se utilizan nombres que expresan claramente la intención del código. Por ejemplo, `getCachedPokemonList` indica que obtiene una lista de Pokémon desde caché, `extractIdFromUrl` indica que extrae un ID de una URL. Esto elimina la necesidad de comentarios explicativos redundantes.

**3. Inmutabilidad**:
Los modelos de dominio utilizan freezed para garantizar inmutabilidad. Esto previene bugs por mutaciones accidentales y facilita el razonamiento sobre el estado de la aplicación. Los estados de los Cubits también son inmutables usando freezed y equatable.

**Paquetes utilizados**: freezed para inmutabilidad y generación de código, equatable para comparación de objetos, json_serializable para serialización.
