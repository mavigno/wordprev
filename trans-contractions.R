contractions <- read.csv2("contractions.csv",stringsAsFactors=FALSE)
transvr <- names(vr)
for (i in 1:nrow(contractions)) {
        from <- paste0("^",contractions[i,"word"],"$")
        to <- contractions[i,"trans"]
        transvr <- gsub(from,to,transvr)
}
names(vr) <- transvr
save(vr,file="data/vocabulary-reduced.rds")
save(contractions,file="data/contractions.rds")
