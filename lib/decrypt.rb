require_relative "encrypt.rb"

def validate_key(key)

    key_characters = ((0..9).to_a.map {|x| x.to_s} + ["|", "."])

    key.split("").each do |char| 

        if !key_characters.include?(char)

            raise "Invalid key"

        end 

    end 

end 



def key_to_num_array(key)

    new_array = []
    key.split("|").each_with_index do |float, index| 

        first, after_fp = float.split(".")
        second, divisor = after_fp[0..2], after_fp[4..5] if after_fp.length == 5 
        second, divisor = after_fp.split("0") if after_fp.count("0") == 1

        if after_fp.count("0") > 1

            zero_indexs = after_fp.split("").map.with_index {|p, ind| ind if p == "0" }.delete_if {|x| x.nil?}
            slicer = !(after_fp[1] == "0" and after_fp[-1] == "0") ? zero_indexs[1] : zero_indexs[0]
            second, divisor = [after_fp[0..slicer-1], after_fp[slicer..-1]]

        end 

        new_array << [first, second, divisor]

    end 

    
    return new_array

end 


def compute_divisor_in_array(key_array)

    a = key_array.map.with_index do |value, index| 
        
        [value[0].to_i*value[2].to_i, value[1].to_i*value[2].to_i]

    end 

    return a

end 


def match_to_alphabet(key_array, alphabet)

    char_array = key_array.map do |value| 

        [alphabet[value[1]], alphabet[value[0]]]

    end 

    return char_array

end 


def solve_string(string, key)

    key_indexs = key.map {|x| x[0]}
    new_str = ""
    string.split("").each do |char|

        new_str += key[key_indexs.index(char)][1]

    end 

    return new_str

end 



def decrypt(strings, key, alphabet)

    alphabet = DEFAULT_ALPHABET if alphabet.nil? 
    alphabet = alphabet.split("")
    validate_key(key)
    raw_num = key_to_num_array(key)
    num_array = compute_divisor_in_array(raw_num)
    char_key_array = match_to_alphabet(num_array, alphabet)
    decrypted_strings = []

    strings.each do |string| 
        decrypted_strings << solve_string(string, char_key_array)
    end 

    return decrypted_strings

end 

