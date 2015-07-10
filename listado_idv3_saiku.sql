select i.anio,i.codigo,i.provincia,i.canton,i.parroquia,i.idv3,v.idv_prov 
FROM
(SELECT	
	extract(year from fi.fit_fecha) AS anio, 
	ug.ubi_parroquia_cod AS codigo,            
	ug.ubi_provincia AS provincia,
	ug.ubi_canton AS canton, 
	ug.ubi_parroquia_cod||'-'||ug.ubi_parroquia AS parroquia,
	round(fi.fit_valor::numeric,4) AS idv3
	--fi.position AS posicion
	FROM "TD".dim_indicador_territorio_digitales,
	"TD".dim_ubicacion_geografica ug,
	"TD".fact_indicadores_td fi
	WHERE dim_indicador_territorio_digitales.itd_sk = fi.fit_itd_sk 
	AND ug.ubi_sk = fi.fit_ubi_sk 
	AND dim_indicador_territorio_digitales.itd_sk = 159
	AND fi.fit_fecha = '2014-12-31') i
          
 JOIN (SELECT 	extract(year from fact_indicadores_td.fit_fecha) AS anio, 
		dim_ubicacion_geografica.ubi_provincia AS provincia,
		round(fact_indicadores_td.fit_valor::numeric,4) AS idv_prov
		FROM "TD".dim_indicador_territorio_digitales,
		"TD".dim_ubicacion_geografica,
		"TD".fact_indicadores_td
		WHERE dim_indicador_territorio_digitales.itd_sk = fact_indicadores_td.fit_itd_sk 
		AND dim_ubicacion_geografica.ubi_sk = fact_indicadores_td.fit_ubi_sk 
		AND dim_ubicacion_geografica.ubi_canton_cod is null
		AND dim_ubicacion_geografica.ubi_parroquia_cod is null
		AND dim_indicador_territorio_digitales.itd_sk = 159 
		AND fact_indicadores_td.fit_fecha = '2014-12-31') v ON v.provincia = i.provincia
		where i.parroquia is not null

