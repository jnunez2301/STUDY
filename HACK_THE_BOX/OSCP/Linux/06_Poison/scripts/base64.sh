for((i=0;i<13;i++))
do
cat salida$i | base64 -d > salida$((i+1))
done