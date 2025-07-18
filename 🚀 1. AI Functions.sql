-- Databricks notebook source
-- MAGIC %md <img src="https://github.com/mousastech/iafunciones/blob/a29291ca12bdaace778eb9dc8b70ee301cd9bf7e/img/headertools_aifunctions.png?raw=true" width=100%>
-- MAGIC
-- MAGIC # Análisis de sentimiento, extracción de entidades y generación de texto.
-- MAGIC
-- MAGIC Capacitación práctica en la plataforma Databricks con enfoque en funcionalidades de IA generativa.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Objetivos del ejercicio
-- MAGIC
-- MAGIC El objetivo de este laboratorio es implementar el siguiente caso de uso:
-- MAGIC
-- MAGIC ### Aumentar la satisfacción del cliente con el análisis automático de reseñas
-- MAGIC
-- MAGIC En este laboratorio, crearemos un canal de datos que toma las opiniones de los clientes, en formato de texto libre, y las enriquece con información extraída haciendo preguntas en lenguaje natural a los modelos de IA generativa disponibles en Databricks. También brindaremos recomendaciones para las siguientes mejores acciones a nuestro equipo de servicio al cliente, es decir, si un cliente requiere seguimiento y un borrador de mensaje de respuesta.
-- MAGIC
-- MAGIC Para cada evaluación, nosotros:
-- MAGIC
-- MAGIC - Identificamos el sentimiento del cliente y extraemos los productos mencionados.
-- MAGIC - Generamos una respuesta personalizada para el cliente
-- MAGIC
-- MAGIC <img src="https://raw.githubusercontent.com/databricks-demos/dbdemos-resources/main/images/product/sql-ai-functions/sql-ai-query-function-review.png" width="100%">

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Preparación
-- MAGIC
-- MAGIC Para realizar los ejercicios, necesitamos prender un Clúster.
-- MAGIC
-- MAGIC Simplemente siga los pasos a continuación:
-- MAGIC 1. En la esquina superior derecha, haga clic en **Conectar**
-- MAGIC 2. Seleccione el tipo de Clúster **SQL Serverless Warehouse** o **Serverless**.

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC
-- MAGIC ## Conjunto de datos de ejemplo
-- MAGIC
-- MAGIC Ahora, accedamos a las reseñas de productos que subimos en la práctica de laboratorio anterior.
-- MAGIC
-- MAGIC En esta práctica de laboratorio usaremos dos tablas:
-- MAGIC - **Resenas**: datos no estructurados con el contenido de las evaluaciones
-- MAGIC - **Clientes**: datos estructurados como registro de clientes y consumo.
-- MAGIC
-- MAGIC ¡Ahora visualicemos estos datos!

-- COMMAND ----------

-- MAGIC %md ### A. Preparación de datos
-- MAGIC
-- MAGIC 1. Crear o utilizar el catalogo `agents_ia`
-- MAGIC 2. Crear o utilizar el schema `atencion`
-- MAGIC 3. Crear el volumen `archivos`
-- MAGIC 4. Importar los archivos de la carpeta `data` para el Volumen creado

-- COMMAND ----------

USE agents_ia.atencion

-- COMMAND ----------

-- MAGIC %md ### B. Ver la tabla de Reseñas

-- COMMAND ----------

SELECT * FROM resenas

-- COMMAND ----------

-- MAGIC %md ### C. Ver la tabla de clientes

-- COMMAND ----------

SELECT * FROM clientes

-- COMMAND ----------

-- MAGIC %md ## A. Analizar el sentimiento y extraer información.
-- MAGIC
-- MAGIC Nuestro objetivo es permitir un análisis rápido de grandes volúmenes de reseñas de forma rápida y eficiente. Para hacer esto, necesitamos extraer la siguiente información:
-- MAGIC
-- MAGIC - Productos mencionados
-- MAGIC - Sentimiento del cliente
-- MAGIC - En caso negativo, ¿cuál es el motivo de la insatisfacción?
-- MAGIC
-- MAGIC Veamos cómo podemos aplicar la IA generativa para acelerar nuestro trabajo.
-- MAGIC
-- MAGIC | Gen AI SQL Function | Descrição |
-- MAGIC | -- | -- |
-- MAGIC | [ai_analyze_sentiment](https://docs.databricks.com/pt/sql/language-manual/functions/ai_analyze_sentiment.html) | Análisis de sentimiento |
-- MAGIC | [ai_classify](https://docs.databricks.com/pt/sql/language-manual/functions/ai_classify.html) | Clasifica el texto según categorías definidas. |
-- MAGIC | [ai_extract](https://docs.databricks.com/pt/sql/language-manual/functions/ai_extract.html) | Extraiga las entidades deseadas |
-- MAGIC | [ai_fix_grammar](https://docs.databricks.com/pt/sql/language-manual/functions/ai_fix_grammar.html) | Corrige a gramática do texto fornecido |
-- MAGIC | [ai_gen](https://docs.databricks.com/pt/sql/language-manual/functions/ai_gen.html) | Corrige la gramática del texto proporcionado. | 
-- MAGIC | [ai_mask](https://docs.databricks.com/pt/sql/language-manual/functions/ai_mask.html) | Enmascarar datos confidenciales |
-- MAGIC | [ai_query](https://docs.databricks.com/pt/sql/language-manual/functions/ai_query.html) | Enviar instrucciones para el modelo deseado. |
-- MAGIC | [ai_similarity](https://docs.databricks.com/pt/sql/language-manual/functions/ai_similarity.html) | Calcula la similitud entre dos expresiones. |
-- MAGIC | [ai_summarize](https://docs.databricks.com/pt/sql/language-manual/functions/ai_summarize.html) | Resume el texto dado. |
-- MAGIC | [ai_translate](https://docs.databricks.com/pt/sql/language-manual/functions/ai_translate.html) | Traduce el texto proporcionado |

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC #### 🚀 Análisis de sentimiento

-- COMMAND ----------

SELECT *
     , ai_analyze_sentiment(avaliacao) AS sentimiento
FROM resenas 
WHERE avaliacao IS NOT NULL

-- COMMAND ----------

-- MAGIC %md #### 📝 Traducción

-- COMMAND ----------

-- DBTITLE 1,Ejemplo
SELECT ai_translate(avaliacao, 'es') texto FROM resenas LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Uso de ai_translate en una función
SELECT  *, ai_translate(avaliacao, 'es') AS resena FROM resenas LIMIT 5

-- COMMAND ----------

-- DBTITLE 1,Crear tabla de reseñas traducida
CREATE OR REPLACE TABLE resenas_es as 
SELECT data as fecha,
       id_avaliacao as id_resena,
       id_cliente,
       ai_translate(avaliacao, 'es') AS resena,
       ai_query(
  'databricks-meta-llama-3-3-70b-instruct',
  concat('Si el sentimiento de evaluación es negativo, enumere los motivos de la insatisfacción en español. Evaluación: ', avaliacao)) AS motivo_insatisfaccion
FROM resenas

-- COMMAND ----------

select * from resenas_es LIMIT 5

-- COMMAND ----------

-- MAGIC %md ####  🔎 Extrayendo el motivo de la insatisfacción.
-- MAGIC
-- MAGIC *SUGERENCIA: Utilice la función AI_QUERY() para proporcionar un mensaje personalizado*

-- COMMAND ----------

-- DBTITLE 1,Comprobar en español
SELECT *,
       ai_query(
  'databricks-meta-llama-3-3-70b-instruct',
  concat('Si el sentimiento de evaluación es negativo, enumere los motivos de la insatisfacción en español. Evaluación: ', resena)) AS motivo_insatisfaccion
FROM resenas_es LIMIT 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 🔎 Analizar el sentimiento y extraer entidades a escala
-- MAGIC
-- MAGIC Tener que especificar las instrucciones varias veces acaba siendo laborioso, especialmente para los Analistas de Datos que deben centrarse en analizar los resultados de esta extracción.
-- MAGIC
-- MAGIC Para simplificar el acceso a esta inteligencia, crearemos una función SQL para encapsular este proceso y poder informar simplemente a qué columna de nuestro conjunto de datos nos gustaría aplicarlo.
-- MAGIC
-- MAGIC ¡Aquí, aprovechamos para enviar una única consulta a nuestro modelo para extraer toda la información de una vez!
-- MAGIC
-- MAGIC <img src="https://raw.githubusercontent.com/databricks-demos/dbdemos-resources/main/images/product/sql-ai-functions/sql-ai-query-function-review-wrapper.png" width="1200px">

-- COMMAND ----------

-- MAGIC %md #### ✔️ Creando una función para extraer toda la información

-- COMMAND ----------

CREATE OR REPLACE FUNCTION revisar_resena_es(resena STRING)
RETURNS STRUCT<nombre_producto: STRING, sentimiento: STRING, respuesta: STRING, respuesta_motivo: STRING>
RETURN FROM_JSON(
  AI_QUERY(
    'databricks-meta-llama-3-1-405b-instruct',
    CONCAT(
      'Eres un asistente para análisis de reseñas de clientes. Respondemos a cualquiera que parezca insatisfecho. 
      Extrae la siguiente información de la reseña:
        - extraer el producto
        - clasificar el sentimiento como ["POSITIVO","NEGATIVO","NEUTRAL"]
        - regresar si el sentimiento es NEGATIVO y necesita una respuesta: S o N
        - si el sentimiento es NEGATIVO, enumere los motivos de la insatisfacción
      Devuelve SOLO un JSON en una sola línea, exactamente con los siguientes campos (sin comentarios ni texto adicional):
      {
        "nombre_producto": <nombre del producto extraído>, 
        "sentimiento": <entidad sentimiento>, 
        "respuesta": "S" o "N" (solo S si el sentimiento es NEGATIVO y necesita respuesta, de lo contrario N), 
        "respuesta_motivo": <explicación solo si corresponde de las razones principales>
      } 
      Reseña: ', resena
    )
  ),
  "STRUCT<nombre_producto: STRING, sentimiento: STRING, respuesta: STRING, respuesta_motivo: STRING>"
)

-- COMMAND ----------

-- MAGIC %md #### ✔️ Probando la función con una reseña

-- COMMAND ----------

SELECT revisar_resena_es('Compré el portátil ABC y estoy muy insatisfecho con la calidad de la pantalla. Los colores son débiles y la resolución es baja. Además, el rendimiento es lento y se bloquea con frecuencia. ¡No lo recomiendo!') AS resultado

-- COMMAND ----------

-- MAGIC %md #### ✔️  Analizando todas las reseñas

-- COMMAND ----------

-- DBTITLE 1,Crear una tabla de reseñas revisadas
CREATE OR REPLACE TABLE resenas_revisadas AS
SELECT *, resultado.* FROM (
  SELECT *, revisar_resena_es(resena) as resultado FROM agents_ia.atencion.resenas_es LIMIT 10)

-- COMMAND ----------

SELECT * FROM resenas_revisadas LIMIT 10

-- COMMAND ----------

-- MAGIC %md Ahora todos nuestros usuarios pueden aprovechar nuestra función cuidadosamente preparada para analizar las reseñas de nuestros productos.
-- MAGIC
-- MAGIC ¡Y podemos escalar fácilmente este proceso aplicando esta función a todo nuestro conjunto de datos!

-- COMMAND ----------

-- MAGIC %md ## 📝 Generando una respuesta sugerida
-- MAGIC
-- MAGIC Con toda la información extraída, podemos utilizarla para generar sugerencias de respuestas personalizadas para agilizar el trabajo de nuestros equipos de servicio.
-- MAGIC
-- MAGIC Otro punto interesante es que, en este proceso, podemos aprovechar otra **información estructurada** que ya tenemos en nuestro entorno, como datos demográficos, psicográficos e historial de compras, ¡para personalizar aún más nuestras respuestas!
-- MAGIC
-- MAGIC ¡Veamos cómo hacerlo!

-- COMMAND ----------

-- MAGIC %md ### A. Crear una función para generar una respuesta de ejemplo

-- COMMAND ----------

CREATE OR REPLACE FUNCTION GENERE_RESPUESTA(nombre STRING, apellido STRING, num_pedidos INT, producto STRING, motivo STRING)
RETURNS TABLE(respuesta STRING)
COMMENT 'Si el cliente expresa insatisfacción con un producto, utilice esta función para generar una respuesta personalizada'
RETURN SELECT AI_QUERY(
    'databricks-meta-llama-3-1-70b-instruct',
    CONCAT(
        "Eres un asistente virtual para un comercio electrónico. Nuestro cliente, ", GENERE_RESPUESTA.nombre, " ", GENERE_RESPUESTA.apellido, " quien compró ", GENERE_RESPUESTA.num_pedidos, " productos este año no estaba satisfecho con el producto ", GENERE_RESPUESTA.producto, 
        ", pues ", GENERE_RESPUESTA.motivo, ". Proporcionar un breve mensaje empático al cliente incluyendo una oferta para cambiar el producto si cumple con nuestra política de cambio. El canje se podrá realizar directamente a través de este asistente. ",
        "Quiero recuperar su confianza y evitar que deje de ser nuestro cliente. ",
        "Escribe un mensaje con algunas frases. ",
        "No agregue ningún texto que no sea el mensaje. ",
        "No agregues ninguna firma."
    )
)

-- COMMAND ----------

-- MAGIC %md ### B. Generar respuestas automáticas a todas las críticas negativas

-- COMMAND ----------

--Filtramos por las criticas negativas (respuesta = 'S')
CREATE OR REPLACE TABLE respuestas AS
WITH resenas_enriq AS (
  SELECT a.*, c.* EXCEPT (c.id_cliente) 
  FROM resenas_revisadas a 
  LEFT JOIN clientes c 
  ON a.id_cliente = c.id_cliente 
  WHERE a.respuesta = 'S' 
  LIMIT 10
)

SELECT 
  *, 
  (SELECT * FROM genere_respuesta(e.nome, e.sobrenome, e.num_pedidos, e.nombre_producto, e.motivo_insatisfaccion)) AS respuesta_automatica 
FROM resenas_enriq e

-- COMMAND ----------

SELECT id_resena, id_cliente, resena, sentimiento, nome, sobrenome, respuesta_automatica FROM respuestas LIMIT 5

-- COMMAND ----------

-- MAGIC %md # ¡Felicidades!
-- MAGIC
-- MAGIC ¡Ha completado la práctica de laboratorio de **Funciones de IA**!
-- MAGIC
-- MAGIC ¡Ahora ya sabe cómo utilizar funciones de IA para analizar sentimientos, identificar entidades en reseñas de productos de una manera simple y escalable, y generar respuestas automaticas a las reseñas negativas!
