require 'erb'

module StubsHelper

  def stub_datalab(res)
    filename = File.join(Rails.root, 'stubs/datalab', res + '.json.erb')
    body = ERB.new(File.read(filename))
    stub_request(:get, /datos.labplc.mx/).to_return(body: body.result)
  end

end
