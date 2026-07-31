# Canal Aztlán — Radio web

Radio por internet con servidor de streaming propio (Icecast) desplegado en Railway,
más una página web para que la gente escuche. Empezamos leyendo libros en voz alta.

## Cómo funciona (el mapa mental)

Son tres piezas:

1. **Tu computadora (el estudio):** un programa llamado **BUTT** toma el audio de tu
   micrófono (o de un reproductor) y lo *envía* al servidor.
2. **El servidor (Railway + Icecast):** recibe tu audio y lo *reparte* a todos los que
   estén escuchando. Vive en la nube, encendido 24/7.
3. **La página web (los oyentes):** cualquiera abre tu dominio, da play y escucha.

    [Tu voz/micrófono] → BUTT → [Icecast en Railway] → página web → oyentes

---

## PASO 1 — Subir este proyecto a GitHub

Railway despliega desde un repositorio de GitHub.

1. Crea un repositorio nuevo en https://github.com (por ejemplo `canal-aztlan`).
2. Sube TODOS los archivos de esta carpeta a ese repositorio.

Si usas la terminal:

```bash
cd canal-aztlan
git init
git add .
git commit -m "Canal Aztlán: primer despliegue"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/canal-aztlan.git
git push -u origin main
```

---

## PASO 2 — Desplegar en Railway

1. Entra a https://railway.app y crea un proyecto: **New Project → Deploy from GitHub repo**.
2. Elige tu repositorio `canal-aztlan`. Railway detectará el `Dockerfile` solo.
3. Ve a la pestaña **Variables** del servicio y agrega estas tres:

   | Variable            | Valor (ejemplo)                          | Para qué sirve                                 |
   |---------------------|------------------------------------------|------------------------------------------------|
   | `SOURCE_PASSWORD`   | *(inventa una fuerte)*                    | Contraseña con la que BUTT se conecta a enviar |
   | `ADMIN_PASSWORD`    | *(inventa otra distinta)*                 | Para entrar al panel de administración         |
   | `ICECAST_HOSTNAME`  | `canal-aztlan.up.railway.app`             | El dominio público de tu servidor              |

   > No definas `PORT`. Railway la inyecta automáticamente y ya la usamos.

4. En **Settings → Networking**, pulsa **Generate Domain**. Copia el dominio que te dé
   (algo como `canal-aztlan.up.railway.app`). Pégalo también en la variable `ICECAST_HOSTNAME`.
5. Railway reconstruye y despliega. Cuando termine, abre tu dominio en el navegador:
   deberías ver la página de Canal Aztlán.

---

## PASO 3 — Conectar el dominio propio (opcional)

Si tienes un dominio (ej. `canalaztlan.mx`):

1. En Railway: **Settings → Networking → Custom Domain**, escribe tu dominio.
2. Railway te dará un registro **CNAME**. Cópialo.
3. En el panel de tu proveedor de dominio, crea ese registro CNAME apuntando a Railway.
4. Espera a que propague (minutos a un par de horas). Railway pone el HTTPS solo.
5. Actualiza `ICECAST_HOSTNAME` con tu dominio propio y vuelve a desplegar.

---

## PASO 4 — Transmitir desde tu computadora con BUTT

**BUTT** (Broadcast Using This Tool) es gratis para Windows, Mac y Linux:
https://danielnoethen.de/butt/

1. Instálalo y ábrelo. Ve a **Settings → Main**, sección **Server → Add**.
2. Llena así:
   - **Type:** Icecast
   - **Address:** tu dominio SIN `https://` (ej. `canal-aztlan.up.railway.app`)
   - **Port:** `443` si usas el dominio con HTTPS; o el puerto que muestre Railway
   - **Password:** el `SOURCE_PASSWORD` que pusiste en Railway
   - **Icecast mount:** `/stream`
   - **Icecast user:** `source`
3. En **Settings → Audio**, elige tu micrófono como dispositivo de entrada.
4. En **Settings → Stream**, opcional: nombre "Canal Aztlán", género "Cultura".
5. Cierra Settings y pulsa **Play** (el botón de transmitir) en BUTT.
6. Abre tu página web y dale play: deberías escucharte. ¡Ya estás al aire!

> Para "leer libros": simplemente lee frente al micrófono con BUTT transmitiendo.
> Si quieres pasar música o audio pregrabado, puedes enrutar el sonido del sistema a
> BUTT (con herramientas como VB-Cable en Windows o BlackHole en Mac), pero para empezar
> con lectura en vivo, solo el micrófono basta.

---

## PASO 5 — Panel de administración

Para ver cuántas personas te escuchan en tiempo real:

- Entra a `https://TU-DOMINIO/admin/` con usuario `admin` y tu `ADMIN_PASSWORD`.

---

## Notas importantes

- **Legalidad:** transmitir por internet NO requiere concesión del IFT (solo aplica al
  espectro de radio AM/FM). Pero sí debes respetar derechos de autor: si lees libros,
  usa obras de dominio público o con permiso, y para música usa pistas con licencia.
- **Costo:** Railway cobra por uso. Un servidor de streaming pequeño con pocos oyentes
  suele caber en su plan económico, pero revisa tu consumo.
- **Oyentes simultáneos:** el `clients` en la config está en 100. Súbelo si creces, pero
  más oyentes = más ancho de banda = más costo.

---

## Archivos del proyecto

- `Dockerfile` — construye la imagen de Icecast.
- `icecast.xml.template` — configuración del servidor (se rellena con tus variables).
- `entrypoint.sh` — arranca el servidor.
- `web/index.html` — la página que ven los oyentes.
- `railway.json` — le dice a Railway cómo desplegar.
