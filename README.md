# Euler_ATAC_ChIPmarks
Find overlap between ATAC peaks and ChIP peaks by score

What this script does?
It takes an ATAC idr file & finds overlap with ChIP-seq peak file (broken into three categories of high/mid/low score or signal)

Input required
- ATAC bed file after IDR analysis, or just any peak file
- ChIP-seq mark peak files, i.e. 2 or 3 replicates from MACS2 output (either narrowPeak or broadPeak files)
- conda environment with name 'intervene' that has intervene package installed in it

Keep .sh and .R scripts in the same directory as above Input files & just run the .sh script on bash

Please note Euler venn diagrams can be misleading if too many items to overlap
(fitted values look very different from original when euler makes the object), therefore, to simplify the venn,
this scipt only find overlap between atac & top, atac & mid, and atac & bottom peaks and ignores other combinations.
