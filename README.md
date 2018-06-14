# detectRuns.2018

ROH Detection Workflow with detectRUNS R package

# Installation

  - Download and install GitBash
    - (Optional) PLINK
  - Open a GitBash console.
  - cd to your working directory (example: my_working_dir): ```cd /c/Users/MyUsername/Documents/my_working_dir```
  - ```git clone https://github.com/hernanmd/cgaTOH.2018.git; cd cgaTOH.2018/src```
  - Put your .PED/.MAP or multiple .PED/.MAP files into the new directory
    - (Optional) If your PED/MAP has many chromosomes: PLINK can split using the --chr parameter: ```for c in $(seq 1 29); do plink --file my_input --out 
my_input_chr$c --chr $c --recode tab --cow; done```

# Input files

  - (Optional) Check your .PED file is separated by spaces: ```tr '\t' ' ' < pedmaps/my_ped_tab.ped > pedmaps/my_ped_spaced.ped```

# Usage

From command line:

```R
Rscript run_detectRuns.R
```

# License

This software is licensed under the MIT License.

Copyright Hernán Morales Durand, 2018.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the 
Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
Authors

Hernán Morales Durand
