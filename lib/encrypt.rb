DEFAULT_ALPHABET = (("a".."z").to_a + ("A".."Z").to_a + " 1234567890!@#$%^&*()_+=-|}{?':><~/.".split("")).join


def validate_alphabet(alphabet, string)

    string.split("").each do |char|

        if !(alphabet.include? char)

            raise "your string contains characters that are not defined in the charset"
            
        end 

    end 

end 


def gen_text_key(seed, alphabet)

    alp = alphabet.shuffle(random: seed)
    shuffled_pairs = []

    alp.each_with_index do |char, index| 

        if index != alp.length - 1

            shuffled_pairs << [char, alp[index + 1]]

        else 

            shuffled_pairs << [char, alp[0]]

        end 

    end 

    shuffled_pairs

end 

def jumble_string(key, string)

    key_inds = key.map {|x| x[0]}
    new_str = ""
    string.split("").each do |char| 

        new_str += key[key_inds.index(char)][1]

    end 

    return new_str

end 


def key_to_num(key, alphabet)

    key.map {|x| [alphabet.index(x[0]), alphabet.index(x[1])]}

end 


def find_ld(f, s, alphabet)

    if !(f == 0 or s == 0)
        highest = 0
        (2..(alphabet.length)).to_a.each do |n| 
            if (f % n == 0) and (s % n == 0)

                highest = n

            end 

        end 

        return [f/highest, s/highest, highest] if highest != 0 

    end 

    return [f, s, 1]

end 



def to_phasekey(key, alphabet)

    phase_key = []
    key.each do |f, s| 
        
        ld = find_ld(f, s, alphabet)
        phase_key << ("#{ld[0]}.#{ld[1]}0#{ld[2]}")

    end 

    return phase_key.join("|")

end 


def encrypt(strings, alphabet, seed=Random.new(rand(100_000)))

    alphabet = DEFAULT_ALPHABET if alphabet.nil? 
    alphabet = alphabet.split("")
    strings.each {|x| validate_alphabet(alphabet, x)}
    string_array = Array.new
    text_key = gen_text_key(seed, alphabet) 
    index_key = key_to_num(text_key, alphabet)
    phase_key = to_phasekey(index_key, alphabet)

    strings.each do |string| 
        
        string_array << jumble_string(text_key, string)

    end 


    
    return string_array, phase_key

end
