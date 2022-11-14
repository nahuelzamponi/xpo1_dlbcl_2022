


#tab <- read.table('toledo_aly_if_quantif.txt', h=F)
#tab <- read.table('ocily1_aly_if_quantif.txt', h=F)
#tab <- read.table('p4936_aly_if_quantif.txt', h=F)
#tab <- read.table('ocily1_eif4e_if_quantif.txt', h=F)
#tab <- read.table('toledo_eif4e_if_quantif.txt', h=F)



boxplot(tab$V1~tab$V2)

krus <- kruskal.test(tab$V1~tab$V2)
summary(krus)

pairwise.wilcox.test(tab$V1, tab$V2, p.adjust.method = "BH")






########################################
t.test(tab$V1~tab$V2)







########################################
#plot

pdf(file='p4936_aly_if.pdf', height=6, width=4)
boxplot(tab$V1~tab$V2, las=1, ylab='Aly average nuclear MFI', xlab='')
dev.off()



#pdf(file='toledo_aly_if.pdf', height=8, width=6)
pdf(file='ocily1_aly_if.pdf', height=8, width=6)
boxplot(tab$V1~tab$V2, las=1, ylab='Aly average nuclear MFI', xlab='')
dev.off()



#pdf(file='toledo_eif4e_if.pdf', height=8, width=6)
pdf(file='ocily1_eif4e_if.pdf', height=8, width=6)
boxplot(tab$V1~tab$V2, las=1, ylab='eIF4E average nuclear MFI', xlab='')
dev.off()







