USE heladeria_ventas;

DELIMITER $$

CREATE PROCEDURE seed_ventas()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_fecha INT;
    DECLARE v_mes TINYINT;
    DECLARE v_dia_semana TINYINT;
    DECLARE ventas_min INT;
    DECLARE ventas_max INT;
    DECLARE ventas_dia INT;
    DECLARE v_cont INT;
    DECLARE v_id_venta INT DEFAULT 1;

    DECLARE v_id_producto INT;
    DECLARE v_id_canal INT;
    DECLARE v_id_metodo_pago INT;
    DECLARE v_id_zona INT;
    DECLARE v_id_sucursal INT;
    DECLARE v_cantidad INT;
    DECLARE v_precio_unitario DECIMAL(10,2);
    DECLARE v_comision DECIMAL(10,2);
    DECLARE v_hora TIME;
    DECLARE p_mostrador DECIMAL(5,2);
    DECLARE r DECIMAL(10,4);
    DECLARE v_start_sec INT;
    DECLARE v_end_sec INT;

    DECLARE cur CURSOR FOR
        SELECT id_fecha, mes, dia_semana FROM Fecha ORDER BY fecha;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_fecha, v_mes, v_dia_semana;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF v_mes IN (12, 1, 2) THEN
            SET p_mostrador = 0.80;

            IF v_dia_semana IN (2,3,4,5) THEN
                SET ventas_min = 120;
                SET ventas_max = 170;
            ELSEIF v_dia_semana = 6 THEN
                SET ventas_min = 140;
                SET ventas_max = 200;
            ELSE
                SET ventas_min = 170;
                SET ventas_max = 240;
            END IF;

        ELSEIF v_mes IN (5, 6, 7, 8) THEN
            SET p_mostrador = 0.40;

            IF v_dia_semana IN (2,3,4,5) THEN
                SET ventas_min = 50;
                SET ventas_max = 90;
            ELSEIF v_dia_semana = 6 THEN
                SET ventas_min = 70;
                SET ventas_max = 110;
            ELSE
                SET ventas_min = 90;
                SET ventas_max = 140;
            END IF;

        ELSE
            SET p_mostrador = 0.65;

            IF v_dia_semana IN (2,3,4,5) THEN
                SET ventas_min = 90;
                SET ventas_max = 130;
            ELSEIF v_dia_semana = 6 THEN
                SET ventas_min = 110;
                SET ventas_max = 150;
            ELSE
                SET ventas_min = 130;
                SET ventas_max = 180;
            END IF;
        END IF;

        SET ventas_dia = FLOOR(ventas_min + RAND() * (ventas_max - ventas_min + 1));
        SET v_cont = 1;

        WHILE v_cont <= ventas_dia DO
            IF RAND() < p_mostrador THEN
                SET v_id_canal = 1;
                SELECT id_producto, precio_lista
                INTO v_id_producto, v_precio_unitario
                FROM Producto
                ORDER BY RAND()
                LIMIT 1;
            ELSE
                SET v_id_canal = 2;
                SELECT id_producto, precio_lista
                INTO v_id_producto, v_precio_unitario
                FROM Producto
                WHERE categoria IN ('Pote','Postre')
                ORDER BY RAND()
                LIMIT 1;
            END IF;

            SELECT id_metodo_pago
            INTO v_id_metodo_pago
            FROM Metodo_Pago
            ORDER BY RAND()
            LIMIT 1;

            SELECT id_zona
            INTO v_id_zona
            FROM Zona_Cliente
            ORDER BY RAND()
            LIMIT 1;

            SELECT id_sucursal
            INTO v_id_sucursal
            FROM Sucursal
            ORDER BY RAND()
            LIMIT 1;

            SET v_cantidad = FLOOR(1 + RAND() * 3);

            IF v_id_canal = 2 THEN
                SET v_comision = v_precio_unitario * v_cantidad * 0.30;
            ELSE
                SET v_comision = 0;
            END IF;

            SET r = RAND();

            IF r < 0.15 THEN
                SET v_start_sec = 12*3600;
                SET v_end_sec   = 16*3600;
            ELSEIF r < 0.75 THEN
                SET v_start_sec = 16*3600;
                SET v_end_sec   = 22*3600;
            ELSE
                SET v_start_sec = 22*3600;
                SET v_end_sec   = 24*3600;
            END IF;

            SET v_hora = SEC_TO_TIME(
                FLOOR(v_start_sec + RAND() * (v_end_sec - v_start_sec))
            );

            INSERT INTO Ventas_Detalle (
                id_venta,
                id_fecha,
                id_producto,
                id_canal,
                id_metodo_pago,
                id_zona,
                id_sucursal,
                cantidad,
                precio_unitario,
                comision_plataforma,
                hora
            )
            VALUES (
                v_id_venta,
                v_id_fecha,
                v_id_producto,
                v_id_canal,
                v_id_metodo_pago,
                v_id_zona,
                v_id_sucursal,
                v_cantidad,
                v_precio_unitario,
                v_comision,
                v_hora
            );

            SET v_id_venta = v_id_venta + 1;
            SET v_cont = v_cont + 1;
        END WHILE;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

CALL seed_ventas();

DROP PROCEDURE seed_ventas;

SELECT COUNT(*) FROM Ventas_Detalle;


