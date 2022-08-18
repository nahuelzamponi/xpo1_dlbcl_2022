
#tab <- read.table('aly_crm1.txt', h=T)
tab <- read.table('eif4e_crm1.txt', h=T)





cells <- as.vector(unique(tab[which(tab$condition == 'minus_myc'), ]$cell))

count = c()
for (i in 1:length(cells)) {
	count = c(count, length(tab[which((tab$condition == 'minus_myc') & (tab$cell == cells[i])), ]$area_um2))
}

myc_minus <- count
myc_minus_all <- tab[which(tab$condition == 'minus_myc'), ]$area_um2






cells <- as.vector(unique(tab[which(tab$condition == 'plus_myc'), ]$cell))

count = c()
for (i in 1:length(cells)) {
	count = c(count, length(tab[which((tab$condition == 'plus_myc') & (tab$cell == cells[i])), ]$area_um2))
}

myc_plus <- count
myc_plus_all <- tab[which(tab$condition == 'plus_myc'), ]$area_um2






#pdf('number_pla_spots_aly_crm1.pdf', height=5, width=3)
pdf('number_pla_spots_eif4e_crm1.pdf', height=5, width=3)
boxplot(myc_minus, myc_plus, names=c('myc -', 'myc +'), ylab = 'number of pla spots')
dev.off()

#pdf('size_pla_spots_aly_crm1.pdf', height=5, width=3)
pdf('size_pla_spots_eif4e_crm1.pdf', height=5, width=3)
boxplot(log10(myc_minus_all), log10(myc_plus_all), names=c('myc -', 'myc +'), ylab = 'log10(spot size)')
dev.off()
