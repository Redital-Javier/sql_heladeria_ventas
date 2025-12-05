USE heladeria_ventas;

-- Consulta 1: Cantidad de filas por tabla
SELECT 
    'Canal' AS tabla, COUNT(*) AS filas FROM Canal
UNION ALL
SELECT 'Fecha', COUNT(*) FROM Fecha
UNION ALL
SELECT 'Metodo_Pago', COUNT(*) FROM Metodo_Pago
UNION ALL
SELECT 'Producto', COUNT(*) FROM Producto
UNION ALL
SELECT 'Sucursal', COUNT(*) FROM Sucursal
UNION ALL
SELECT 'Zona_Cliente', COUNT(*) FROM Zona_Cliente
UNION ALL
SELECT 'Ventas_Detalle', COUNT(*) FROM Ventas_Detalle;

-- Consulta 2: Muestra de datos de cada tabla (Limit para exploración)
SELECT * FROM `Canal` LIMIT 10;
SELECT * FROM `Fecha` LIMIT 10;
SELECT * FROM `Metodo_Pago` LIMIT 10;
SELECT * FROM `Producto` LIMIT 10;
SELECT * FROM `Sucursal` LIMIT 10;
SELECT * FROM `Ventas_Detalle` LIMIT 10;
SELECT * FROM `Zona_Cliente` LIMIT 10;

-- Consulta 3: Cantidad de ventas por canal
SELECT
    `Canal`.canal as canal, 
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Canal` ON `Ventas_Detalle`.id_canal = `Canal`.id_canal
GROUP BY
    `Canal`.canal;

-- Consulta 4: Cantidad de ventas por sucursal
SELECT
    `Sucursal`.nombre AS sucursal,
    FORMAT (COUNT(*), 0, 'es_AR') AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Sucursal` ON `Ventas_Detalle`.id_sucursal = `Sucursal`.id_sucursal
GROUP BY
    `Sucursal`.nombre
ORDER BY
    cantidad_ventas DESC;

-- Consulta 5: Cantidad de ventas por método de pago
SELECT
    `Metodo_Pago`.metodo_pago AS metodo_pago,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Metodo_Pago` ON `Ventas_Detalle`.id_metodo_pago = `Metodo_Pago`.id_metodo_pago
GROUP BY
    `Metodo_Pago`.metodo_pago
ORDER BY
    cantidad_ventas DESC;

-- Consulta 6: Cantidad de ventas por categoría de producto
SELECT
    `Producto`.categoria AS categoria_producto,
    COUNT (*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.categoria
ORDER BY
    cantidad_ventas DESC;

-- Consulta 7: Cantidad de ventas por día de la semana
SELECT
    `Fecha`.nombre_dia_semana AS dia_semana,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    `Fecha`.nombre_dia_semana
ORDER BY
    cantidad_ventas DESC;

-- Consulta 8: Cantidad de ventas por mes
SELECT
    `Fecha`.nombre_mes AS mes,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    `Fecha`.nombre_mes
ORDER BY
    cantidad_ventas DESC;

-- Consulta 9: Cantidad de ventas por año
SELECT
    `Fecha`.anio AS anio,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    `Fecha`.anio
ORDER BY
    cantidad_ventas DESC;

-- Consulta 10: Cantidad de ventas por hora
SELECT
    `Ventas_Detalle`.hora AS hora,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
GROUP BY
    `Ventas_Detalle`.hora
ORDER BY
    cantidad_ventas DESC
LIMIT 10;

-- Consulta 11: Cantidad de ventas por barrio
SELECT
    `Zona_Cliente`.barrio AS barrio,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Zona_Cliente` ON `Ventas_Detalle`.id_zona = `Zona_Cliente`.id_zona
GROUP BY
    `Zona_Cliente`.barrio
ORDER BY
    cantidad_ventas DESC;

-- Consulta 12: Cantidad de ventas por categoría y sucursal
SELECT
    `Producto`.categoria AS categoria,
    `Sucursal`.nombre AS sucursal,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
JOIN
    `Sucursal` ON `Ventas_Detalle`.id_sucursal = `Sucursal`.id_sucursal
GROUP BY
    `Producto`.categoria,
    `Sucursal`.nombre
ORDER BY
    `Sucursal`.nombre,
    cantidad_ventas DESC;

-- Consulta 13: Productos más vendidos (por cantidad)
SELECT
    `Producto`.nombre AS producto,
    `Producto`.categoria AS categoria,
    SUM(Ventas_Detalle.cantidad) AS unidades_vendidas
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.nombre,
    `Producto`.categoria
ORDER BY
    unidades_vendidas DESC
LIMIT 10;

-- Consulta 14: Productos menos vendidos (por cantidad)
SELECT
    `Producto`.nombre AS producto,
    `Producto`.categoria AS categoria,
    SUM(Ventas_Detalle.cantidad) AS unidades_vendidas
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.nombre,
    `Producto`.categoria
ORDER BY
    unidades_vendidas ASC
LIMIT 10;

-- Consulta 15: Importe total vendido por canal
SELECT
    `Canal`.canal AS canal,
    CONCAT('$ ', FORMAT(SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario), 0, 'es_AR')) AS importe_total
FROM
    `Ventas_Detalle`
JOIN
    `Canal` ON `Ventas_Detalle`.id_canal = `Canal`.id_canal
GROUP BY
    `Canal`.canal
ORDER BY
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) DESC;


-- Consulta 16: Importe total vendido por sucursal
SELECT
    `Sucursal`.nombre AS sucursal,
    CONCAT('$ ', FORMAT(SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario), 0, 'es_AR')) AS importe_total
FROM
    `Ventas_Detalle`
JOIN
    `Sucursal` ON `Ventas_Detalle`.id_sucursal = `Sucursal`.id_sucursal
GROUP BY
    `Sucursal`.nombre
ORDER BY
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) DESC;

-- Consulta 17: Importe total vendido por categoría
SELECT
    `Producto`.categoria AS categoria,
    CONCAT('$ ', FORMAT(SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario), 0, 'es_AR')) AS importe_total
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.categoria
ORDER BY
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) DESC;

-- Consulta 18: Ticket promedio por canal
SELECT
    `Canal`.canal AS canal,
    SUM(Ventas_Detalle.cantidad * Ventas_Detalle.precio_unitario) / COUNT(*) AS ticket_promedio
FROM
    `Ventas_Detalle`
JOIN
    `Canal` ON `Ventas_Detalle`.id_canal = `Canal`.id_canal
GROUP BY
    `Canal`.canal
ORDER BY
    ticket_promedio DESC;

-- Consulta 19: Ticket promedio por sucursal
SELECT
    `Sucursal`.nombre AS sucursal,
    SUM(Ventas_Detalle.cantidad * Ventas_Detalle.precio_unitario) / COUNT(*) AS ticket_promedio
FROM
    `Ventas_Detalle`
JOIN
    `Sucursal` ON `Ventas_Detalle`.id_sucursal = `Sucursal`.id_sucursal
GROUP BY
    `Sucursal`.nombre
ORDER BY
    ticket_promedio DESC;

-- Consulta 20: Ticket promedio por categoría de producto
SELECT
    `Producto`.categoria AS categoria,
    SUM(Ventas_Detalle.cantidad * Ventas_Detalle.precio_unitario) / COUNT(*) AS ticket_promedio
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.categoria
ORDER BY
    ticket_promedio DESC;

