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
                  
-- Jugadores que realizaron goles
SELECT *, 
	(
    SELECT nombre_jugador
    FROM jugadores
    WHERE goles.id_jugador = jugadores.id_jugador
    ) AS Jugador
FROM goles