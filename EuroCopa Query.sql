-- Categorización de jugadores por edad
SELECT nombre_jugador, edad, 
CASE	
	WHEN edad <23 THEN 'Joven'
	WHEN edad <32 THEN 'Promedio'
	WHEN edad >=32 THEN 'Veterano'
	END AS clasificacion
FROM jugadores;

-- Nacionalidad de los entrenadores
SELECT nombre_pais, nombre_entrenador
FROM paises p
INNER JOIN entrenadores e
	ON p.id_pais = e.id_pais;

-- Obtener la lista de los equipos que superan el promedio de puntos
SELECT nombre_pais, grupo, 
	partidos_jugados, ganados, 
    perdidos, empatados, puntos
FROM equipos 
INNER JOIN paises
ON equipos.id_pais = paises.id_pais
WHERE puntos >
				(SELECT AVG(puntos)
				FROM equipos);

-- Jugadores de Portugal
SELECT *
FROM jugadores
WHERE id_pais = (
				SELECT id_pais
                FROM paises
                WHERE nombre_pais = 'Portugal')
;
-- Máximo goleador del torneo
SELECT *
FROM jugadores
WHERE id_jugador = (SELECT id_jugador
					FROM (SELECT id_jugador, COUNT(*) AS Goles
							FROM goles
							GROUP BY id_jugador
							ORDER BY Goles DESC
							LIMIT 1) AS Goleador) ;
                            
-- Jugadores qwue no metieron gol en el torneo
SELECT nombre_jugador, posicion, club
FROM jugadores
WHERE id_jugador NOT IN (
						SELECT DISTINCT id_jugador
						FROM goles);
                  
-- Jugadores que realizaron goles. Uso Subqueri correlacionado en este caso, sin embargo, también se podía usar un join
SELECT *, 
	(
    SELECT nombre_jugador
    FROM jugadores
    WHERE goles.id_jugador = jugadores.id_jugador
    ) AS Jugador
FROM goles;

-- Goles anotados por país
SELECT nombre_pais
, SUM(goles_anotados) as goles_anotados
FROM partidos
LEFT JOIN paises
	ON partidos.id_pais = paises.id_pais
GROUP BY nombre_pais
ORDER BY goles_anotados desc;

-- Info del jugador que hizo gol en la final
SELECT jugadores.nombre_jugador
, jugadores.playera
, paises.nombre_pais
FROM goles
LEFT JOIN jugadores 
	ON goles. id_jugador = jugadores. id_jugador
LEFT JOIN paises 
	ON goles.id_pais = paises.id_pais
WHERE ronda = 'F';

-- País mas goleado
SELECT nombre_pais
, goles_en_contra
FROM equipos
LEFT JOIN paises
	ON equipos.id_pais = paises.id_pais
WHERE goles_en_contra = (SELECT MAX(goles_en_contra) FROM equipos);

-- Goles por partidos y jugadores
SELECT g.num_partido,
       p.nombre_pais AS nombre_país,
       j.nombre_jugador AS nombre_jugador,
       COUNT(*) AS cantidad_goles
FROM goles g
INNER JOIN paises p ON g.id_pais = p.id_pais
INNER JOIN jugadores j ON g.id_jugador = j.id_jugador
GROUP BY g.num_partido, p.nombre_pais, j.nombre_jugador
ORDER BY g.num_partido;

-- Conteo de goles por jugador
SELECT nombre_jugador,
	(SELECT nombre_pais FROM paises WHERE jugadores. id_pais = paises.id_pais) AS nombre_país,
	club,
	(SELECT COUNT(*) FROM goles WHERE goles. id_jugador = jugadores. id_jugador GROUP BY id_jugador) as goles_anotados
FROM jugadores, goles
WHERE jugadores. id_jugador = goles. id_jugador 
GROUP BY jugadores. id_jugador
ORDER BY goles_anotados desc;

-- Jugadores mas jovenes y viejos por país
SELECT nombre_pais,
nombre_jugador,
edad,
CASE
	WHEN edad = edad_max THEN 'Mas viejo'
	WHEN edad = edad_min THEN 'Mas jóven'
END as clasificación
    
FROM (SELECT
	(SELECT nombre_pais FROM paises WHERE j1.id_pais = paises. id_pais) AS nombre_pais,
	nombre_jugador ,
	edad,
	(SELECT MAX(edad) FROM jugadores as j2 WHERE j1.id_pais = j2.id_pais) as edad_max,
	(SELECT MIN(edad) FROM jugadores as j2 WHERE j1.id_pais = j2.id_pais) as edad_min
	FROM jugadores as j1
	ORDER BY nombre_pais, edad desc) as clasificacion_jugadores
WHERE edad = edad_max OR edad = edad_min;

