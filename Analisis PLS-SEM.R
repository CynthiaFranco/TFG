#Cargamos los paquetes necesarios
library(seminr)
library(readxl)
library(xlsx)
#Importamos la base de datos y visualizamos
BD <- read_excel("C:/Users/Cynth/OneDrive/Desktop/TFG/ULTIMOS/BD.xlsx")
View(BD)
#Creacion del modelo de medida
medidas <- constructs(composite("GEN", single_item("GEN"), weights = mode_A), composite("NS", multi_items("NS", 1:3),weights = mode_A),composite("CNT", multi_items("CNT",1:4), weights = mode_A), composite("ACT", multi_items("ACT", 1:4), weights = mode_A),composite("INT", multi_items("INT",1:3), weights = mode_A))
#Creacion del modelo estructural
estructural <- relationships(paths(from="GEN", to="INT"),paths(from="NS", to=c("ACT","INT","CNT")), paths(from="CNT", to="INT"), paths(from="ACT", to="INT"))
#Estimacion del modelo PLS-SEM
model <- estimate_pls(data=BD,measurement_model = medidas, structural_model = estructural, inner_weights = path_weighting)
#Grafica del modelo
plot(estructural)
#Resumen del modelo 
p=summary(model)
#Numero de iteraciones
p$iterations
#Evaluacion del modelo de medida: Medidas de consistencia interna
p$reliability
p$loadings
p$loadings^2
#Evaluacion del modelo de medida: Medidas de validez
p$validity$fl_criteria
p$validity$htmt
p$validity$cross_loadings
#Arranque Bootstrap del modelo
b=bootstrap_model(model, nboot=10000)
bootsummary<-summary(b,alpha=0.10)
bootsummary$bootstrapped_HTMT
#Obtencion valores latentes de constructos (entrada analisis FsQCA)
BDQCA<-p$composite_scores
plot_scores(model)
#Exportar valores latentes a Excel
write.xlsx(BDQCA, "C:/Users/Cynth/OneDrive/Desktop/TFG/ULTIMOS/BDQCA.xlsx")
#Evaluaion modelo estuctural
#Valores VIF (colinealidad)
p$vif_antecedents
#Relevancia e importancia de las rutas, nivel de confianza  5%
bootsummary2<-summary(b,alpha=0.05)
bootsummary2$bootstrapped_paths
#Efectos totales de las construcciones
bootsummary2$bootstrapped_total_paths
#p-values
paths <- bootsummary2$bootstrapped_paths[, "Original Est."]
tvalues <- bootsummary2$bootstrapped_paths[, "T Stat."]
df = nrow(BD)
pvalues <- round(pt(tvalues, df, lower.tail = FALSE), 3)
data.frame(paths, tvalues, pvalues)
bootsummary2$bootstrapped_total_paths
#RSquare
p$paths
#FSquare
p$fSquare
#Prediccion del modelo PLS-SEM
prediction<-predict_pls(model=model,technique = predict_DA, noFolds = 10, reps = 10)
summaryPredition<-summary(prediction)
#Errores del prediccion
plot(summaryPredition, indicator="INT1")
plot(summaryPredition, indicator="INT2")
plot(summaryPredition, indicator="INT3")
summaryPredition
#Grafico completo del modelo de prediccion
plot(b, title = "Model PLS-SEM")
