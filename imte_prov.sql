select 	i.anio as año, 
	i.provincia,
	p.poblacion as "Poblacion",
	round(v.idv3::numeric,4) as "Indice Digitalizacion",
	round(i.imte::numeric,4) as "Indice Madurez Tecnologica",
	round(e.p_fortaleza_empresarial::numeric,4) as "Fortaleza Empresarial",
	round(t.p_interes_empresas_tic::numeric,4) as "Interes Empresas en TIC",
	round(u.p_uso_tecnologia::numeric,4) as "Uso de Tecnologia",
	round(c.p_capacidad_t_instalada::numeric,4) as "Capacidad Tech Instalada"
from

(SELECT  extract(year from fi.fit_fecha) AS anio, 
            ug.ubi_provincia AS provincia,
            ug.ubi_provincia_cod AS codigo,
            fi.fit_valor AS imte,
            di.itd_sk AS sk1
           FROM "TD".dim_indicador_territorio_digitales di,
            "TD".dim_ubicacion_geografica ug,
            "TD".fact_indicadores_td fi
          WHERE di.itd_sk = fi.fit_itd_sk 
          AND ug.ubi_sk = fi.fit_ubi_sk 
          AND di.itd_sk =232
          AND ug.ubi_parroquia is null
          AND ug.ubi_canton is null
          AND fi.fit_fecha = '2014-12-31') i

JOIN (	SELECT  extract(year from fi.fit_fecha) AS anio,
		ug.ubi_provincia AS provincia,
               ug.ubi_provincia_cod AS codigo,
		fi.fit_valor as p_fortaleza_empresarial
		FROM "TD".dim_indicador_territorio_digitales di,
            "TD".dim_ubicacion_geografica ug,
            "TD".fact_indicadores_td fi	
          WHERE di.itd_sk = fi.fit_itd_sk 
          AND ug.ubi_sk = fi.fit_ubi_sk 
          AND di.itd_sk =228
          AND ug.ubi_parroquia is null
          AND ug.ubi_canton is null
          AND fi.fit_fecha = '2014-12-31') e
	  ON(e.codigo = i.codigo)
	
JOIN (	SELECT extract(year from fi.fit_fecha) AS anio,
		ug.ubi_provincia AS provincia,
               ug.ubi_provincia_cod AS codigo,
		fi.fit_valor as p_interes_empresas_tic
	FROM "TD".dim_indicador_territorio_digitales di,
            "TD".dim_ubicacion_geografica ug,
            "TD".fact_indicadores_td fi	
          WHERE di.itd_sk = fi.fit_itd_sk 
          AND ug.ubi_sk = fi.fit_ubi_sk 
          AND di.itd_sk =229
          AND ug.ubi_parroquia is null
          AND ug.ubi_canton is null
          AND fi.fit_fecha = '2014-12-31') t
	  ON(t.codigo = i.codigo)

JOIN (	SELECT extract(year from fi.fit_fecha) AS anio,
		ug.ubi_provincia AS provincia,
               ug.ubi_provincia_cod AS codigo,
		fi.fit_valor as p_uso_tecnologia
	FROM "TD".dim_indicador_territorio_digitales di,
            "TD".dim_ubicacion_geografica ug,
            "TD".fact_indicadores_td fi	
          WHERE di.itd_sk = fi.fit_itd_sk 
          AND ug.ubi_sk = fi.fit_ubi_sk 
          AND di.itd_sk =230
          AND ug.ubi_parroquia is null
          AND ug.ubi_canton is null
          AND fi.fit_fecha = '2014-12-31') u
	  ON(u.codigo = i.codigo)

JOIN (	SELECT extract(year from fi.fit_fecha) AS anio,
               ug.ubi_provincia_cod AS codigo,
		fi.fit_valor as p_capacidad_t_instalada
	FROM "TD".dim_indicador_territorio_digitales di,
            "TD".dim_ubicacion_geografica ug,
            "TD".fact_indicadores_td fi
            WHERE di.itd_sk = fi.fit_itd_sk 
          AND ug.ubi_sk = fi.fit_ubi_sk 
          AND di.itd_sk =231
          AND ug.ubi_parroquia is null
          AND ug.ubi_canton is null
          AND fi.fit_fecha = '2014-12-31') c
	  ON(c.codigo = i.codigo)

JOIN (	SELECT extract(year from fi.fit_fecha) AS anio,
		ug.ubi_provincia AS provincia,
               ug.ubi_provincia_cod AS codigo,
		fi.fit_valor as idv3
	FROM "TD".dim_indicador_territorio_digitales di,
            "TD".dim_ubicacion_geografica ug,
            "TD".fact_indicadores_td fi	
          WHERE di.itd_sk = fi.fit_itd_sk 
          AND ug.ubi_sk = fi.fit_ubi_sk 
          AND di.itd_sk =159
          AND ug.ubi_parroquia is null
          AND ug.ubi_canton is null
          AND fi.fit_fecha = '2014-12-31') v
	  ON(v.codigo = i.codigo)

JOIN (	SELECT  extract(year from fi.fit_fecha) AS anio,
		ug.ubi_provincia,
	ug.ubi_provincia_cod AS codigo,
	sum(fi.fit_valor) AS poblacion 
	FROM "TD".dim_indicador_territorio_digitales di,
            "TD".dim_ubicacion_geografica ug,
            "TD".fact_indicadores_td fi	
          WHERE di.itd_sk = fi.fit_itd_sk 
          AND ug.ubi_sk = fi.fit_ubi_sk 
          AND di.itd_sk =160
         AND fi.fit_fecha = '2014-12-31'
          group by fi.fit_fecha, ug.ubi_provincia,ug.ubi_provincia_cod) p
	  ON(p.codigo = i.codigo)
	