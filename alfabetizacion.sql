SELECT i.anios AS a,
    i.pais,
    round(i.gastoturist::numeric, 2) AS gastoturist,
    round(p.alfabetizacion ::numeric, 2) AS alfabetizacion,
    round(o.Infrateleco ::numeric, 2) AS Infrateleco,
     round(e.  Inverteleco ::numeric, 2) AS   Inverteleco
	
 FROM 
 
(SELECT 	extract(year from fact_indicador.fin_fecha) AS anios,
		dim_pais.pai_pais AS pais,
		dim_indicador.ind_tipo AS tipo,
		fact_indicador.fin_valor AS gastoturist
		FROM dim_indicador,
		dim_pais ,
		fact_indicador
		WHERE dim_indicador.ind_sk = fact_indicador.fin_ind_sk 
		AND dim_pais.pai_sk = fact_indicador.fin_pai_sk 
		AND dim_indicador.ind_tipo = 'WDI'  
		AND dim_indicador.ind_sk = 900
		AND dim_pais.pai_sk in (239,210,294,272,292,150,204,206)
		AND dim_indicador.ind_sk = fact_indicador.fin_ind_sk) i 
        
 join 		(SELECT extract(year from fact_indicador.fin_fecha) AS anios,
		dim_pais.pai_pais AS pais,
		dim_indicador.ind_tipo AS tipo,
		fact_indicador.fin_valor AS alfabetizacion
		FROM dim_indicador,
		dim_pais,
		fact_indicador
		WHERE dim_indicador.ind_sk = fact_indicador.fin_ind_sk 
		AND dim_pais.pai_sk = fact_indicador.fin_pai_sk 
		AND dim_indicador.ind_tipo = 'WDI'
		AND dim_indicador.ind_sk = 938
		AND dim_pais.pai_sk in (239,210,294,272,292,150,204,206)
		AND dim_indicador.ind_sk = fact_indicador.fin_ind_sk) p ON i.anio = p.anio and i.pais = p.pais 

join 	(SELECT extract(year from fact_indicador.fin_fecha) AS anios,
		dim_pais.pai_pais AS pais,
		dim_indicador.ind_tipo AS tipo,
		fact_indicador.fin_valor AS Infrateleco
		FROM dim_indicador,
		dim_pais,
		fact_indicador
		WHERE dim_indicador.ind_sk = fact_indicador.fin_ind_sk 
		AND dim_pais.pai_sk = fact_indicador.fin_pai_sk 
		AND dim_indicador.ind_tipo = 'TI'
		AND dim_indicador.ind_sk = 414
		AND dim_pais.pai_sk in (239,210,294,272,292,150,204,206)
		AND dim_indicador.ind_sk = fact_indicador.fin_ind_sk) o ON i.anio = o.anio and i.pais = o.pais

   join 	(SELECT extract(year from fact_indicador.fin_fecha) AS anios,
		dim_pais.pai_pais AS pais,
		dim_indicador.ind_tipo AS tipo,
		fact_indicador.fin_valor AS Inverteleco
		FROM dim_indicador,
		dim_pais,
		fact_indicador
		WHERE dim_indicador.ind_sk = fact_indicador.fin_ind_sk 
		AND dim_pais.pai_sk = fact_indicador.fin_pai_sk 
		AND dim_indicador.ind_tipo = 'ITU'
		AND dim_indicador.ind_sk = 1963
		AND dim_pais.pai_sk in (239,210,294,272,292,150,204,206)
		AND dim_indicador.ind_sk = fact_indicador.fin_ind_sk) e ON i.anio = e.anio and i.pais = e.pais
order by i.anio
 
