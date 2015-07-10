SELECT e.anio AS a,
    e.pais,
    round(o.nri::numeric, 4) AS nri,
    e.pilar,
    round(p.vpilar::numeric, 4) AS vpilar, 
    e.indicador,
    round(e.valor::numeric, 4) AS valor
    	
 FROM 
 
(SELECT extract(year from fact_indicador.fin_fecha) AS anio,
		dim_pais.pai_pais AS pais,
		dim_indicador.ind_padre AS pilar,
		dim_indicador.ind_indicador AS Indicador,
		fact_indicador.fin_valor AS Valor
		FROM dim_indicador,
		dim_pais,
		fact_indicador 
		WHERE dim_indicador.ind_sk = fact_indicador.fin_ind_sk 
		AND dim_pais.pai_sk = fact_indicador.fin_pai_sk 
		AND dim_indicador.ind_tipo = 'NRI'  
		AND dim_indicador.ind_nivel = 1
		AND dim_pais.pai_sk in (239,210,294,272,292,150,204,206)
		AND dim_indicador.ind_sk = fact_indicador.fin_ind_sk) e

JOIN (SELECT extract(year from fact_indicador.fin_fecha) AS anio,
		dim_pais.pai_pais AS pais,
		dim_indicador.ind_padre AS pilar,
		fact_indicador.fin_valor AS vpilar
		FROM dim_indicador,
		dim_pais,
		fact_indicador 
		WHERE dim_indicador.ind_sk = fact_indicador.fin_ind_sk 
		AND dim_pais.pai_sk = fact_indicador.fin_pai_sk 
		AND dim_indicador.ind_tipo = 'NRI'  
		AND dim_indicador.ind_nivel = 2
		AND dim_pais.pai_sk in (239,210,294,272,292,150,204,206)
		AND dim_indicador.ind_sk = fact_indicador.fin_ind_sk) p ON e.anio = p.anio and e.pais = p.pais and e.pilar= p.pilar

JOIN (SELECT extract(year from fact_indicador.fin_fecha) AS anio,
		dim_pais.pai_pais AS pais,
		dim_indicador.ind_indicador AS ind,
		dim_indicador.ind_padre AS pilar,
		fact_indicador.fin_valor AS nri
		FROM dim_indicador,
		dim_pais,
		fact_indicador 
		WHERE dim_indicador.ind_sk = fact_indicador.fin_ind_sk 
		AND dim_pais.pai_sk = fact_indicador.fin_pai_sk 
		AND dim_indicador.ind_tipo = 'NRI'  
		AND dim_indicador.ind_nivel = 3
		AND dim_pais.pai_sk in (239,210,294,272,292,150,204,206)
		AND dim_indicador.ind_sk = fact_indicador.fin_ind_sk) o ON e.anio = o.anio and e.pais = o.pais 
		order by (e.anio, e.pais, e.pilar)