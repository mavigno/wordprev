library(data.table)
library(tm)
library(stringr)
library(NLP)
library(openNLP)
load("data/n2rF.rds")
load("data/n3rF.rds")
load("data/n4rF.rds")
load("data/n5rF.rds")
load("data/vocabulary-reduced.rds")
load("data/contractions.rds")
lastSentence <- function(texto) {
        if (str_length(texto) < 1) {
                return("")
        }
        sent_token_annotator <- Maxent_Sent_Token_Annotator(language="en")
        s <- as.String(texto)
        as <- annotate(s,sent_token_annotator)
        sentences <-as.vector(s[as])
        l <- length(sentences)
        sentence <- str_trim(sentences[l])
        return(sentence)  
}
normalize <- function(sentence) {
        sentence <- tolower(sentence)
        sentence <- gsub("^(.*)$","SOS \\1",sentence)
        sentence <- removePunctuation(sentence,preserve_intra_word_dashes = TRUE)
        sentence <- gsub(" - "," ",sentence)
        sentence <- removeNumbers(sentence)
        sentence <- stripWhitespace(sentence)
        return(sentence)
}
last4 <- function(sentence) {
        words <- unlist(str_split(sentence,"\\W+"))
        l <- length(words)
        from <- l - 3
        to <- l
        if ( l > 4) words <- words[from:to]
        words <- transContractions(words)
        return(words)
}
findWord <- function(words) {
        iWords <- vr[words]
        iWords[is.na(iWords)] <- vr['UNK']

        result <- vector()
        l <- length(iWords)
        if (l == 4) {
                result <- c(result,unlist(n5r[data.table(w0=iWords[1],w1=iWords[2],w2=iWords[3],w3=iWords[4],key="w0,w1,w2,w3")]$w4))
                iWords <- iWords[-1]
                l <- length(iWords)
        }
        if (l == 3) {
                result <- c(result,unlist(n4r[data.table(w0=iWords[1],w1=iWords[2],w2=iWords[3],key="w0,w1,w2")]$w3))
                iWords <- iWords[-1]
                l <- length(iWords)
        }
        if (l == 2) {
                result <- c(result,unlist(n3r[data.table(w0=iWords[1],w1=iWords[2],key="w0,w1")]$w2))
                iWords <- iWords[-1]
                l <- length(iWords)
        }
        if (l == 1) {
                result <- c(result,unlist(n2r[data.table(w0=iWords[1],key="w0")]$w1))
                iWords <- iWords[-1]
                l <- length(iWords)
        }
        result <- result[!is.na(result)]
        result <- names(vr[result])
        result <- result[!duplicated(result)]
        result <- transContractions(result)
        return(result)
        

}

babble <- function(sentenca,n=1,random=FALSE) {
        sent <- normalize(lastSentence(sentenca))
        word <- last4(str_trim(sent))
        sent <- str_split(sentenca,"\\W+")
        sent <- sent[-1]
        for (i in 1:n) {
                words <- findWord(word)
                if (random) found <- words[round(runif(1,min=1,max=3))]
                else found <- words[1]
                sent <- c(sent,found)
                word <- last4(c(word,found))
        }
        return(paste(sent,collapse=" "))
}

transContractions <- function(transvr) {
        for (i in 1:nrow(contractions)) {
                from <- paste0("^",contractions[i,"word"],"$")
                to <- contractions[i,"trans"]
                transvr <- gsub(from,to,transvr)
        }
        return(transvr)
}
