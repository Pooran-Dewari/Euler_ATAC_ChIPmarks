
######## get filenames prefixes ###########
for fname in *broadPeak
do
  tmp=$(echo "$fname" | awk -F '_' '{print $1"_"$2"_"$3}' )
  newfname=${tmp}
  echo $newfname >> narrowPeak_tmp.txt
done;

sort -u narrowPeak_tmp.txt > narrowPeak_list.txt
rm narrowPeak_tmp.txt
################################## use filenames prefixes to create sub-directories for each stage  & mv files

while read i;
do
mkdir "$i"
cp *idr "$i" #copy the IDR file for intervene later
find . -name "$i" -prune -o -type f -exec \
    grep -q "$i" "{}" \; -exec cp "{}" "$i" \;
done <  narrowPeak_list.txt


#now do intervene for each directory

while read i;
do
    cd "$i"
    #list narrowPeak files and sort based on column 8
    ls *broadPeak | while read filename;
    do
        sort -k8,8nr $filename > $filename"_sorted";
    done

    #next split sorted narrowPeak file into top/mid/bottom categories
    ls *sorted | while read SORTED;
    do
        Peaks=$(($(wc -l $SORTED | awk '{print $1}') / 3))
        #Peaks=$(awk -v v="$Peaks" 'BEGIN{printf "%d", v}')
        awk -v range="$Peaks" 'FNR>=1 && FNR<=range' $SORTED > $SORTED"_top"
        awk -v range="$Peaks" 'FNR>=range && FNR<=range + range' $SORTED > $SORTED"_mid"
        awk -v range="$Peaks" 'FNR>=range + range && FNR<=range + range + range' $SORTED > $SORTED"_bottom"
    done

    #now intervene
    conda activate intervene
    intervene venn -i *idr *sorted_* --title "$i" --names=ATAC,bottom,mid,top --output "$i"_overlap --save-overlaps
        cd "$i"_overlap/sets
        #create overlap df for R
        wc -l *bed | awk 'NR==1 {print "file","overlap"}; {print $2, $1}' OFS='\t' | grep -v 'total' > "$i"_overlap.txt
        #run euler script here to make proportional venn diagram
    conda deactivate
        Rscript ../../../Euler_for_idr_and_chip_v2.R
    cd ../../..
done <  narrowPeak_list.txt


#mv overlap venn
mkdir Venn_diagram
mv **/*/*/*jpg  ./Venn_diagram


echo "************done ***********"
echo " *********bye for now******"

