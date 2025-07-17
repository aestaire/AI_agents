<img src="https://github.com/aestaire/AI_agents/blob/main/img/headertools_aiagents.png?raw=true" width=100%>

# Databricks AI Systems - Agentes de IA 

## Objectivo

Los LLM son excelentes para responder preguntas generales. Sin embargo, la inteligencia general por sí sola no es suficiente para ofrecer valor a sus clientes.

Para poder brindar respuestas valiosas, se requiere información adicional, específica de su negocio y del usuario que hace la pregunta (su ID de contrato de cliente, el último correo electrónico que enviaron a su soporte, su informe de ventas más reciente, etc.).

Los sistemas de IA componibles están diseñados para responder a este desafío. Son despliegues de IA más avanzados, compuestos por múltiples entidades (herramientas) especializadas en diferentes acciones (recuperar información o actuar sobre sistemas externos). <br/>

En un nivel alto, usted crea y presenta un conjunto de funciones personalizadas a la IA. Luego, el LLM puede razonar al respecto, decidir qué herramienta se debe utilizar y recopilar información para responder a las necesidades del cliente.

## Características clave

- Cree y almacene sus funciones (herramientas) aprovechando UC
- Ejecute las funciones de forma segura.
- Razone sobre las herramientas que seleccionó y encadenélas para responder adecuadamente a su pregunta.

## Requisitos

- Se requiere Unity Catalog
- Se requiere la creación de Vector Search
- Se requiere la utilización de LLMs

## Detalles de la implementación

<img src="https://github.com/mousastech/agentes_ia/blob/e4602f57c4a83b171c7c541e11244136cdd80816/img/llm-call.png?raw=true" width="100%">

## Setup y uso

1. Hacer el setup de las tablas (si aún no lo ha hecho) - notebook **⚙️ Setup**
2. Ejecutar el notebook **🚀 1. AI Functions** para usar las [AI Functions](https://docs.databricks.com/en/large-language-models/ai-functions.html)

Estas funciones nos permiten ejecutar modelos de IA generativa en nuestras bases de datos corporativas directamente en consultas SQL, un lenguaje ampliamente utilizado por analistas de datos y negocios. Con esto también podremos crear nuevas tablas con la información extraída para utilizarla en nuestros análisis.

3. Ejecutar el notebook **🛠️ 2. Agentes de IA** para la creación del agente
