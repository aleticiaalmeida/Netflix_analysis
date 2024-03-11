
-- Começando por uma análise exploratória dos dados
SELECT * FROM netflix_titles;



-- Contando a quantidade de títulos da tabela
SELECT
	COUNT(*)
FROM netflix_titles;



-- Contando a quantidade de filmes e séries produzidos
SELECT
    type,
    COUNT(type) AS 'type_of_title'
FROM 
	netflix_titles
GROUP BY
    type; -- usar o mesmo nome da coluna original


-- Contando a quantidade de filmes e séries produzidos por ano    
SELECT
    release_year,
    type,
    COUNT(type) AS type_of_title
FROM 
	netflix_titles
GROUP BY 
	release_year, 
    type
ORDER BY type_of_title DESC;



-- Contando a quantidade de obras por diretor
SELECT
	director,
    COUNT(director) AS 'total_titles'
FROM netflix_titles
GROUP BY director
ORDER BY total_titles DESC;



-- Contando a quantidade de obras lançadas e adicionadas à plataforma por ano
SELECT
    year,
    SUM(count_added_titles) AS total_added_titles,
    SUM(count_release_titles) AS total_release_titles
FROM (
    SELECT
        YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year,
        COUNT(*) AS count_added_titles,
        NULL AS release_year,
        0 AS count_release_titles
    FROM netflix_titles
    GROUP BY year

    UNION ALL

    SELECT
        release_year AS year,
        0 AS count_added_titles,
        release_year,
        COUNT(*) AS count_release_titles
    FROM netflix_titles
    GROUP BY release_year
) AS subquery
GROUP BY year
ORDER BY total_added_titles DESC;



-- Separando a duração das obras entre número e unidade
SELECT
    duration,
    SUBSTRING_INDEX(duration, ' ', 1) AS duration_number,
    SUBSTRING(duration, LOCATE(' ', duration) + 1) AS duration_unit
FROM
    netflix_titles;



-- Utilizando a consulta anterior como subquerie    
SELECT
		year,
        (SELECT
			duration,
			SUBSTRING_INDEX(duration, ' ', 1) AS duration_number,
			SUBSTRING(duration, LOCATE(' ', duration) + 1) AS duration_unit
		FROM
			netflix_titles)
FROM netflix_titles;


-- Extraindo a duração de filmes e séries
SELECT
    type,
    SUBSTRING_INDEX(duration, ' ', 1) AS duration_number,
    SUBSTRING(duration, LOCATE(' ', duration) + 1) AS duration_unit
FROM
    netflix_titles;



-- Criando uma view para armazenar os dados de duração dos títulos
CREATE VIEW duration AS
SELECT
    type,
    SUBSTRING_INDEX(duration, ' ', 1) AS duration_number,
    SUBSTRING(duration, LOCATE(' ', duration) + 1) AS duration_unit
FROM
    netflix_titles;
    
SELECT * FROM duration;




-- Exibindo os tipos de unidade de medida
SELECT 
	duration_unit,
	COUNT(duration_unit) AS units
FROM
	duration
GROUP BY duration_unit;
  
  
  
  
-- Média de duração dos filmes em minutos
SELECT
	type,
    AVG(duration_number) AS 'avg_duration'
FROM duration
WHERE type = 'Movie'
GROUP BY type;


-- Média de duração das séries em temporadas --> foi necessário fazer filtrando a uniade por estarem com escritas diferentes
SELECT
	type,
    duration_unit,
    AVG(duration_number) AS 'avg_duration'
FROM duration
WHERE duration_unit LIKE 'Season%'
GROUP BY type, duration_unit;




-- Contando a quantidade de séries com apenas uma temporada
SELECT
	COUNT(duration_number) AS 'count_duration_number'
FROM duration
WHERE duration_number = 1;




-- Expondo os títulos exibidos no Brazil
SELECT
	country,
    type,
    title
FROM
	netflix_titles
WHERE country LIKE '%Brazil%'
GROUP BY type, country, title;



SELECT
	description
FROM netflix_titles;



-- Exibindo países com mais títulos com a palavra 'polícia' na descrição
SELECT
	country,
	COUNT(description) AS count_description
FROM
	netflix_titles
WHERE description LIKE '%police%'
GROUP BY country
ORDER BY count_description DESC;


-- Exibindo países com mais títulos listados em categorias de ação
SELECT
	country,
    COUNT(listed_in) AS count_listed_in
FROM 
	netflix_titles
WHERE
	listed_in LIKE '%Action%'
GROUP BY country
ORDER BY count_listed_in DESC;



-- Exibindo países com mais títulos listados em categorias de documentários
SELECT
	country,
    COUNT(listed_in) AS count_listed_in
FROM 
	netflix_titles
WHERE
	listed_in LIKE '%Documentaries%'
GROUP BY country
ORDER BY count_listed_in DESC;


/*As análises trazidas nestas consultas nos permitem concluir que:
- A tabela possui 6262 títulos, entre filmes e séries.
- A tabela contém dados de 4342 filmes e 1920 séries.
- 2017 foi o ano com mais flimes lançados, enquanto 2020 foi o ano com mais séries lançadas.
- Embora existam 1913 títulos sem o nome do diretor, o diretor com maior número de títulos é Marcus Raboy, com 14 obras. Seguido por Jay Karas, 13 obras e Rakiv Chapman, 12 obras.
- Diretores consagrados, como Steven Spielberg e Martin Scorsese possuem 9 títulos.



