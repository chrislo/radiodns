require 'resolv'

module RadioDNS
  class Resolver
    def self.resolve(fqdn)
      resolver = Resolv::DNS.new
      cname = resolver.getresource(fqdn, Resolv::DNS::Resource::IN::CNAME)
      cname.name.to_s
    end

    def self.construct_fqdn(params)
      bearer = params[:bearer]
      case bearer
        when "fm" then construct_fqdn_for_fm(params)
        when "dab" then construct_fqdn_for_dab(params)
      end
    end

    private
    def self.construct_fqdn_for_dab(params)
      raise ArgumentError unless params[:scids] && params[:sid] && params[:eid] && params[:ecc]
      [params[:appty_uatype] || params[:pa],
       params[:scids],
       params[:sid],
       params[:eid],
       params[:ecc],
       'dab.radiodns.org'].reject{|a| a.nil?}.join('.')
    end
    def self.construct_fqdn_for_fm(params)
      raise ArgumentError if params[:ecc] && params[:country]
      raise ArgumentError if params[:ecc].nil? && params[:country].nil?
      [params[:freq],
       params[:pi],
       params[:ecc] || params[:country],
       'fm.radiodns.org'].join('.')
    end
  end
end
