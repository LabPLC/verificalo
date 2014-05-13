class StatusController < ApplicationController

  def check
    render inline: response_hash.to_json
  end

  private

  def template
    {
      dependencies: nil,
      status: nil,
      updated: nil,
      resources: nil
    }
  end

  def response_hash
    {}.tap do |res|
      template.each_key do |k|
        res[k] = send(k)
      end
    end
  end

  def dependencies
    [ "postgres" ]
  end

  def status
    database_works? ? "ok" : "NOT OK"
  end

  def updated
    Time.now.to_i
  end

  def resources
    {}
  end

  def database_works?
    ActiveRecord::Base.connected?
  end

end
