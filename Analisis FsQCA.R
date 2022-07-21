#Instalamos y cargamos paquetes necesarios
install.packages("QCA")
library(QCA)
#Importamos base de datos y visualizamos
BDQCA <- read.delim2("C:/Users/Cynth/OneDrive/Desktop/TFG/ULTIMOS/DBQCA.txt")
View(BDQCA)
#Paso 1: CALIBRACION
BDQCA$GEN<- calibrate(BDQCA$GEN, thresholds = "e=0.2, c=0.5,i=0.8")
BDQCA$NS<- calibrate(BDQCA$NS, thresholds = "e=-3.17, c=-0.67,i=0.71")
BDQCA$CNT<- calibrate(BDQCA$CNT, thresholds = "e=-1.29, c=0.11,i=2.13")
BDQCA$ACT<- calibrate(BDQCA$ACT, thresholds = "e=-1.7, c=-0.2,i=1.22")
BDQCA$INT<- calibrate(BDQCA$INT, thresholds = "e=-0.96, c=0.3,i=1.83")
#Paso 2: ANALISIS DE NECESIDAD
#Consistencia y cobertura de GEN en INT, utilizando formulas
with(BDQCA, sum(fuzzyand(BDQCA$GEN, BDQCA$INT))/sum(BDQCA$INT))
with(BDQCA, sum(fuzzyand(BDQCA$GEN, BDQCA$INT))/sum(BDQCA$GEN))
#funcion pof
pof(BDQCA$GEN, BDQCA$INT, relation = "necessity")
pofind(BDQCA, INT, conditions = "GEN,ACT,CNT,NS", relation = "necessity")
#Graficos XY
XYplot(GEN, INT, data = BDQCA, jitter = TRUE, relation = "necessity")
XYplot(ACT, INT, data = BDQCA, jitter = TRUE, relation = "necessity")
XYplot(NS, INT, data = BDQCA, jitter = TRUE, relation = "necessity")
XYplot(CNT, INT, data = BDQCA, jitter = TRUE, relation = "necessity")
#Combinaciones causales
superSubset(BDQCA, outcome = "INT", incl.cut = 0.7, cov.cut = 0.7)
#Paso 3: ANALISIS DE SUFICIENCIA
pof(BDQCA$GEN, BDQCA$INT, relation = "sufficiency")
pofind(BDQCA, INT, conditions = "GEN,ACT,CNT,NS", relation = "sufficiency")
#Graficos XY
XYplot(GEN, INT, data = BDQCA, jitter = TRUE, relation = "sufficiency")
XYplot(ACT, INT, data = BDQCA, jitter = TRUE, relation = "sufficiency")
XYplot(NS, INT, data = BDQCA, jitter = TRUE, relation = "sufficiency")
XYplot(CNT, INT, data = BDQCA, jitter = TRUE, relation = "sufficiency")
#Tabla de verdad
ttrows <- apply(NF[, 1:4], 2, function(x) as.numeric(x > 0.5))
rownames(ttrows) <- rownames(NF)
ttrows
truthTable(BDQCA, outcome = "INT", conditions = "GEN, NS, CNT, ACT",incl.cut=0.8 ,complete = TRUE, show.cases = FALSE)
#Minimizacion logica
minimize(BDQCA, outcome="INT", conditions ="GEN, ACT, CNT, NS", incl.cut=0.8)
minimize(BDQCA, outcome="~INT", conditions ="GEN, ACT, CNT, NS", incl.cut=0.8)
