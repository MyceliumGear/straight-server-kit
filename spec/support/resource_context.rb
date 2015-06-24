shared_context 'resources' do
  let(:gateway_id) { 'a55c73f90728ea2750c0d92151e14f960a4cee1e3bca0cf2da8312573a98a8c5' }
  let(:gateway_secret) { 'qx1r05e9i38q3g0lnknwaiwjeaufquw4wsmtra2nj5jqyl9m2jlx27jhclmm2mzp' }
  let(:client) { StraightServerKit::Client.new(url: 'http://gear.loc', gateway_id: gateway_id, secret: gateway_secret) }
end
