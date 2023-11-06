.text
.globl user_main
.globl control_logic

user_main:
  jal control_logic

infinite_loop: 
  j infinite_loop
