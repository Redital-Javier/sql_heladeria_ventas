# 🛢️ sql_heladeria_ventas

Proyecto SQL orientado al análisis comercial de una heladería con múltiples sucursales.  
Incluye la creación completa del esquema de base de datos, carga inicial de datos y consultas diseñadas para explorar ventas, productos, márgenes, estacionalidad y desempeño por sucursal.

---

## 🗂 Estructura del proyecto

```
sql_heladeria_ventas/
│
├── setup/                     # Scripts para crear la base desde cero
│   ├── 01_schema.sql
│   ├── 02_seed_canal.sql
│   ├── 03_seed_metodo_pago.sql
│   ├── 04_seed_sucursal.sql
│   ├── 05_seed_zona_cliente.sql
│   ├── 06_seed_producto.sql
│   ├── 07_seed_fecha.sql
│   └── 08_seed_ventas_detalle.sql
│
├── 01_exploracion_inicial.sql
├── 02_analisis_ventas.sql
└── README.md

```

---

## 🚀 Cómo usarlo

### 1. Crear el schema en MySQL

```sql
CREATE DATABASE heladeria_ventas;
USE heladeria_ventas;
```

### 2. Ejecutar los scripts de la carpeta `/setup` en orden  
Esto crea todas las tablas y carga los datos iniciales.

### 3. Ejecutar los análisis

- `01_exploracion_inicial.sql` → análisis básico, exploración y estructura  
- `02_analisis_ventas.sql` → métricas comerciales (ticket promedio, márgenes, estacionalidad, rankings, etc.)

---

## 📸 Capturas del proyecto

### Diagrama entidad–relación
![Diagrama entidad-relación](imagenes/diagrama_entidad_relacion.png)

### Creación de tablas
![Creación de tablas](imagenes/creacion_tablas.png)

### Relaciones entre tablas
![Relaciones entre tablas](imagenes/relaciones_tablas.png)

### Tablas creadas
![Tablas creadas](imagenes/tablas_creadas.png)

### Carga de productos
![Carga de productos](imagenes/carga_productos.png)

### Exploración inicial
![Exploración inicial](imagenes/exploracion_inicial.png)

### Importe vendido por canal
![Importe por canal](imagenes/importe_canal.png)

### Ventas por franja horaria
![Ventas por franja horaria](imagenes/ventas_franja_horaria.png)

### Ventas por hora
![Ventas por hora](imagenes/ventas_hora.png)

### Ventas por sucursal
![Ventas por sucursal](imagenes/ventas_sucursal.png)

### Días con más de 200 ventas
![Días con más de 200 ventas](imagenes/dias_ventas_mayores_200.png)
