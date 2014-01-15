comp=ifort
opt=  -zero -nowarn
#opt=  -lpthread -nbs -zero -nowarn
optfor90= -O2  $(opt)
#optfor90= -g  -traceback $(opt)
optfor90t= -O2   $(opt)

AlphaBayes: Global.o ReadParam.o ReadData.o  \
	$(comp) $(optfor90) Global.o ReadParam.o ReadData.o  \
	  -o AlphaBayes \
	mv a.out weibull.exe

Global.o: Global.f90
	$(comp) -c $(optfor90) -o Global.o Global.f90

ReadParam.o: ReadParam.f90
	$(comp) -c $(optfor90) -o ReadParam.o ReadParam.f90

ReadData.o: ReadData.f90
	$(comp) -c $(optfor90) -o ReadData.o ReadData.f90

InitiateSeed.o: InitiateSeed.f90
	$(comp) -c $(optfor90) -o InitiateSeed.o InitiateSeed.f90

PearsnR4.o: PearsnR4.f90
	$(comp) -c $(optfor90) -o PearsnR4.o PearsnR4.f90

RidgeRegression.o: RidgeRegression.f90
	$(comp) -c $(optfor90) -o RidgeRegression.o RidgeRegression.f90

gasdev.o: gasdev.f90
	$(comp) -c $(optfor90) -o gasdev.o gasdev.f90

momentR4.o: momentR4.f90
	$(comp) -c $(optfor90) -o momentR4.o momentR4.f90

ran1.o: ran1.f90
	$(comp) -c $(optfor90) -o ran1.o ran1.f90

random_order.o: random_order.f90
	$(comp) -c $(optfor90) -o random_order.o random_order.f90

clean:
	rm -f *.o *.mod *.lst