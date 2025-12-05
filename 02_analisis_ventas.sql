
-- Consulta 1: Ventas totales (importe total vendido)
SELECT CONCAT('$ ', FORMAT(SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario), 0, 'es_AR')) AS ventas_totales
FROM `Ventas_Detalle`;

-- Consulta 2: Cantidad total de ventas
SELECT
    COUNT(*) AS cantidad_total_ventas
FROM
    `Ventas_Detalle`;

-- Consulta 3: Ticket promedio general
SELECT
    SUM(Ventas_Detalle.cantidad * Ventas_Detalle.precio_unitario) / COUNT(*) AS ticket_promedio
FROM
    `Ventas_Detalle`;

-- Consulta 4: Ticket promedio por día de la semana
SELECT
    `Fecha`.nombre_dia_semana AS dia_semana,
    SUM(Ventas_Detalle.cantidad * Ventas_Detalle.precio_unitario) / COUNT(*) AS ticket_promedio
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    `Fecha`.nombre_dia_semana
ORDER BY
    ticket_promedio DESC;

-- Consulta 5: Ticket promedio por mes
SELECT
    `Fecha`.nombre_mes AS mes,
    SUM(Ventas_Detalle.cantidad * Ventas_Detalle.precio_unitario) / COUNT(*) AS ticket_promedio
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    `Fecha`.nombre_mes
ORDER BY
    ticket_promedio DESC;

-- Consulta 6: Margen bruto por categoría
SELECT
    `Producto`.categoria AS categoria,
    SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar)) AS margen_bruto,
    ROUND(
        SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar))
        / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
        2
    ) AS margen_porcentual
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.categoria
ORDER BY
    margen_porcentual DESC;

-- Consulta 7: Margen bruto por producto
SELECT
    `Producto`.nombre AS producto,
    `Producto`.categoria AS categoria,
    SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar)) AS margen_bruto,
    ROUND(
        SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar))
        / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
        2
    ) AS margen_porcentual
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.nombre,
    `Producto`.categoria
ORDER BY
    margen_porcentual DESC;

-- Consulta 8: Rentabilidad por sucursal
SELECT
    `Sucursal`.nombre AS sucursal,
    SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar)) AS margen_bruto,
    ROUND(
        SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar))
        / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
        2
    ) AS margen_porcentual
FROM
    `Ventas_Detalle`
JOIN
    `Sucursal` ON `Ventas_Detalle`.id_sucursal = `Sucursal`.id_sucursal
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Sucursal`.nombre
ORDER BY
    margen_porcentual DESC;

-- Consulta 9: % de participación del delivery (PedidosYa)
SELECT
    ROUND(
        SUM(IF(`Canal`.canal = 'PedidosYa', `Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario, 0))
        / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
        2
    ) AS porcentaje_pedidosya
FROM
    `Ventas_Detalle`
JOIN
    `Canal` ON `Ventas_Detalle`.id_canal = `Canal`.id_canal;

-- Consulta 10: Comisiones totales pagadas a PedidosYa
-- Supuesto: la comisión es del 30% (0.30)
SELECT
    CONCAT(
        '$ ',
        FORMAT(
            SUM(
                IF(
                    `Canal`.canal = 'PedidosYa',
                    `Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario * 0.30,
                    0
                )
            ),
            0,
            'es_AR'
        )
    ) AS comision_total_pedidosya
FROM
    `Ventas_Detalle`
JOIN
    `Canal` ON `Ventas_Detalle`.id_canal = `Canal`.id_canal;

-- Consulta 11: Comisión promedio por venta (solo PedidosYa)
SELECT
    AVG(
        `Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario * 0.30
    ) AS comision_promedio_pedidosya
FROM
    `Ventas_Detalle`
JOIN
    `Canal` ON `Ventas_Detalle`.id_canal = `Canal`.id_canal
WHERE
    `Canal`.canal = 'PedidosYa';

-- Consulta 12: Ventas por franja horaria (mediodía/tarde y noche)
SELECT
    CASE
        WHEN `Ventas_Detalle`.hora BETWEEN '12:00:00' AND '18:59:59' THEN 'Mediodía/Tarde'
        ELSE 'Noche'
    END AS franja_horaria,
    COUNT(*) AS cantidad_ventas,
    CONCAT(
        '$ ',
        FORMAT(
            SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario),
            0,
            'es_AR'
        )
    ) AS importe_total
FROM
    `Ventas_Detalle`
GROUP BY
    franja_horaria
ORDER BY
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) DESC;

-- Consulta 13: % de ventas por temporada (verano/otoño/invierno/primavera)
SELECT
    CASE
        WHEN `Fecha`.nombre_mes IN ('Diciembre', 'Enero', 'Febrero') THEN 'Verano'
        WHEN `Fecha`.nombre_mes IN ('Marzo', 'Abril', 'Mayo') THEN 'Otoño'
        WHEN `Fecha`.nombre_mes IN ('Junio', 'Julio', 'Agosto') THEN 'Invierno'
        ELSE 'Primavera'
    END AS temporada,
    CONCAT(
        '$ ',
        FORMAT(
            SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario),
            0,
            'es_AR'
        )
    ) AS importe_total,
    ROUND(
        SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario)
        / (
            SELECT
                SUM(v2.cantidad * v2.precio_unitario)
            FROM
                `Ventas_Detalle` v2
        ) * 100,
        2
    ) AS porcentaje_sobre_total
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    temporada
ORDER BY
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) DESC;

-- Consulta 14: Días con más ventas (TOP 10)
SELECT
    `Fecha`.fecha AS fecha,
    COUNT(*) AS cantidad_ventas,
    CONCAT(
        '$ ',
        FORMAT(
            SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario),
            0,
            'es_AR'
        )
    ) AS importe_total
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    `Fecha`.fecha
ORDER BY
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) DESC
LIMIT 10;

-- Consulta 15: Productos con mayor margen (TOP 10)
SELECT
    `Producto`.nombre AS producto,
    `Producto`.categoria AS categoria,
    SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar)) AS margen_bruto,
    ROUND(
        SUM(`Ventas_Detalle`.cantidad * (`Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar))
        / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
        2
    ) AS margen_porcentual
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.nombre,
    `Producto`.categoria
ORDER BY
    margen_porcentual DESC
LIMIT 10;

-- Consulta 16: Margen bruto total
SELECT
    CONCAT(
        '$ ',
        FORMAT(
            SUM(
                `Ventas_Detalle`.cantidad * (
                    `Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar
                )
            ),
            0,
            'es_AR'
        )
    ) AS margen_bruto_total
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto;

-- Consulta 17: Margen bruto total en porcentaje
SELECT
    CONCAT(
        FORMAT(
            ROUND(
                SUM(
                    `Ventas_Detalle`.cantidad * (
                        `Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar
                    )
                )
                / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
                2
            ),
            2,
            'es_AR'
        ),
        ' %'
    ) AS margen_bruto_total_porcentaje
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto;

-- Consulta 18: Ranking de sucursales por ventas y margen
SELECT
    `Sucursal`.nombre AS sucursal,
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) AS ventas_totales,
    SUM(
        `Ventas_Detalle`.cantidad * (
            `Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar
        )
    ) AS margen_bruto,
    ROUND(
        SUM(
            `Ventas_Detalle`.cantidad * (
                `Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar
            )
        ) / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
        2
    ) AS margen_porcentual
FROM
    `Ventas_Detalle`
JOIN
    `Sucursal` ON `Ventas_Detalle`.id_sucursal = `Sucursal`.id_sucursal
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Sucursal`.nombre
ORDER BY
    ventas_totales DESC;

-- Consulta 19: Productos con margen porcentual mayor al 50%
SELECT
    `Producto`.nombre AS producto,
    `Producto`.categoria AS categoria,
    ROUND(
        SUM(
            `Ventas_Detalle`.cantidad * (
                `Ventas_Detalle`.precio_unitario - `Producto`.costo_estandar
            )
        )
        / SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) * 100,
        2
    ) AS margen_porcentual
FROM
    `Ventas_Detalle`
JOIN
    `Producto` ON `Ventas_Detalle`.id_producto = `Producto`.id_producto
GROUP BY
    `Producto`.nombre,
    `Producto`.categoria
HAVING
    margen_porcentual > 50
ORDER BY
    margen_porcentual DESC;

-- Consulta 20: Días con más de 200 ventas
SELECT
    `Fecha`.fecha,
    COUNT(*) AS cantidad_ventas
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
GROUP BY
    `Fecha`.fecha
HAVING
    COUNT(*) > 200
ORDER BY
    cantidad_ventas DESC;

-- Consulta 21: Comparación de ventas entre meses específicos (Enero vs Junio)
SELECT
    `Fecha`.nombre_mes AS mes,
    CONCAT(
        '$ ',
        FORMAT(
            SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario),
            0,
            'es_AR'
        )
    ) AS total_mes
FROM
    `Ventas_Detalle`
JOIN
    `Fecha` ON `Ventas_Detalle`.id_fecha = `Fecha`.id_fecha
WHERE
    `Fecha`.nombre_mes IN ('Enero', 'Junio')
GROUP BY
    `Fecha`.nombre_mes
ORDER BY
    SUM(`Ventas_Detalle`.cantidad * `Ventas_Detalle`.precio_unitario) DESC;

-- Consulta 22: Productos con precio de lista mayor a $10.000
SELECT
    nombre,
    precio_lista
FROM
    `Producto`
WHERE
    precio_lista > 10000;

