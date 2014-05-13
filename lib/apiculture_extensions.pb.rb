##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'


##
# Imports
#
# require 'google/protobuf/descriptor.pb'


##
# Message Classes
#
class ApicultureServiceOptions < ::Protobuf::Message
  class HttpMethod < ::Protobuf::Enum
    define :GET, 1
    define :POST, 2
    define :PUT, 3
    define :DELETE, 4
  end

end



##
# Message Fields
#
class ApicultureServiceOptions
  optional :string, :path, 1
  optional ::ApicultureServiceOptions::HttpMethod, :method, 2, :default => ::ApicultureServiceOptions::HttpMethod::POST
  repeated :string, :content_type, 3
end


##
# Extended Message Fields
#
class ::Google::Protobuf::MethodOptions < ::Protobuf::Message
  optional ::ApicultureServiceOptions, :api_service, 50005, :extension => true
end

class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
  optional :float, :my_field_option, 50002, :extension => true
end

