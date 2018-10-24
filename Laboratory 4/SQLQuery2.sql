-- 1) Afisati toate datele despre grupele de studii la facultate
SELECT *
FROM grupe;

-- 2) Sa se obtina numarul de discipline predate de fiecare profesor (Nume_Profesor, Prenume_Profesor)
SELECT Nume_Profesor
      ,Prenume_Profesor
	  ,count( distinct Id_Disciplina) AS "Nr_discipline"
FROM profesori 
INNER JOIN studenti_reusita 
ON profesori.Id_Profesor=studenti_reusita.Id_Profesor
GROUP BY Nume_Profesor, Prenume_Profesor
ORDER BY "Nr_discipline" DESC;

--

