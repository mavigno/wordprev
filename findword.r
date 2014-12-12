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
        return(result)


}

babble <- function(word,n=10) {
        sent <- word
        for (i in 1:n) {
                words <- findWord(word)
                found <- words[round(runif(1,min=1,max=3))]
                sent <- c(sent,found)
                word <- last4(c(word,found))
        }
        print(paste(sent,collapse=" "))
}
