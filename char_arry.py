''' Bayley King, Bryan Kanu, Zach Hadden
    Char_Array creator for VHDL script

    Our VHDL code needed a clean way to "hardcode" strings as their ASCII values,
      so we made this python script that would do it for us.

    Usage:
        ins = "Some string"
        out = "CHAR_ARRAY(0 to 10) := (X"53", X"6F", X"6D", X"65", X"20", X"73", X"74", X"72", X"69", X"6E", X"67");"
          out can then be copied and pasted into the VHDL script.
'''

ins = input('Input you message: ')

len_ins = len(ins)

message = 'CHAR_ARRAY(0 to ' + str(len_ins-1) + ') := ('
for letter in range(len_ins):
    message += 'X"'+hex(ord(ins[letter]))[2:]+'"'
    if letter < len_ins-1:
        message += ','
message += ');'
print(message)