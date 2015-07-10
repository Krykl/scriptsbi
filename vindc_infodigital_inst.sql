select 
año,
institucion,
conx_ws,
conx_pweb,
round(((know_infod + interop_tram + conx_dinardap + mn_proc_infod + infod_norm_inst + virt_tram + 
plan_less_tram + 4*log_conx_ws + 4*log_conx_pweb)/15)::numeric,4) as indice,

row_number() OVER (ORDER BY ((know_infod + interop_tram + conx_dinardap + mn_proc_infod + infod_norm_inst + virt_tram + 
plan_less_tram + 4*log_conx_ws + 4*log_conx_pweb)/15) DESC,know_infod DESC,institucion ASC) as ranking

from "INST".vdata_infod_inst_std