require_relative "encrypt.rb"

def encrypt_file(path_name, alphabet) 

    if File.exists?(path_name)

        return encrypt(File.open(path_name).readlines().map {|x| x.chomp.strip}, alphabet)

    else 

        raise "specified file (#{path_name}) does not exist"

    end 

end 


def decrypt_file(path_name, key, alphabet)

    if File.exists?(path_name)

        return decrypt(File.open(path_name).readlines().map {|x| x.chomp.strip}, key, alphabet)

    else 

        raise "specified file (#{path_name}) does not exist"

    end 

end 



