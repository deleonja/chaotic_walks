1. # 🚀 Guía de introducción: Creación de paquetes en Wolfram Language (.wl)

   Esta guía te ayudará a aprender a **cómo crear tu primer paquete de Wolfram**.

   ---

   ## 1. El cambio de mentalidad: programación modular

   La **programación modular** consiste en dividir un problema complejo en piezas pequeñas, independientes y reutilizables (módulos). 

   En lugar de ver tu código como una receta lineal que solo funciona en un notebook específico, piensa en él como una **caja de herramientas**. 
   * El **Paquete (.wl)** es tu caja de herramientas (donde guardas el martillo y el destornillador).
   * El **Notebook (.nb)** es tu mesa de trabajo (donde usas las herramientas para armar un mueble específico).

   ### ¿Cuándo debo crear una función?
   No todo el código debe ser una función. Sigue estas reglas:
   * **Regla del tres:** Si copias y pegas el mismo bloque de código más de dos veces, conviértelo en una función.
   * **Complejidad:** Si un cálculo tiene más de 3 o 4 pasos lógicos, encapsularlo en una función ayuda a que el cuerpo principal de tu notebook sea legible.
   * **Autonomía:** Una buena función debe ser una "caja negra": le das una entrada, te da una salida, y no depende de variables globales que definiste "arriba" en el notebook.

   ---

   ## 2. ¿Qué pertenece al paquete y qué al notebook?

   Decidir qué funciones "suben" al paquete es vital para mantener el orden. Usa estos criterios:

   | ¿Va al Paquete? | Criterio de Decisión                                         |
   | :-------------- | :----------------------------------------------------------- |
   | **SÍ**          | Es una herramienta **general** (ej. una función para calcular la entropía de un estado cuántico). |
   | **SÍ**          | Es un cálculo que usarás en **varios notebooks**.            |
   | **SÍ**          | Es un proceso complejo que requiere muchas líneas de código y "ensucia" el notebook. |
   | **NO**          | Es algo **específico** de un gráfico (ej. el color o las etiquetas de una sola figura). |
   | **NO**          | Es un análisis preliminar o una prueba rápida que probablemente no repitas. |
   | **NO**          | Es la carga de datos específicos de un experimento que solo tienes tú. |

   **Pregunta clave:** *"¿Si mañana empiezo un notebook nuevo desde cero, esta función me serviría?"* Si la respuesta es sí, va al paquete.

   ---

   ## 3. Estructura Básica de un Archivo `.wl`

   Un paquete es un archivo de texto plano con extensión `.wl`. Debe seguir esta jerarquía:

   ```mathematica
   BeginPackage["NombreDelPaquete`"]
   
   (* 1. Declaración de Funciones Públicas *)
   MiFuncion::usage = "MiFuncion[x] devuelve el objeto y a partir del objeto x.";
   
   Begin["`Private`"] 
   
   (* 2. Implementación (La "Cocina") *)
   MiFuncion[x_] := x^2 + ConstanteInterna;
   ConstanteInterna = 42; 
   
   End[] 
   EndPackage[]
   ```

## 4. Estándar de documentación (`::usage`)

Para que el sistema de ayuda de Mathematica funcione correctamente (usando `?NombreDeFuncion`), debes seguir el formato estándar de la industria:

### La regla de oro

El mensaje de uso debe empezar siempre con el nombre de la función y sus argumentos, seguido de una descripción breve en tercera persona.

- **Formato Simple:** `Funcion[x, y] devuelve el resultado de operar x con y.`
- **Múltiples Usos:** Si la función acepta diferentes tipos de entrada, usa `\n` para separar líneas: `Funcion[x] realiza la operación sobre x.\nFuncion[x, y] utiliza y como parámetro de control.`

### Buenas Prácticas de Formato:

1. **CamelCase:** Usa nombres como `CalcularEspectro` en lugar de `calcular_espectro` (estándar de Wolfram).
2. **Consistencia:** Si usas `x` en la definición `f[x_]`, usa `x` en el mensaje de `::usage`.

## 5. Instalación del paquete para cargar con ```Needs["MiPaquete`"]``` desde cualquier notebook

Sólo deberás hacer esto cuando crees un nuevo paquete.

1. **Encuentra la ruta donde Wolfram guarda los paquetes en tu máquina:** Ejecuta `FileNameJoin[{$UserBaseDirectory, "Applications"}]` en Mathematica.
2. Guarda ahí tu archivo `.wl` del paquete.
3. **Listo.** Ahora puedes cargar el paquete ejecutando ```Needs["MiPaquete`"]``` desde cualquier notebook. 

**Si editas el paquete (ej. agregas una nueva función)**, usa `Get["Carpeta`Paquete`"]` para recargar las definiciones sin reiniciar el kernel.

------

## 6. Buenas Prácticas

- **Documentación (`::usage`):** Es obligatoria. Si una función no tiene ayuda, no existe.
- **Modularidad:** Mantén las funciones pequeñas. Es mejor tener 5 funciones simples que se conectan entre sí, que una función gigante que hace todo y es imposible de debugear.