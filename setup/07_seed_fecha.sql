USE heladeria_ventas;

DELIMITER $$

CREATE PROCEDURE seed_fecha()
BEGIN
    DECLARE fecha_actual DATE;
    DECLARE fecha_fin DATE;

    SET fecha_actual = '2022-01-01';
    SET fecha_fin    = '2025-12-31';

    WHILE fecha_actual <= fecha_fin DO
        INSERT INTO Fecha (
            id_fecha,
            fecha,
            anio,
            mes,
            nombre_mes,
            dia,
            dia_semana,
            nombre_dia_semana,
            semana_anio
        )
        VALUES (
            DATEDIFF(fecha_actual, '2022-01-01') + 1,
            fecha_actual,
            YEAR(fecha_actual),
            MONTH(fecha_actual),
            MONTHNAME(fecha_actual),
            DAY(fecha_actual),
            DAYOFWEEK(fecha_actual),
            DAYNAME(fecha_actual),
            WEEK(fecha_actual, 1)
        );

        SET fecha_actual = DATE_ADD(fecha_actual, INTERVAL 1 DAY);
    END WHILE;
END$$

DELIMITER ;

CALL seed_fecha();

DROP PROCEDURE seed_fecha;

SELECT COUNT(*) FROM Fecha;
