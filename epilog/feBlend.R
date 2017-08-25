#' @section feBlend Mode Details:
#' feBlend Modes are defned as follows
#' 
#' **normal mode (no blending)**
#' 
#' $$ \alpha_{out} = 1 - (1- \alpha_{in1})  (1- \alpha_{in2}) $$
#' $$ \alpha_{out}  \times C_{out} =(1-\alpha_{in2})  \alpha_{in1} C_{in1} + \alpha_{in1}  C_{in1} $$
#' 
#' **multiply blend mode**
#' 
#' $$ \alpha_{out} = 1 - (1- \alpha_{in1}) \times (1- \alpha_{in2)} $$
#' $$\alpha_{out}  \times C_{out} = (1-\alpha_{in2})  \alpha_{in1} C_{in1} + (1-\alpha_{in1})  \alpha_{in2} C_{in2} + \alpha_{in1} \alpha_{in2}  C_{in1}   C_{in2} $$
#' 
#' **screen blend mode**
#' 
#' $$ \alpha_{out} = 1 - (1- \alpha_{in1}) \times (1- \alpha_{in2)} $$
#' $$ \alpha_{out}  \times C_{out} = \alpha_{in1} C_{in1} + \alpha_{in2} C_{in2} + \alpha_{in1} \alpha_{in2}  C_{in1}   C_{in2} $$
#' 
#' **darken blend mode**
#' 
#' $$ \alpha_{out} = 1 - (1- \alpha_{in1}) \times (1- \alpha_{in2)} $$
#' $$\alpha_{out}  \times C_{out} = min( (1-\alpha_{in1})  \alpha_{in2} C_{in2} + \alpha_{in1}C_{in1}, (1-\alpha_{in2})  \alpha_{in1} C_{in1} + \alpha_{in2}C_{in2} )$$
#' 
#' **lighten blend mode**
#' 
#' $$ \alpha_{out} = 1 - (1- \alpha_{in1}) \times (1- \alpha_{in2)}$$
#' $$ \alpha_{out}  \times C_{out} = max((1-\alpha_{in1}) \times \alpha_{in2} C_{in2} + \alpha_{in1}C_{in1},(1-\alpha_{in2}) \times \alpha_{in1} C_{in1} + \alpha_{in2}C_{in2})$$
#' 
