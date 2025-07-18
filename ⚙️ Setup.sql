-- Databricks notebook source
-- MAGIC %md
-- MAGIC <img src="https://github.com/aestaire/AI_agents/blob/main/img/headertools_aiagents.png?raw=true" width=100%>
-- MAGIC
-- MAGIC
-- MAGIC Ejecutar solo en el momento de la creación para generar un catálogo de pruebas y tablas utilizadas en este laboratorio.

-- COMMAND ----------

-- DBTITLE 1,Crear la estructura central
--Crear tablas necesarias para el modelo

CREATE CATALOG IF NOT EXISTS `agents_ia`;

CREATE SCHEMA IF NOT EXISTS `agents_ia`.`atencion`;

CREATE VOLUME IF NOT EXISTS `agents_ia`.`atencion`.`archivos`;

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla Productos
-- MAGIC %python
-- MAGIC
-- MAGIC catalog = "agents_ia"
-- MAGIC schema = "atencion"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/productos.csv"
-- MAGIC file_name = "productos.csv"
-- MAGIC table_name = "productos"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")
-- MAGIC
-- MAGIC display(df)

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla faq
-- MAGIC %python
-- MAGIC catalog = "agents_ia"
-- MAGIC schema = "atencion"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/faq.csv"
-- MAGIC file_name = "faq.csv"
-- MAGIC table_name = "faq"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC # Rename columns to remove invalid characters
-- MAGIC for col in df.columns:
-- MAGIC     new_col = col.replace(" ", "_").replace(";", "_").replace("{", "_").replace("}", "_") \
-- MAGIC                  .replace("(", "_").replace(")", "_").replace("\n", "_").replace("\t", "_") \
-- MAGIC                  .replace("=", "_")
-- MAGIC     df = df.withColumnRenamed(col, new_col)
-- MAGIC
-- MAGIC # Save the table
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")
-- MAGIC
-- MAGIC display(df)

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla Reseñas
-- MAGIC %python
-- MAGIC catalog = "agents_ia"
-- MAGIC schema = "atencion"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/opiniones.csv"
-- MAGIC file_name = "opiniones.csv"
-- MAGIC table_name = "resenas"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")
-- MAGIC
-- MAGIC display(df)

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla Clientes
-- MAGIC %python
-- MAGIC catalog = "agents_ia"
-- MAGIC schema = "atencion"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/clientes.csv"
-- MAGIC file_name = "clientes.csv"
-- MAGIC table_name = "clientes"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")
-- MAGIC
-- MAGIC display(df)
