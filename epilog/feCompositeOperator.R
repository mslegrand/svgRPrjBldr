#'  @section Composite Operator Details: 
#'  The following defines each *composite operator*. In particular, how the resulting output alpha channel ($\alpha_{out}$) and
#'  the resulting color channels $\C_{out}$) are computed from the input channels of *in1* and *in2*.
#'  
#'  **over operator**
#'  $$ \alpha_{out} = \alpha_{in1}  + \alpha_{in2}  (1-\alpha_{in1})  $$
#'  $$ \alpha_{out}  \times C_{out}  = \alpha_{in1}  C_{in1} + \alpha_{in2} (1-\alpha_{in1}) C_{in2} $$
#'  
#'  **in operator**
#'  $$ \alpha_{out} = \alpha_{in1}  \alpha_{in2}   $$
#'  $$ \alpha_{out}  \times C_{out} = \alpha_{in1}  \alpha_{in2}  C_{in1}  $$
#'  
#'  **out operator**
#'  $$ \alpha_{out} = \alpha_{in1} (1- \alpha_{in2}) )  $$
#'  $$ \alpha_{out}  \times C_{out} = \alpha_{in1} (1- \alpha_{in2})  C_{in1}  $$
#'  
#'  **atop operato**r
#'  $$ \alpha_{out} = \alpha_{in1} \alpha_{in2} + (1-\alpha_{in1}) \alpha_{in2}  $$
#'  $$ \alpha_{out}  \times C_{out} = \alpha_{in1} \alpha_{in2} C_{in1} + \alpha_{in2} (1-\alpha_{in1}) C_{in2} $$
#'  
#'  **xor operator**
#'  $$ \alpha_{out} = \alpha_{in1} ( 1- \alpha_{in2}) + (1-\alpha_{in1}) \alpha_{in2}  $$
#'   $$ \alpha_{out}  \times C_{out} = \alpha_{in1}( 1- \alpha_{in2})  C_{in1} + \alpha_{in2} (1-\alpha_{in1}) C_{in2} $$
#'  
#'  **arithemetic operator**
#'  $$ \alpha_{out} = max(0,min(1,k1 \alpha_{in1} \alpha_{in2} + k2 \alpha_{in1}+ k3 \alpha_{in2} +k4))$$
#'  $$ C_{out}= k1  C_{in1}  C_{in2}  +   k2  C_{in1} + k3  C_{in2} + k4 $$
#'  
