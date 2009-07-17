
module Hesine 

  class << self
        
    def params_builder(prarams = {})         
       encoded_params = encode_hash(prarams)  
        data = Builder::XmlMarkup.new( :target => out_string = "", :indent => 2 )
        data.instruct!  
        data.XML{
          data.System{
            data.SystemID(@config['system_id'])
            data.MsgID('0')
            data.Signature(@config['signature'])
            data.Command(encoded_params[:command])
          } 
          data.User{
            data.UserId(encoded_params[:user_id])
            data.Phone(encoded_params[:phone]) 
            data.VerifyCode(encoded_params[:verify_code])
          }
        }
        return out_string  
    end 
    
    def load_configuration(config_file)
       @config = YAML.load(ERB.new(File.read(config_file)).result)[RAILS_ENV]
    end
    
    def request(xml)
      resource = RestClient::Resource.new 'http://www.hesine.com/openapi'   
      Crack::XML.parse(resource.post(params_builder, :content_type => 'application/xml'))['Xml']
    end
    
    def url_encode(str)
    	return str.gsub!(/[^\w$&\-+.,\/:;=?@]/) { |x| x = format("%%%x", x[0])}
    end
    
    def encode_hash(hash)        
      temp = {}
      hash.each_pair{|key,value|  temp.merge(key.to_sym => url_encode(value))}
    end
    
  end
end
